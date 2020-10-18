//
//  Client+CoreDataClass.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import <Foundation/Foundation.h>
#import "AbstractEntity+CoreDataClass.h"

@class Bank, Story;

NS_ASSUME_NONNULL_BEGIN

@interface Client : AbstractEntity

@property (class, nullable) Bank* bank;

+(void)bankDel;

-(id)initWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Client+CoreDataProperties.h"
