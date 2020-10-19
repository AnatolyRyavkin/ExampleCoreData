//
//  Story+CoreDataClass.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Story+CoreDataClass.h"
#import "PersistentManager.h"


@implementation Story

static int _count = 0;

+(int)count {
    return _count;
}
+(void)setCount: (int)newCount {
    _count = newCount;
}


-(id)initWithContext:(NSManagedObjectContext *)context{
    self = [super initWithContext:context];
    if(self)
        [self customising];
    return self;
}

-(void)customising {
    self.name = (Story.count < 10) ? [NSString stringWithFormat:@"Story-0%d",Story.count] : [NSString stringWithFormat:@"Story-%d",Story.count];
    Story.count++;
    self.lavelCreditHistory = (arc4random_uniform(1000)%2 == 0) ? YES : NO;
    self.levelCache = (arc4random_uniform(1000)%2 == 0) ? YES : NO;
    self.region = [NSString stringWithFormat:@"Region%d", arc4random_uniform(10)];
}

@end
