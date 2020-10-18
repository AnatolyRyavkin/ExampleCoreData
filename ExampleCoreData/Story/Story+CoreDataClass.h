//
//  Story+CoreDataClass.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import <Foundation/Foundation.h>
#import "AbstractEntity+CoreDataClass.h"

@class Bank, Client;

NS_ASSUME_NONNULL_BEGIN

@interface Story : AbstractEntity

@property (class) int count;

-(id)initWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Story+CoreDataProperties.h"
