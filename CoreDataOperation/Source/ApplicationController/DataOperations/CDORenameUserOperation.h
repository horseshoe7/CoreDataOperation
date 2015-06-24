//
//  CDRenameUserOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOSynchronousCoreDataOperation.h"

@class CDOUser;

@interface CDORenameUserOperation : CDOSynchronousCoreDataOperation

- (instancetype)initWithUser:(CDOUser*)user updatedName:(NSString*)updatedName;

@end
