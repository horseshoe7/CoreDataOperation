// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOUser.h instead.

@import CoreData;

extern const struct CDOUserAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *username;
} CDOUserAttributes;

@interface CDOUserID : NSManagedObjectID {}
@end

@interface _CDOUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CDOUserID* objectID;

@property (nonatomic, strong) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@end

@interface _CDOUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

@end
