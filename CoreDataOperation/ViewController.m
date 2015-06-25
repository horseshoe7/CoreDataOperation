//
//  ViewController.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 02/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "ViewController.h"
#import "CDOApplication.h"
#import "CDOUser.h"
#import "CDORenameUserOperation.h"
#import "CDOTestLinkOperation.h"

@interface ViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultsController;
}
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, readonly) NSFetchedResultsController *resultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUserIfRequired];  // now we don't really need this other than to create the user.
    
    //[self.resultsController performFetch:nil];
    
    CDOUser *user = [self onlyUser];
    
    self.textField.placeholder = user.username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CDOUser*)onlyUser
{
//    return (CDOUser*)[self.resultsController.fetchedObjects firstObject];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    CDOUser *onlyUser = [CDOUser MR_findFirstInContext:context];
    return onlyUser;
}

- (void)createUserIfRequired
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];  // I get in the habit of always giving the context, as it forces me to think in threads.  Some devs tell you to hide these details.
    
    CDOUser *onlyUser = [CDOUser MR_findFirstInContext:context];
    if (!onlyUser) {
        onlyUser = [CDOUser MR_createEntityInContext:context];
        onlyUser.identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        onlyUser.username = @"Stephen";
        [onlyUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (IBAction)renameUser:(id)sender
{
    // now we do something with him
    
    __weak ViewController *weakself = self;
    CDORenameUserOperation *rename = [[CDORenameUserOperation alloc] initWithUser:(CDOUser*)[self onlyUser]
                                                                      updatedName:self.textField.text
                                                                       completion:^(BOOL success, NSManagedObjectID *objectId, NSError *error)
    {
        // we defined that the completion block will be called on the main thread!
        if (error) {
            weakself.textField.placeholder = @"Validation Error!";
        }
        else
        {
            weakself.textField.text = nil;
            weakself.textField.placeholder = [weakself onlyUser].username;
        }
        
        // CAVEAT.  When you make your own subclasses, and are dealing with Core Data, it is wise to send NSManagedObjectID objects around in your userInfo.  Or at least be careful that you aren't passing NSManagedObjects from your background work methods back to the main thread.
        
        
        
    }];
    
    
    
    NSLog(@"Will add to queue now");
    
    [[CDOApplication application].backgroundQueue addOperation:rename];
}

- (IBAction)pressedMagicButton:(id)sender
{
    // create rename op
    __weak ViewController *weakself = self;
    CDORenameUserOperation *renameA = [[CDORenameUserOperation alloc] initWithUser:(CDOUser*)[self onlyUser]
                                                                      updatedName:self.textField.text
                                                                       completion:^(BOOL success, NSManagedObjectID *objectId, NSError *error)
                                      {
                                          // we defined that the completion block will be called on the main thread!
                                          if (error) {
                                              weakself.textField.placeholder = @"Validation Error!";
                                          }
                                          else
                                          {
                                              weakself.textField.text = nil;
                                              weakself.textField.placeholder = [self onlyUser].username;
                                          }
                                              
                                          // CAVEAT.  When you make your own subclasses, and are dealing with Core Data, it is wise to send NSManagedObjectID objects around in your userInfo.  Or at least be careful that you aren't passing NSManagedObjects from your background work methods back to the main thread.
                                      }];
    
    renameA.name = @"A";
    
    CDORenameUserOperation *renameB = [[CDORenameUserOperation alloc] initWithUser:(CDOUser*)[self onlyUser]
                                                                      updatedName:@"Finished"
                                                                       completion:nil];
    
    renameB.name = @"B";
    
    
    [renameB followOperation:renameA completionBlockBehaviour:CDOCompletionBlockFollowBehaviourCopy];
    
 
    [[CDOApplication application].backgroundQueue addOperation:renameA];
    [[CDOApplication application].backgroundQueue addOperation:renameB];
    
    // add testlink op
    CDOTestLinkOperation *testlink = [[CDOTestLinkOperation alloc] initWithModel:nil completion:nil];
    testlink.name = @"link";
    [testlink followOperation:renameA completionBlockBehaviour:CDOCompletionBlockFollowBehaviourCopy];
    
    [[CDOApplication application].backgroundQueue addOperation:testlink];
}

#pragma mark - Fetched Results

- (NSFetchedResultsController*)resultsController
{
    if (!_resultsController) {
        NSFetchedResultsController *controller;
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSFetchRequest *request = [CDOUser MR_requestAllSortedBy:@"username" ascending:YES inContext:context];
        
        controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                         managedObjectContext:context
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
        
        controller.delegate = self;
        _resultsController = controller;
    }
    return _resultsController;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    CDOUser *user = (CDOUser*)anObject;
    
    self.textField.text = nil;
    self.textField.placeholder = user.username;
    
}

@end
