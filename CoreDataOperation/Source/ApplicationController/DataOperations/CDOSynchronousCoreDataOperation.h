//
//  CDSynchronousCoreDataOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecord.h"

@interface CDOSynchronousCoreDataOperation : NSOperation
{
    @protected
    NSManagedObjectID *_objectId;
}

- (instancetype)initWithModel:(NSManagedObject*)model;

@end
