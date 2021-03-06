//
//  Bank+CoreDataClass.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 17.10.2020.
//
//

#import "Bank+CoreDataClass.h"
#import "Client+CoreDataClass.h"
#import "Story+CoreDataClass.h"

#import "Bank+CoreDataProperties.h"

@implementation Bank

-(id)initWithContext:(NSManagedObjectContext *)context withNameBank: (NSString*) name{
    self = [super initWithContext:context];
    if(self){
        self.name = name;
    }
    return self;
}

-(id)initWithContext:(NSManagedObjectContext *)context withNameBank: (NSString*) name withCountClients: (int) numClients withCountStory: (int) numStory{
    self = [super initWithContext:context];
    if(self){
        self.name = name;
        for (int i=0;i<numClients;i++) {
            Client* client = [[Client alloc]initWithContext:context];
            [self addClientsObject:client];
        }

        for (int i=0;i<numStory;i++) {
            [self addStoriesObject:[[Story alloc]initWithContext:context]];
        }
    }
    return self;
}

@end
