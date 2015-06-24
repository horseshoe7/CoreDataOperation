//
//  CDOAsynchronousCoreDataOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecord.h"

@interface CDOAsyncCoreDataOperation : NSOperation
{
    @protected
    NSManagedObjectID *_objectId;
    
    BOOL _isExecuting;
    BOOL _isFinished;
}

- (instancetype)initWithModel:(NSManagedObject*)model;

- (void)work;  // should call finish inside of this method somewhere, or once your work is done, if asynchronous

- (void)finish;  // you'll see...

@end
