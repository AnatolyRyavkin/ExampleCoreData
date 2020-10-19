//
//  PresenterTableViewController.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 19.10.2020.
//

#import "PresenterTableViewController.h"

@interface PresenterTableViewController ()

@end

@implementation PresenterTableViewController

- (instancetype)initArrayNames:(NSArray*) array andHeaderString: (NSString*) headerStr
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _arrayPresent = array;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Table view data source

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return self.headerStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger n = self.arrayPresent.count;
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellPresent"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellPresent"];
    }
    NSString* clientName = self.arrayPresent[indexPath.row];
    NSLog(@" --- %@",clientName);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", clientName];
    return cell;
        
}


@end
