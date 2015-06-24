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


- (instancetype)initWithModel:(NSManagedObject*)model
{
    self = [self init];
    if (self) {
        
        _objectId = model.objectID;
    }
    return self;
}

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
    [self finish];
}

- (void)finish
{
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
