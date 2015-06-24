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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];  // I get in the habit of always giving the context, as it forces me to think in threads.  Some devs tell you to hide these details.
    
    CDOUser *onlyUser = [CDOUser MR_findFirstInContext:context];
    if (!onlyUser) {
        onlyUser = [CDOUser MR_createEntityInContext:context];
        onlyUser.identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        onlyUser.username = @"Stephen";
        
        [onlyUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
    
    // now we do something with him
    CDORenameUserOperation *rename = [[CDORenameUserOperation alloc] initWithUser:onlyUser updatedName:@"Stefan Körner"];
    
    [rename setCompletionBlock:^{
        
        // according to the API docs, there is no guarantee this will be called on the main thread.  So, let's guarantee that.
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Completed!");
        }];
        
        // equivalently, you could use gcd:
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
        
    }];
    
    NSLog(@"Will add to queue now");
    
    [[CDOApplication application].backgroundQueue addOperation:rename];
    
}

@end
