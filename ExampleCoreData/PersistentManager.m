//
//  PersistentManager.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.

#import "PersistentManager.h"

@implementation NSManagedObjectContext(SaveIfNeeded)

 -(void)save{
     [self performBlockAndWait:^{
         NSError *error = nil;
         if ([self hasChanges] && ![self save:&error])
             NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }];
}

@end

@interface PersistentManager()

@property (nonatomic, strong) NSOperationQueue* persistentContainerQueue;

@end

@implementation PersistentManager


+(PersistentManager*)Shared{
    static PersistentManager*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PersistentManager alloc]init];
    });
    return manager;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

-(NSManagedObjectContext*)context {
    return self.persistentContainer.viewContext;
}

-(NSManagedObjectContext*)contextBackground {
    return self.persistentContainer.newBackgroundContext;
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExampleCoreData"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil){
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    [self removeBase];
                    self->_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExampleCoreData"];
                    [self->_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                        if (error != nil){
                            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                            [self removeBase];
                            abort();
                        }
                    }];
                }
            }];
            _persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
            _persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
            _persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true;
        }

    }

    return _persistentContainer;
}



#pragma mark - Queue for perform on background


-(NSOperationQueue*)persistentContainerQueue {
    if (!_persistentContainerQueue) {
    _persistentContainerQueue = [[NSOperationQueue alloc] init];
    _persistentContainerQueue.maxConcurrentOperationCount = 1;
    _persistentContainerQueue.name = @"persistentContainerQueue";
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue", DISPATCH_QUEUE_SERIAL);
    _persistentContainerQueue.underlyingQueue = queue;
    }
    return  _persistentContainerQueue;
}

// создал функции для разных вариантов действий c context

#pragma mark - perform block on background at self.persistentContainerQueue, if invoke several times to run SERIAL.


- (void)performBlockAndSaveContext:(void (^)(NSManagedObjectContext* context))block{
    __weak PersistentManager* weakSelf = self;
    [self.persistentContainerQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        NSManagedObjectContext* context = weakSelf.persistentContainer.newBackgroundContext;
        [context performBlockAndWait:^{
            block(context);
            [context save];
        }];
    }]];
}

#pragma mark - sync run, only for context get in same thread were perform!!!

- (void)performBlockAndSaveContext:(NSManagedObjectContext*) context withBlock: (void (^)(NSManagedObjectContext* context))block{
    [self.persistentContainerQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [context performBlockAndWait:^{
            block(context);
            [context save];
        }];
    }]];
}

#pragma mark - async run, only for context get in same thread were perform!!!

- (void)performBlockDontWaitAndSaveContext:(NSManagedObjectContext*) context withBlock: (void (^)(NSManagedObjectContext* context))block{
    [self.persistentContainerQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [context performBlock:^{
            block(context);
            [context save];
        }];
    }]];
}


#pragma mark - async perform block, after complition to main

- (void)performBlockAndSaveContextAndPerformCompletedBlockAtMainQueueBlock: (void (^)(NSManagedObjectContext* context)) block
                                                completion: (void (^)(NSManagedObjectContext* context)) completionBlock{

    dispatch_async(dispatch_queue_create("q", DISPATCH_QUEUE_SERIAL), ^{
        __weak PersistentManager* weakSelf = self;
        NSManagedObjectContext* context = weakSelf.persistentContainer.newBackgroundContext;
        block(context);
        [context save];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(context);
        });
    });

}

#pragma mark - async perform block, after complition to main from default queue and context

- (void)performBlockAndSaveContextAndPerformCompletedBlockAtMainQueue:(NSManagedObjectContext*) context
                                                withBlock: (void (^)(NSManagedObjectContext* context)) block
                                                completion: (void (^)(NSManagedObjectContext* context)) completionBlock{
    dispatch_async(dispatch_queue_create("q", DISPATCH_QUEUE_SERIAL), ^{
        block(context);
        [context save];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(context);
        });
    });
}



#pragma mark - Core Data remove

-(void)removeBase{

    NSURL *documentsURL = [[[NSFileManager defaultManager]  URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"ExampleCoreData.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error: nil];
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
    NSPersistentStore *store = [storeCoordinator.persistentStores lastObject];

// если storeCoordinator и store не решабильны, то ошибка не пройдет

    @try {
        NSError *error = nil;
        [storeCoordinator removePersistentStore:store error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        NSLog(@"Finally condition");
    }

    _persistentContainer = nil;
    if (!self.persistentContainer)
        abort();
}

@end
























//
//#import "PersistentManager.h"
//
//@implementation NSManagedObjectContext(SaveIfNeeded)
//
//-(BOOL) saveIfNeeded{
//    BOOL toReturn = YES;
//    if ([self hasChanges]) {
//        NSError *error;
//        toReturn = [self save:&error];
//        if (toReturn == NO || error)
//        {
//            NSLog(@"error = %@", error);
//        }
//    }
//    return toReturn;
//}
//
//@end
//
//
//@interface PersistentManager()
//
//@property (nonatomic, strong) NSOperationQueue* persistentContainerQueue;
//
//@end
//
//@implementation PersistentManager
//
//
//+(PersistentManager*)Shared{
//    static PersistentManager*manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[PersistentManager alloc]init];
//    });
//    return manager;
//}
//
//#pragma mark - Core Data stack
//
//@synthesize persistentContainer = _persistentContainer;
//
//-(NSManagedObjectContext*)context {
//    return self.persistentContainer.viewContext;
//}
//
//-(NSManagedObjectContext*)contextBackground {
//    return self.persistentContainer.newBackgroundContext;
//}
//
//
//-(NSOperationQueue*)persistentContainerQueue {
//    if (!_persistentContainerQueue) {
//    _persistentContainerQueue = [[NSOperationQueue alloc] init];
//    _persistentContainerQueue.maxConcurrentOperationCount = 1;
//    _persistentContainerQueue.name = @"persistentContainerQueue";
//    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue", DISPATCH_QUEUE_SERIAL);
//    _persistentContainerQueue.underlyingQueue = queue;
//    }
//    return  _persistentContainerQueue;
//}
//
//- (void)performBlockAndSaveContext:(void (^)(NSManagedObjectContext* context))block{
//    void (^blockCopy)(NSManagedObjectContext*) = [block copy];
//
//    [self.persistentContainerQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
//        NSManagedObjectContext* context = self.persistentContainer.viewContext; //self.persistentContainer.newBackgroundContext;
//        [context performBlockAndWait:^{
//            blockCopy(context);
//            [context saveIfNeeded];
//        }];
//    }]];
//}
//
//
//- (NSPersistentContainer *)persistentContainer {
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExampleCoreData"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil){
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    [self removeBase];
//                    self->_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExampleCoreData"];
//                    [self->_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                        if (error != nil){
//                            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                            [self removeBase];
//                            abort();
//                        }
//                    }];
//                }
//            }];
//            _persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
//        }
//
//    }
//
//    return _persistentContainer;
//}
//
//#pragma mark - Core Data Saving and remove support
//
//-(void)removeBase{
//
//    NSURL *documentsURL = [[[NSFileManager defaultManager]  URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
//    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"ExampleCoreData.sqlite"];
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error: nil];
//    NSPersistentStoreCoordinator *storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
//    NSPersistentStore *store = [storeCoordinator.persistentStores lastObject];
//    NSError *error = nil;
//    [storeCoordinator removePersistentStore:store error:&error];
//    _persistentContainer = nil;
//    if (!self.persistentContainer)
//        abort();
//}
//
//
//-(void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}
//
//
//@end
