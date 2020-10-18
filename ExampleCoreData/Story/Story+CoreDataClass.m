//
//  Story+CoreDataClass.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Story+CoreDataClass.h"

@implementation Story

static int count = 0;

-(id)initWithContext:(NSManagedObjectContext *)context{
    self = [super initWithContext:context];
    if(self)
        [self customising];
    return self;
}

-(void)customising {
    self.name = [NSString stringWithFormat:@"Client%d",count];
    count++;
    self.lavelCreditHistory = (arc4random_uniform(1000)%2 == 0) ? YES : NO;
    self.levelCache = (arc4random_uniform(1000)%2 == 0) ? YES : NO;
    self.region = [NSString stringWithFormat:@"Region%d",arc4random_uniform(10)];
}

@end
