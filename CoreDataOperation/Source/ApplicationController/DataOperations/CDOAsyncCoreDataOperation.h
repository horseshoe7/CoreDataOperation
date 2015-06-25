//
//  CDOAsynchronousCoreDataOperation.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 24/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecord.h"

typedef void(^CDOCompletionBlock)(BOOL success, id userInfo, NSError *error);

typedef NS_ENUM(NSUInteger, CDOCompletionBlockFollowBehaviour)
{
    CDOCompletionBlockFollowBehaviourLeave = 0, /* Leaves the original completion block untouched */
    CDOCompletionBlockFollowBehaviourMove = 1,  /* moves the original to the follower */
    CDOCompletionBlockFollowBehaviourCopy       /* copies the original to the follower */
};

@interface CDOAsyncCoreDataOperation : NSOperation
{
    @protected
    NSManagedObjectID *_objectId;
    
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (nonatomic, weak) NSOperationQueue *queue;  // the queue this was added to.  For convenience

@property (nonatomic, strong) NSError *error;  // these are ideally in a protected, private interface, that you would implement via a separate category header.
@property (nonatomic, strong) id userInfo;  // generally not needed to read
@property (nonatomic, copy) CDOCompletionBlock opCompletionBlock;  // generally not needed to read

@property (nonatomic, readonly) NSManagedObjectContext *localContext;

- (instancetype)initWithModel:(NSManagedObject*)model completion:(CDOCompletionBlock)completion;

- (void)work;  // should call finish inside of this method somewhere, or once your work is done, if asynchronous

- (void)finish;  // you'll see...

#pragma mark - Linking


// linked list
@property (nonatomic, weak, readonly) CDOAsyncCoreDataOperation *previousOperation;
@property (nonatomic, weak, readonly) CDOAsyncCoreDataOperation *nextOperation;

- (void)followOperation:(CDOAsyncCoreDataOperation*)operation;  // pass nil to break list.
- (void)followOperation:(CDOAsyncCoreDataOperation*)operation completionBlockBehaviour:(CDOCompletionBlockFollowBehaviour)copyBehaviour;

@end
