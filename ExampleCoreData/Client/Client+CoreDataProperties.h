//
//  Client+CoreDataProperties.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Client+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Client (CoreDataProperties)

+ (NSFetchRequest<Client *> *)fetchRequest;

@property (nonatomic) int32_t cache;
@property (nonatomic) BOOL creditHistory;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *region;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) NSSet<Story *> *stories;

@end

@interface Client (CoreDataGeneratedAccessors)

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet<Story *> *)values;
- (void)removeStories:(NSSet<Story *> *)values;

@end

NS_ASSUME_NONNULL_END
