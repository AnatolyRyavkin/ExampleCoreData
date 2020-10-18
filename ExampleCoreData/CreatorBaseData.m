//
//  CreatorBaseData.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import "CreatorBaseData.h"

@implementation CreatorBaseData


+(void)createBase {

    [CreatorBaseData deleteBase];
    [PersistentManager.Shared performBlockAndSaveContext:^(NSManagedObjectContext * _Nonnull context) {
        [[Bank alloc] initWithContext:context withNameBank: @"BANK" withCountClients:10];
    }];

}

+(void)deleteBase{
    
    [Client bankDel];
    PersistentManager* pm = PersistentManager.Shared;
    [pm removeBase];
    
}


@end
