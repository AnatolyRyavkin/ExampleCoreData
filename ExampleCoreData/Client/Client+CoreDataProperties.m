//
//  Client+CoreDataProperties.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Client+CoreDataProperties.h"

@implementation Client (CoreDataProperties)

+ (NSFetchRequest<Client *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Client"];
}

@dynamic cache;
@dynamic creditHistory;
@dynamic name;
@dynamic region;
@dynamic bank;
@dynamic stories;

@end
