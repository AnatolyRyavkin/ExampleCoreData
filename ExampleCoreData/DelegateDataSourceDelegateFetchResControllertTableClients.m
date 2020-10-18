//
//  DelegateDataSourceDelegateFetchResControllertTableClients.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import "DelegateDataSourceDelegateFetchResControllertTableClients.h"

NS_ASSUME_NONNULL_BEGIN
@interface DelegateDataSourceDelegateFetchResControllertTableClients()


@end
NS_ASSUME_NONNULL_END


@implementation DelegateDataSourceDelegateFetchResControllertTableClients

static ModeTable _modeTable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _modeTable = ModeTableName;
    }
    return self;
}

+ (ModeTable)modeTable {
    return _modeTable;
}

+ (void)setModeTable:(ModeTable)newModeTable {
    _modeTable = newModeTable;
}

+(DelegateDataSourceDelegateFetchResControllertTableClients*)Shared{
    static DelegateDataSourceDelegateFetchResControllertTableClients*manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DelegateDataSourceDelegateFetchResControllertTableClients alloc]init];
        FetchControllersTableClients.Shared.fetchedResultsController1.delegate = manager;
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

    return [[self.fetchControllerClient sections][section] numberOfObjects];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [[self.fetchControllerClient sections] count];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if(DelegateDataSourceDelegateFetchResControllertTableClients.modeTable == ModeTableCreditHistory) {
        return ([[self.fetchControllerClient sections][section].name  isEqual: @"0"]) ? @"Bad history" : @"Good history";
    }
    return [self.fetchControllerClient sections][section].name;

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [self cell: tableView];
    Client* client = [self.fetchControllerClient objectAtIndexPath:indexPath];
    [self configureCell:cell withClient:client];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withClient:(Client*)client {
    switch (DelegateDataSourceDelegateFetchResControllertTableClients.modeTable) {
        case ModeTableName:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", client.name];
            break;
        case ModeTableCache:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", client.name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", client.cache];
            break;
        case ModeTableRegion:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", client.name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", client.region];
            break;
        case ModeTableCreditHistory:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", client.name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", (client.creditHistory == YES) ? @"GOOD" : @"BAD" ];
            break;
        default:
            break;
    }
}

- (UITableViewCell*)cell:(UITableView *) tableView {
    UITableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellUser"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"idCellUser"];
    }else{
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
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


#pragma mark - ChangeMode



- (void)actionModeRegion {
    NSLog(@"actionModeRegion");
    [self deleteFethedController];
    DelegateDataSourceDelegateFetchResControllertTableClients.modeTable = ModeTableRegion;
    FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    [self.tableView reloadData];

}

- (void)actionModeName {
    NSLog(@"actionModeName");
    [self deleteFethedController];
    DelegateDataSourceDelegateFetchResControllertTableClients.modeTable = ModeTableName;
    FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    [self.tableView reloadData];
}


- (void)actionModeCache {
    NSLog(@"actionModeCache");
    [self deleteFethedController];
    DelegateDataSourceDelegateFetchResControllertTableClients.modeTable = ModeTableCache;
    FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    [self.tableView reloadData];
}


- (void)actionModeHistory {
    NSLog(@"actionModeHistory");
    [self deleteFethedController];
    DelegateDataSourceDelegateFetchResControllertTableClients.modeTable = ModeTableCreditHistory;
    FetchControllersTableClients.Shared.fetchedResultsController1.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - WorkWithBase


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

