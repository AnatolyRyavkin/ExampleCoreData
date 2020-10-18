//
//  InputViewController.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 16.10.2020.
//

#import "InputViewController.h"

@interface InputViewController ()

@property (nonatomic) NSArray* arrayButtonsMode;
@property (nonatomic) UIView*viewHeader;
@property (nonatomic) DelegateDataSourceDelegateFetchResControllertTableClients* delegDataSourceDelegFetchTableClients;

@end


@implementation InputViewController

-(DelegateDataSourceDelegateFetchResControllertTableClients*)delegDataSourceDelegFetchTableClients {
    if(_delegDataSourceDelegFetchTableClients == nil) {
        _delegDataSourceDelegFetchTableClients = DelegateDataSourceDelegateFetchResControllertTableClients.Shared;
    }
    return _delegDataSourceDelegFetchTableClients;
}

- (void)loadView {
    [super loadView];
    
    //[CreatorBaseData createBase];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame: CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self.delegDataSourceDelegFetchTableClients;
    self.tableView.dataSource = self.delegDataSourceDelegFetchTableClients;
    self.delegDataSourceDelegFetchTableClients.tableView = self.tableView;

    
    self.navigationItem.title = @"Bank";
    UIBarButtonItem* barButtonStories = [[UIBarButtonItem alloc] initWithTitle:@"Stories" style:UIBarButtonItemStylePlain
                                        target: self.delegDataSourceDelegFetchTableClients action: NSSelectorFromString(@"actionStoriesController")];
    UIBarButtonItem* barButtonUpdateBase = [[UIBarButtonItem alloc] initWithTitle:@"NewBase" style:UIBarButtonItemStylePlain
                                        target: self.delegDataSourceDelegFetchTableClients action: NSSelectorFromString(@"actionNewBase")];
    NSArray* arrayBarButton = [[NSArray alloc] initWithObjects:  barButtonStories,barButtonUpdateBase, nil];
    self.navigationItem.rightBarButtonItems = arrayBarButton;




    UIBarButtonItem* barButtonCleanBase = [[UIBarButtonItem alloc] initWithTitle:@"CleanBase" style:UIBarButtonItemStylePlain
                                    target: self.delegDataSourceDelegFetchTableClients action: NSSelectorFromString(@"actionCleanBase")];
    UIBarButtonItem* barButtonAddClient = [[UIBarButtonItem alloc] initWithTitle:@"AddClient" style:UIBarButtonItemStylePlain
                                        target: self.delegDataSourceDelegFetchTableClients action: NSSelectorFromString(@"actionAddClient")];
    self.navigationItem.leftBarButtonItems = @[barButtonAddClient, barButtonCleanBase];




    UIButton* buttonModeTableRegion = [[UIButton alloc]init];
    [buttonModeTableRegion setTitle:@"SortRegion" forState:UIControlStateNormal];
    [buttonModeTableRegion setTitle:@"Sort" forState:UIControlStateHighlighted];
    [buttonModeTableRegion addTarget: self.delegDataSourceDelegFetchTableClients action:NSSelectorFromString(@"actionModeRegion") forControlEvents:UIControlEventTouchUpInside];

    UIButton* buttonModeTableCache = [[UIButton alloc]init];
    [buttonModeTableCache setTitle:@"SortCache" forState:UIControlStateNormal];
    [buttonModeTableCache setTitle:@"Sort" forState:UIControlStateHighlighted];
    [buttonModeTableCache addTarget: self.delegDataSourceDelegFetchTableClients action:NSSelectorFromString(@"actionModeCache") forControlEvents:UIControlEventTouchUpInside];


    UIButton* buttonModeTableCreditHistory = [[UIButton alloc]init];
    [buttonModeTableCreditHistory setTitle:@"SortCreditHistory" forState:UIControlStateNormal];
    [buttonModeTableCreditHistory setTitle:@"Sort" forState:UIControlStateHighlighted];
    [buttonModeTableCreditHistory addTarget: self.delegDataSourceDelegFetchTableClients action:NSSelectorFromString(@"actionModeHistory") forControlEvents:UIControlEventTouchUpInside];
    
    self.arrayButtonsMode = [[NSArray alloc]initWithObjects:buttonModeTableRegion, buttonModeTableCache, buttonModeTableCreditHistory, nil];

    self.viewHeader = [[UIView alloc]initWithFrame:CGRectZero];
    self.viewHeader.backgroundColor = [UIColor darkGrayColor];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];


    CGFloat offsetUp = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGRect rectHeader = CGRectMake(0, offsetUp, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/20);
    self.viewHeader.frame = rectHeader;
    [self.view addSubview:self.viewHeader];
    CGFloat offsetButtonX = CGRectGetWidth(rectHeader)/20;
    CGFloat offsetButtonY = CGRectGetHeight(rectHeader)/20;
    CGSize sizeButton;
    sizeButton.width = (CGRectGetWidth(rectHeader) - 4*offsetButtonX)/3;
    sizeButton.height = (CGRectGetHeight(rectHeader)) - 2*offsetButtonY;

    for (int i=0;i<3;i++){
        UIButton* buttonMode = self.arrayButtonsMode[i];
        buttonMode.frame = CGRectMake(CGRectGetMinX(self.viewHeader.bounds) + offsetButtonX*(i+1) + sizeButton.width*i, CGRectGetMinY(self.viewHeader.bounds) + offsetButtonY
                                      , sizeButton.width, sizeButton.height);
        [self.viewHeader addSubview: buttonMode];
    }

    
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds) + offsetUp + rectHeader.size.height,
                    CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - (offsetUp + rectHeader.size.height));
    [self.view addSubview:self.tableView];

}


@end
