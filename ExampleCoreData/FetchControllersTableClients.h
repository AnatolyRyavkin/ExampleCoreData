//
//  FetchControllersTableClients.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <Foundation/Foundation.h>
#import "Client+CoreDataClass.h"
#import "PersistentManager.h"

NS_ASSUME_NONNULL_BEGIN



@interface FetchControllersTableClients : NSObject

@property (strong, nonatomic,nullable) NSFetchedResultsController<Client*>* fetchedResultsController1;
@property (nullable,nonatomic)PersistentManager* persistentManager;

+(FetchControllersTableClients*)Shared;
-(void)removeFetchedResultsController1;

@end

NS_ASSUME_NONNULL_END
