//
//  CDOOperationQueue.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 25/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOOperationQueue.h"
#import "CDOAsyncCoreDataOperation.h"

@implementation CDOOperationQueue

- (void)addOperation:(NSOperation *)op
{
    if (!op) {
        return;
    }
    
    if([op isKindOfClass:[CDOAsyncCoreDataOperation class]])
    {
        [(CDOAsyncCoreDataOperation*)op setQueue:self];
    }
    
    if (![self.operations containsObject:op]) {
        [super addOperation:op];
    }
    
    if([op isKindOfClass:[CDOAsyncCoreDataOperation class]])
    {
        [self addOperation:[(CDOAsyncCoreDataOperation*)op nextOperation]];
    }
}

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait
{
    for (NSOperation *op in ops) {
        
        if([op isKindOfClass:[CDOAsyncCoreDataOperation class]])
        {
            [(CDOAsyncCoreDataOperation*)op setQueue:self];
        }
        
    }
    
    [super addOperations:ops waitUntilFinished:wait];
}

@end
