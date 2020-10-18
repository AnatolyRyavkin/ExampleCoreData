//
//  PersistentManager.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersistentManager : NSObject


@property (strong,nonatomic,nullable) NSPersistentContainer* persistentContainer;

- (void)performBlockAndSaveContext:(void (^)(NSManagedObjectContext* context))block;

+(PersistentManager*)Shared;
-(void)removeBase;
-(void)saveContext;

@end

NS_ASSUME_NONNULL_END
