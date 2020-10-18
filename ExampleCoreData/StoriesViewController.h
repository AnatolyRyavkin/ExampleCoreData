//
//  StoriesViewController.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 18.10.2020.
//

#import <UIKit/UIKit.h>
#import "Story+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView* tableView;

@end

NS_ASSUME_NONNULL_END
