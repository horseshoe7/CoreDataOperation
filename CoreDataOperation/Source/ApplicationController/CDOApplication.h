//
//  CDOApplication.h
//  CoreDataOperation
//
//  Created by Stephen O'Connor on 02/06/15.
//  Copyright (c) 2015 Iconoclasm Spasms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDOApplication : NSObject

@property (nonatomic, strong) NSOperationQueue *backgroundQueue;

+ (instancetype)application; // I could write sharedApplication, but that's more typing for you.

@end
