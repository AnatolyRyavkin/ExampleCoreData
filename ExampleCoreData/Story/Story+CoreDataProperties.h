//
//  Story+CoreDataProperties.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Story+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Story (CoreDataProperties)

+ (NSFetchRequest<Story *> *)fetchRequest;

@property (nonatomic) BOOL lavelCreditHistory;
@property (nonatomic) int16_t levelCache;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *region;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) NSSet<Client *> *clients;

@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addClientsObject:(Client *)value;
- (void)removeClientsObject:(Client *)value;
- (void)addClients:(NSSet<Client *> *)values;
- (void)removeClients:(NSSet<Client *> *)values;

@end

NS_ASSUME_NONNULL_END
