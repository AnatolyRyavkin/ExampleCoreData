//
//  AppDelegate.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

