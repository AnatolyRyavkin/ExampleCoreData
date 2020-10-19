//
//  Client+CoreDataClass.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Client+CoreDataClass.h"
#import "PersistentManager.h"
#import "Bank+CoreDataClass.h"

@interface Client()
-(void)customising;
@end

@implementation Client



-(id)initWithContext:(NSManagedObjectContext *)context {
    self = [super initWithContext:context];
    if(self)
        [self customising];
    return self;
}

-(void)customising {
    self.name = [self makeName];
    self.creditHistory = (arc4random_uniform(1000)%2 == 0) ? YES : NO;
    self.cache = (arc4random_uniform(1000000000));
    self.region = [NSString stringWithFormat:@"Region%d",arc4random_uniform(10)];
}

-(NSString*)makeName {

    NSArray*arrayGlasChar = [[NSArray alloc]initWithObjects:@"y",@"u",@"a",@"o",@"i",@"a",@"u",@"o",@"i",@"j",nil];

    NSArray*arraySoglasChar = [[NSArray alloc]initWithObjects:     @"q",@"w",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"w",
                               @"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",
                               @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",
                               @"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"c",@"v",@"b",@"n",@"m",nil];

    NSMutableString*firstName = [[NSMutableString alloc]init];
    int lit = arc4random();
    for(int i=0;i<(arc4random()%6+4);i++){
        NSString*strChar = (lit%2==0) ? [arrayGlasChar objectAtIndex:arc4random()% (arrayGlasChar.count-1)] :
        [arraySoglasChar objectAtIndex:(arc4random()%
                                        (arraySoglasChar.count-1))];
        lit++;
        if(i==0)
            [firstName appendString:[strChar uppercaseString]];
        else
            [firstName appendString:strChar];
    }

    NSMutableString*lastName = [[NSMutableString alloc]init];
    for(int i=0;i<(arc4random()%6+4);i++){
        NSString*strChar = (arc4random()%2==0) ? [arrayGlasChar objectAtIndex:(arc4random()%(arrayGlasChar.count-1))] :  [arraySoglasChar objectAtIndex:(arc4random()%(arraySoglasChar.count-1))];
        if(i==0)
            [lastName appendString:[strChar uppercaseString]];
        else
            [lastName appendString:strChar];
    }
    if(arc4random()%2==0)
        [lastName appendString:@"in"];
    else
        [lastName appendString:@"of"];

    return [NSString stringWithFormat: @"%@ %@", lastName, firstName];
}

@end
