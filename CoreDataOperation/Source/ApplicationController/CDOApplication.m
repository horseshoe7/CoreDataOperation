//
//  CDOApplication.m
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 02/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import "CDOApplication.h"
#import "MagicalRecord.h"

@implementation CDOApplication

#pragma mark - Singleton and Init
static CDOApplication *Application = nil;

+ (instancetype)application
{
    // classic Singleton instantiation pattern
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Application = [[self alloc] init];
    });
    return Application;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeApp];
    }
    return self;
}

- (void)initializeApp
{
    // we use defaults here.  MagicalRecord is very customizable, but sticking to conventions makes your life easy.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"CoreDataOperation"];
    
    // here we create and define the background queue.  Quality of Service is of interest here,
    // as is the maxConcurrentOperation count.  Your needs may change, but having it be a serial
    // queue is important when working with background contexts, so to prevent merge conflicts
    // and crashes.
    
    // We set it up like this for Core Data, but what you are learning in this tutorial
    // with NSOperation, you may want to set up a queue to behave differently.
    
    _backgroundQueue = [[NSOperationQueue alloc] init];
    _backgroundQueue.qualityOfService = NSQualityOfServiceBackground;
    _backgroundQueue.maxConcurrentOperationCount = 1;
}

@end
