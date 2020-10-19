//
//  CreatorBaseData.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//

#import <Foundation/Foundation.h>
#import "Bank+CoreDataClass.h"
#import "Client+CoreDataClass.h"
#import "Story+CoreDataClass.h"
#import "PersistentManager.h"
 
NS_ASSUME_NONNULL_BEGIN

@interface CreatorBaseData : NSObject

+(void)createBase;
+(void)deleteBase;



@end

NS_ASSUME_NONNULL_END
