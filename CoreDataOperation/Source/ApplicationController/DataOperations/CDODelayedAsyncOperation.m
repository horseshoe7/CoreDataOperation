//
//  CDODelayedAsyncOperation.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDODelayedAsyncOperation.h"

@interface CDODelayedAsyncOperation()
{
    NSTimer *_keepAliveTimer;
    BOOL _stopRunLoop;
}
@end

@implementation CDODelayedAsyncOperation

- (void)start
{
    // this property has to be KVO observable, so we send those here and now.
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    // our work should always periodically check to see if the user's code has cancelled the operation
    if (self.isCancelled) {
        [self finish];
        return;
    }
    
    
    // run loops don't run if they don't have input sources or timers on them.  So we add a timer that we never intend to fire.
    if (self.delayTime > 0) {
        
        // RUN LOOP MAGIC
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        _keepAliveTimer = [NSTimer timerWithTimeInterval:CGFLOAT_MAX target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
        [runLoop addTimer:_keepAliveTimer forMode:NSDefaultRunLoopMode];

        [NSTimer scheduledTimerWithTimeInterval:self.delayTime target:self selector:@selector(callback:) userInfo:nil repeats:NO];

        NSTimeInterval updateInterval = 0.1f;
        NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:updateInterval];
        while (!_stopRunLoop && [runLoop runMode: NSDefaultRunLoopMode beforeDate:loopUntil])
        {
            loopUntil = [NSDate dateWithTimeIntervalSinceNow:updateInterval];
        }
    }
    else
    {
        [self work];
    }
}

- (void)timeout:(NSTimer*)timer
{
    [_keepAliveTimer invalidate];
    _keepAliveTimer = nil;
    _stopRunLoop = YES;
    [self work];
}

- (void)callback:(NSTimer*)timer
{
    [self timeout:timer];
}
                             
- (void)finish
{
    [super finish];
}

@end
