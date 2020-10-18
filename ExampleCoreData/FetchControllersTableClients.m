//
//  FetchControllersTableClients.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <CoreData/CoreData.h>
#import "FetchControllersTableClients.h"


@implementation FetchControllersTableClients

@synthesize fetchedResultsController1 = _fetchedResultsController1;

+(FetchControllersTableClients*)Shared{
    static FetchControllersTableClients*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FetchControllersTableClients alloc]init];
    });
    return manager;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Client *> *)fetchedResultsController1 {
    if (_fetchedResultsController1 != nil) {
        return _fetchedResultsController1;
    }

    NSFetchRequest<Client *> *fetchRequest = Client.fetchRequest;
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController<Client *> *fetchResContr = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                managedObjectContext: PersistentManager.Shared.persistentContainer.viewContext
                                                sectionNameKeyPath: nil
                                                cacheName: nil];
    NSError* error = nil;
    if (![fetchResContr performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
        _fetchedResultsController1 = fetchResContr;
    return _fetchedResultsController1;
}

-(void)removeFetchedResultsController1 {
    _fetchedResultsController1 = nil;
}



@end
