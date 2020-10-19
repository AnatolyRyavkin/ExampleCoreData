//
//  Bank+CoreDataClass.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import <Foundation/Foundation.h>
#import "AbstractEntity+CoreDataClass.h"

@class Client, Story;

NS_ASSUME_NONNULL_BEGIN

@interface Bank : AbstractEntity

-(id)initWithContext:(NSManagedObjectContext *)context withNameBank: (NSString*) name;
-(id)initWithContext:(NSManagedObjectContext *)context withNameBank: (NSString*) name withCountClients: (int) numClients withCountStory: (int) numStory;



@end

NS_ASSUME_NONNULL_END

#import "Bank+CoreDataProperties.h"
