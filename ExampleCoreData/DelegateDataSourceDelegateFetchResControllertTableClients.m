//
//  DelegateDataSourceDelegateFetchResControllertTableClients.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import "DelegateDataSourceDelegateFetchResControllertTableClients.h"

typedef enum {
    ModeTableRegion = 0,
    ModeTableCache,
    ModeTableCreditHistory
} ModeTable;

NS_ASSUME_NONNULL_BEGIN
@interface DelegateDataSourceDelegateFetchResControllertTableClients()

@property ModeTable modeTable;

@end
NS_ASSUME_NONNULL_END


@implementation DelegateDataSourceDelegateFetchResControllertTableClients

- (instancetype)init
{
    self = [super init];
    if (self) {
        //NSLog(@"Init DelegateDataSourceDelegateFetchResControllertTableClients");
    }
    return self;
}

+(DelegateDataSourceDelegateFetchResControllertTableClients*)Shared{
    static DelegateDataSourceDelegateFetchResControllertTableClients*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DelegateDataSourceDelegateFetchResControllertTableClients alloc]init];
        FetchControllersTableClients.Shared.fetchedResultsController1.delegate = manager;
        manager.modeTable = ModeTableCache;
    });
    return manager;
}

-(NSFetchedResultsController*)fetchControllerClient{
    if(_fetchControllerClient == nil){
        _fetchControllerClient = FetchControllersTableClients.Shared.fetchedResultsController1;
    }
    return _fetchControllerClient;
}

-(void)deleteFethedController {
    [FetchControllersTableClients.Shared removeFetchedResultsController1];
    _fetchControllerClient = nil;
}


#pragma mark - dataSourse

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger num;
    id <NSFetchedResultsSectionInfo> sectionInfo;
    switch (self.modeTable) {
        case ModeTableRegion:
            num = 10; // fetchRequest...
            break;
        case ModeTableCache:
            sectionInfo = [self.fetchControllerClient sections][section];
            num = [sectionInfo numberOfObjects];
            break;
        case ModeTableCreditHistory:
            num = 10; // fetchRequest...
            break;
        default:
            break;
    }
    return num;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    switch (self.modeTable) {
        case ModeTableRegion:
            num = 1; // fetchRequest...
            break;
        case ModeTableCache:
            num = [[self.fetchControllerClient sections] count];
            break;
        case ModeTableCreditHistory:
            num = 1; // fetchRequest...
            break;
        default:
            break;
    }

    return num;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchControllerClient sections][section];
    return @"Header";//[sectionInfo name];

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [self cell: tableView];
    Client* client = [self.fetchControllerClient objectAtIndexPath:indexPath];
    [self configureCell:cell withClient:client];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withClient:(Client*)client {
    cell.textLabel.text = [NSString stringWithFormat:@"%@", client.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", client.cache];
}

- (UITableViewCell*)cell:(UITableView *) tableView {
    UITableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUser"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"idCellUser"];
    }else{
        cell.textLabel.text = @"";
    }
    return  cell;
}

#pragma mark - Delegate

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Del";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Client* client = [self.fetchControllerClient objectAtIndexPath:indexPath];
        [PersistentManager.Shared performBlockAndSaveContext:^(NSManagedObjectContext * _Nonnull context) {
            [context deleteObject: client];
        }];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


- (void)actionStoriesController {
    NSLog(@"actionStoriesController");
}

- (void)actionModeRegion {
    NSLog(@"actionModeRegion");
}


- (void)actionModeCache {
    NSLog(@"actionModeCache");
}


- (void)actionModeHistory {
    NSLog(@"actionModeHistory");
}

- (void)actionCleanBase {
    NSLog(@"actionCleanBase");
    
    [CreatorBaseData deleteBase];
    [self deleteFethedController];
    [self.tableView reloadData];

}

- (void)actionNewBase {
    [self deleteFethedController];
    [CreatorBaseData createBase];
    FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    [self.tableView reloadData];
    NSLog(@"actionMakeBase");
}

- (void)actionAddClient {
    NSLog(@"actionAddClient");

    if (FetchControllersTableClients.Shared.fetchedResultsController1.delegate == nil) {
        FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    }
    [PersistentManager.Shared performBlockAndSaveContext:^(NSManagedObjectContext * _Nonnull context) {
        [[Client alloc] initWithContext:context];
    }];

}



@end






