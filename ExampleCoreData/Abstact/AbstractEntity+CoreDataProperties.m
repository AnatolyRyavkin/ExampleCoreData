//
//  AbstractEntity+CoreDataProperties.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "AbstractEntity+CoreDataProperties.h"

@implementation AbstractEntity (CoreDataProperties)

+ (NSFetchRequest<AbstractEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AbstractEntity"];
}


@end
