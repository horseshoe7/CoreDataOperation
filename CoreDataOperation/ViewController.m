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
    
    
    [self.resultsController performFetch:nil];
    
    CDOUser *user = [self.resultsController.fetchedObjects firstObject];
    
    self.textField.placeholder = user.username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CDOUser*)onlyUser
{
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
    CDORenameUserOperation *rename = [[CDORenameUserOperation alloc] initWithUser:(CDOUser*)[self.resultsController.fetchedObjects firstObject]
                                                                      updatedName:self.textField.text
                                                                       completion:^(BOOL success, id userInfo, NSError *error)
    {
        // we defined that the completion block will be called on the main thread!
        if (error) {
            weakself.textField.placeholder = @"Validation Error!";
        }
        
        // CAVEAT.  When you make your own subclasses, and are dealing with Core Data, it is wise to send NSManagedObjectID objects around in your userInfo.  Or at least be careful that you aren't passing NSManagedObjects from your background work methods back to the main thread.
        
        
        
    }];
    
    
    
    NSLog(@"Will add to queue now");
    
    [[CDOApplication application].backgroundQueue addOperation:rename];
}

#pragma mark - NSFetchedResultsController Related

- (NSFetchedResultsController*)resultsController
{
    if (!_resultsController) {
        
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext]; // always on the main thread!
        
        NSFetchRequest *request = [CDOUser MR_requestAllSortedBy:@"username" ascending:YES inContext:context];
        
        NSFetchedResultsController *controller = nil;
        controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                         managedObjectContext:context
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
        
        controller.delegate = self;  // DON'T FORGET!!
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
    
    if ([anObject isKindOfClass:[CDOUser class]]) {
        CDOUser *user = (CDOUser*)anObject;
        
        self.textField.placeholder = user.username;
        self.textField.text = nil;
    }
}

@end
