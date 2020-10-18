//
//  DelegateDataSourceDelegateFetchResControllertTableClients.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Client+CoreDataClass.h"
#import "PersistentManager.h"
#import "DataManagerTableClient.h"
#import "FetchControllersTableClients.h"
#import "CreatorBaseData.h"



NS_ASSUME_NONNULL_BEGIN

@interface DelegateDataSourceDelegateFetchResControllertTableClients : NSObject<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>;

@property (nonatomic) UITableView*tableView;
@property (nullable,nonatomic) NSFetchedResultsController<Client *>* fetchControllerClient;

+(DelegateDataSourceDelegateFetchResControllertTableClients*)Shared;

@end

NS_ASSUME_NONNULL_END
