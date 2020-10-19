//
//  PresenterTableViewController.h
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 19.10.2020.
//

#import <UIKit/UIKit.h>
#import "Client+CoreDataClass.h"
#import "Story+CoreDataClass.h"
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresenterTableViewController : UITableViewController

@property (nonatomic) NSArray* arrayPresent;
@property NSString* headerStr;

- (instancetype)initArrayNames:(NSArray*) array andHeaderString: (NSString*) headerStr;

@end

NS_ASSUME_NONNULL_END
