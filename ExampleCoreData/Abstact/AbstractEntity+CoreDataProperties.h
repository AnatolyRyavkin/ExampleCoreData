//
//  AbstractEntity+CoreDataProperties.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "AbstractEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AbstractEntity (CoreDataProperties)

+ (NSFetchRequest<AbstractEntity *> *)fetchRequest;


@end

NS_ASSUME_NONNULL_END
