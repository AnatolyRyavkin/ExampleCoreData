//
//  FetchControllersTableClients.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <CoreData/CoreData.h>
#import "FetchControllersTableClients.h"
#import "DelegateDataSourceDelegateFetchResControllertTableClients.h"


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

    NSSortDescriptor *sortDescriptor;
    NSString* _Nullable  sectionNameKeyPatch = nil;

    switch (DelegateDataSourceDelegateFetchResControllertTableClients.modeTable) {
        case ModeTableCache:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cache" ascending:YES];
            break;
        case ModeTableName:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            break;
        case ModeTableCreditHistory:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creditHistory" ascending:YES];
            sectionNameKeyPatch = @"creditHistory";
            break;
        case ModeTableRegion:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"region" ascending:YES];
            sectionNameKeyPatch = @"region";
            break;

        default:
            break;
    }

    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController<Client *> *fetchResContr = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                managedObjectContext: PersistentManager.Shared.persistentContainer.viewContext
                                                sectionNameKeyPath: sectionNameKeyPatch
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
