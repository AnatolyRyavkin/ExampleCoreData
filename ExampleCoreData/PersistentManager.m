//
//  PersistentManager.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import "PersistentManager.h"

@implementation NSManagedObjectContext(SaveIfNeeded)

-(BOOL) saveIfNeeded{
    BOOL toReturn = YES;
    if ([self hasChanges]) {
        NSError *error;
        toReturn = [self save:&error];
        if (toReturn == NO || error)
        {
            NSLog(@"error = %@", error);
        }
    }
    return toReturn;
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
    if (![NSThread mainThread]) {
        NSLog(@"thread!");
    }
    return self.persistentContainer.viewContext;
}

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

- (void)performBlockAndSaveContext:(void (^)(NSManagedObjectContext* context))block{
    void (^blockCopy)(NSManagedObjectContext*) = [block copy];

    [self.persistentContainerQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        NSManagedObjectContext* context = self.persistentContainer.viewContext; //self.persistentContainer.newBackgroundContext;
        [context performBlockAndWait:^{
            blockCopy(context);
            [context saveIfNeeded];
        }];
    }]];
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
        }
    }

    return _persistentContainer;
}

#pragma mark - Core Data Saving and remove support

-(void)removeBase{

    NSURL *documentsURL = [[[NSFileManager defaultManager]  URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"ExampleCoreData.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error: nil];
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentContainer.persistentStoreCoordinator;
    NSPersistentStore *store = [storeCoordinator.persistentStores lastObject];
    NSError *error = nil;
    [storeCoordinator removePersistentStore:store error:&error];
    _persistentContainer = nil;
    if (!self.persistentContainer)
        abort();
}


-(void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
