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
    if (self.textField.text.length > 0) {
        
        // now we do something with him
        CDORenameUserOperation *rename = [[CDORenameUserOperation alloc] initWithUser:(CDOUser*)[self.resultsController.fetchedObjects firstObject]
                                                                          updatedName:self.textField.text];
        
//        __weak ViewController *weakself = self;
//        [rename setCompletionBlock:^{
//            
//            // according to the API docs, there is no guarantee this will be called on the main thread.  So, let's guarantee that.
//            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                NSLog(@"Completed!");
//                
//                weakself.textField.placeholder = [weakself user].username;
//                weakself.textField.text = nil;
//                
//            }];
//            
//            // equivalently, you could use gcd:
//            //        dispatch_async(dispatch_get_main_queue(), ^{
//            //
//            //        });
//            
//        }];
        
        NSLog(@"Will add to queue now");
        
        [[CDOApplication application].backgroundQueue addOperation:rename];
        
    }
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
