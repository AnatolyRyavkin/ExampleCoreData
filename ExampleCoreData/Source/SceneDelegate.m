//
//  SceneDelegate.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"


@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {

    UIWindow* window = [[UIWindow alloc] init];
    window.windowScene = (UIWindowScene*)scene;
    window.backgroundColor = [UIColor greenColor];
    InputViewController* vc = [[InputViewController alloc]init];
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    window.rootViewController = nc;
    [window makeKeyAndVisible];
    self.window = window;

}



@end
