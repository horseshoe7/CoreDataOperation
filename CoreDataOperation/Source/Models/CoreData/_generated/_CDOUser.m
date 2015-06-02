// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOUser.m instead.

#import "_CDOUser.h"

const struct CDOUserAttributes CDOUserAttributes = {
	.identifier = @"identifier",
	.username = @"username",
};

@implementation CDOUserID
@end

@implementation _CDOUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOUser" inManagedObjectContext:moc_];
}

- (CDOUserID*)objectID {
	return (CDOUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic identifier;

@dynamic username;

@end

