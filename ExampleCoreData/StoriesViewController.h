//
//  StoriesViewController.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 18.10.2020.
//

#import <UIKit/UIKit.h>
#import "Story+CoreDataClass.h"
#import "PresenterTableViewController.h"



@interface StoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView* tableView;

@end


