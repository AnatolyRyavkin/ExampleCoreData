//
//  Bank+CoreDataProperties.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Bank+CoreDataProperties.h"

@implementation Bank (CoreDataProperties)

+ (NSFetchRequest<Bank *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Bank"];
}

@dynamic name;
@dynamic clients;
@dynamic stories;

@end
