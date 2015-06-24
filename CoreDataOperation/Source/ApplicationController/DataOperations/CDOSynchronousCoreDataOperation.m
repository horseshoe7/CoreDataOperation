//
//  CDSynchronousCoreDataOperation.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOSynchronousCoreDataOperation.h"

@interface CDOSynchronousCoreDataOperation()

@end

@implementation CDOSynchronousCoreDataOperation

- (instancetype)initWithModel:(NSManagedObject*)model
{
    self = [super init];
    if (self) {
        
        _objectId = model.objectID;
    }
    return self;
}

- (void)main
{
    NSLog(@"Baseclass.  I do nothing!");
}

@end
