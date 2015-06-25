//
//  CDOTestLinkOperation.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 25/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOTestLinkOperation.h"
#import "CDORenameUserOperation.h"
#import "CDOUser.h"

@implementation CDOTestLinkOperation

- (void)work
{
    if (!self.previousOperation) {
        [self finish];
        return;
    }
    
    if (![self.previousOperation isKindOfClass:[CDORenameUserOperation class]]) {
        NSLog(@"Was expecting the previous operation to be a rename operation!");
        [self finish];
        return;
    }
    
    CDORenameUserOperation *renameOp = (CDORenameUserOperation*)self.previousOperation;
    
    CDOUser *user = (CDOUser*)[self.localContext objectWithID:renameOp.userInfo];
    
    if ([user.username isEqualToString:@"Stephen"]) {
        
        CDORenameUserOperation *rename = [[CDORenameUserOperation alloc] initWithUser:user
                                                                          updatedName:@"What a stupid name!"
                                                                           completion:^(BOOL success, id userInfo, NSError *error) {
                                                                               NSLog(@"Renamed to what a stupid name!");
                                                                           }];
        rename.name = @"link+";
        [rename followOperation:self completionBlockBehaviour:CDOCompletionBlockFollowBehaviourCopy];
        [self.queue addOperation:rename];
    }
    
    [self finish];
}

@end
