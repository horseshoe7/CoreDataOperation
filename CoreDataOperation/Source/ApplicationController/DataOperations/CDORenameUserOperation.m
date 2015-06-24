//
//  CDRenameUserOperation.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDORenameUserOperation.h"
#import "CDOUser.h"

@interface CDORenameUserOperation()
{
    NSString *_updatedName;
}
@end

@implementation CDORenameUserOperation

- (instancetype)initWithUser:(CDOUser*)user updatedName:(NSString*)updatedName
{
    self = [super initWithModel:user];  // keeps objectId reference.
    if (self) {
        
        _updatedName = updatedName;
    }
    return self;
}

- (void)main
{
    // we have to WAIT here, because this operation is synchronous!
    // Otherwise it would report being finished without being finished!
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        
        CDOUser *localUser = (CDOUser*)[localContext objectWithID:_objectId];  // NSManagedObjectID objects can be passed around threads, but NOT NSManagedObject models.
        
        localUser.username = _updatedName;
    }];
}

@end
