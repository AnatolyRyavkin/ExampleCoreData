//
//  Bank+CoreDataProperties.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Bank+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Bank (CoreDataProperties)

+ (NSFetchRequest<Bank *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Client *> *clients;
@property (nullable, nonatomic, retain) NSSet<Story *> *stories;

@end

@interface Bank (CoreDataGeneratedAccessors)

- (void)addClientsObject:(Client *)value;
- (void)removeClientsObject:(Client *)value;
- (void)addClients:(NSSet<Client *> *)values;
- (void)removeClients:(NSSet<Client *> *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet<Story *> *)values;
- (void)removeStories:(NSSet<Story *> *)values;

@end

NS_ASSUME_NONNULL_END
