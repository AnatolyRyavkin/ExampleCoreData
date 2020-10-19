//
//  PersistentManager.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(SaveIfNeeded)

-(void)save;

@end



NS_ASSUME_NONNULL_BEGIN

@interface PersistentManager : NSObject


@property (strong,nonatomic,nullable) NSPersistentContainer* persistentContainer;

@property (nonatomic) NSManagedObjectContext* context;
@property (nonatomic) NSManagedObjectContext* contextBackground;

- (void)performBlockAndSaveContext:(void (^)(NSManagedObjectContext* context))block;

- (void)performBlockAndSaveContext:(NSManagedObjectContext*) context withBlock: (void (^)(NSManagedObjectContext* context))block;

- (void)performBlockAndSaveContextAndPerformCompletedBlockAtMainQueue:(NSManagedObjectContext*) context
                                                withBlock: (void (^)(NSManagedObjectContext* context)) block
                                                completion: (void (^)(NSManagedObjectContext* context)) completionBlock;

- (void)performBlockAndSaveContextAndPerformCompletedBlockAtMainQueueBlock: (void (^)(NSManagedObjectContext* context)) block
                                                                completion: (void (^)(NSManagedObjectContext* context)) completionBlock;

+(PersistentManager*)Shared;

-(void)removeBase;

@end

NS_ASSUME_NONNULL_END
