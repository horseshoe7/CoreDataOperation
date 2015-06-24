//
//  CDODelayedAsyncOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOAsyncCoreDataOperation.h"

@interface CDODelayedAsyncOperation : CDOAsyncCoreDataOperation

@property (nonatomic, assign) NSTimeInterval delayTime;

@end
