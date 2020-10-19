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

    // установка колличества клиентов и историй при создании  или пересоздании бд

    [PersistentManager.Shared performBlockAndSaveContext:^(NSManagedObjectContext * _Nonnull context) {
        if([[Bank alloc] initWithContext: context withNameBank: @"BANK" withCountClients:10000 withCountStory: 1000]){}
    }];

}

+(void)deleteBase{
    Story.count = 0;
    PersistentManager* pm = PersistentManager.Shared;
    [pm removeBase];
    
}

@end
