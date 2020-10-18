//
//  Story+CoreDataProperties.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Story+CoreDataProperties.h"

@implementation Story (CoreDataProperties)

+ (NSFetchRequest<Story *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Story"];
}

@dynamic lavelCreditHistory;
@dynamic levelCache;
@dynamic name;
@dynamic region;
@dynamic bank;
@dynamic clients;

@end
