//
//  CDOAsynchronousCoreDataOperation.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOAsyncCoreDataOperation.h"

@interface CDOAsyncCoreDataOperation()

@end

@implementation CDOAsyncCoreDataOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isExecuting = NO;
        _isFinished = NO;
    }
    return self;
}


- (instancetype)initWithModel:(NSManagedObject*)model completion:(CDOCompletionBlock)completion
{
    self = [self init];
    if (self) {
        
        self.opCompletionBlock = completion;
        
        _objectId = model.objectID;
    }
    return self;
}

#pragma mark - Overrides

// now then, the first thing we need to do is set up a few parameters for asynchronous comms.  Read the API Docs
- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

#pragma mark Hijacking

// we don't want users using the normal NSOperation completion block anymore.  We want them using ours
- (void)setCompletionBlock:(void (^)(void))block
{
    NSLog(@"You should never explicitly call setCompletionBlock: unless you are overriding in the subclass.  use setOpCompletionBlock: instead");
}

/* i.e. you can only set this property if you're writing a subclass and know what you're doing! */
- (void)_setCompletionBlock:(void (^)(void))block
{
    [super setCompletionBlock:block];
}



#pragma mark - The Meat

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
    
    // but wait!  Nothing will happen here.  Although this is an abstract baseclass, it should not fail.
    
    // so we add a 'doSomething' method that the subclasses can override
    [self work];
}

- (void)work
{
    [self finish];  // do nothing in baseclass
}

#pragma mark - Finishing up

- (void)finish
{
    if (self.isCancelled) {
        NSLog(@"Behaviour undefined.  Should it 'complete' with an error, or just silently cancel as if it had never happened?");
        [self endOperation:nil];
        return;
    }
    
    // we have to make a strong ref to these because the operation may have been deallocated by the time our completion block is called
    BOOL successful = (self.error == nil);
    id strongInfo = self.userInfo;
    NSError *strongError = self.error;

    CDOCompletionBlock strongBlock = nil;
    
    if (self.opCompletionBlock) {
        strongBlock = [self.opCompletionBlock copy];
    }
    
    [self _setCompletionBlock:^{
        // be sure to call completion block on main thread!
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (strongBlock) {
                strongBlock(successful, strongInfo, strongError);
            }
        });
    }];

    
    [self endOperation:nil];
}

- (void)endOperation:(id)sender
{
    // generate the KVO necessary for the queue to remove him
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
