//
//  CDRenameUserOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDODelayedAsyncOperation.h"

@class CDOUser;

@interface CDORenameUserOperation : CDODelayedAsyncOperation

- (instancetype)initWithUser:(CDOUser*)user
                 updatedName:(NSString*)updatedName
                  completion:(CDOCompletionBlock)completionBlock;

@end
