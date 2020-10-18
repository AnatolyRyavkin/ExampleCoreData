//
//  StoriesViewController.m
//  ExampleCoreData
//
//  Created by Anatoly Ryavkin on 18.10.2020.
//

#import "StoriesViewController.h"
#import "Client+CoreDataClass.h"
#import "Bank+CoreDataClass.h"
#import "PersistentManager.h"


@interface StoriesViewController()

@property (nonatomic) NSArray* arrayStories;

@end

@implementation StoriesViewController
@synthesize arrayStories = _arrayStories;

-(NSArray*)arrayStories {
    if (!_arrayStories){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
        request.resultType= NSManagedObjectResultType;
        NSSortDescriptor*sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
        request.sortDescriptors=@[sortDescriptor];
        NSError*error=nil;
        NSArray<Story*>*arrayResult = [PersistentManager.Shared.persistentContainer.viewContext executeFetchRequest:request error:&error];
        if(error!=nil)
            NSLog(@"error=%@",error);
        _arrayStories = arrayResult;
    }
    return  _arrayStories;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame: CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = @"Stories sorting at Cache";
    UIBarButtonItem* barButtonFillStories = [[UIBarButtonItem alloc] initWithTitle:@"fillStories" style:UIBarButtonItemStylePlain
                                        target: self action: NSSelectorFromString(@"actionFillStories")];
    self.navigationItem.rightBarButtonItem = barButtonFillStories;
}

- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellStories"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"idCellStories"];

    Story* story = self.arrayStories[indexPath.row];
    NSString* name = story.name;
    NSString* levelCreditHistory = (story.lavelCreditHistory == YES) ? @"GOOD" : @"BAD";
    NSString* region = story.region;
    NSString* levelCache = (story.levelCache == YES) ? @"big" : @"Lit";
    cell.textLabel.text = [NSString stringWithFormat:@"%@           %@            %@",name,levelCache,levelCreditHistory];
    cell.detailTextLabel.text = region;
    return  cell;

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Name             Cache  CreditHistory          Region";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return self.arrayStories.count;

}

- (void) actionFillStories {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue_for_grupp = dispatch_queue_create("queue_for_grupp", DISPATCH_QUEUE_SERIAL);
        for (int i = 0; i < 10; i++) {
            dispatch_group_async(group, queue_for_grupp, ^{
                [Client.bank addStoriesObject: [[Story alloc] initWithContext:PersistentManager.Shared.persistentContainer.viewContext]];
            });
        }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [PersistentManager.Shared saveContext];
        self->_arrayStories = nil;
        [self.tableView reloadData];
    });

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
    NSSortDescriptor*sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors=@[sortDescriptor];
    NSError*error=nil;
    NSArray<Story*>*arrayResult = [PersistentManager.Shared.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if(error!=nil)
        NSLog(@"error=%@",error);

    Story*story = arrayResult[indexPath.row];

    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request1.sortDescriptors=@[sortDescriptor];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"creditHistory=%d&&region=%@",story.lavelCreditHistory,story.region];
    request1.predicate = predicate;
    [request setIncludesPendingChanges:YES];

    NSArray<Client*>*arrayResult1 = [PersistentManager.Shared.persistentContainer.viewContext executeFetchRequest:request1 error:&error];
    if(error!=nil)
        NSLog(@"error=%@",error);

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Stories to predicate REGION & CREDITHISTORY" message: [NSString stringWithFormat:@" %@ - credHist%D",
                                                                                story.region,story.lavelCreditHistory] preferredStyle:UIAlertControllerStyleAlert];
    for (Client* client in arrayResult1){
        [alert addAction: [UIAlertAction actionWithTitle: [NSString stringWithFormat:@"%@ --- %@ --- %d", client.name,client.region,client.creditHistory] style:UIAlertActionStyleDefault handler:nil]];
    }
    [alert addAction: [UIAlertAction actionWithTitle: @"EXIT" style:UIAlertActionStyleDefault handler:nil]];

    UIWindow* window = [UIApplication.sharedApplication.windows firstObject];
    UINavigationController* nc = (UINavigationController*) window.rootViewController;
    UIViewController* vc = [nc visibleViewController];
    [vc presentViewController: alert animated:YES completion:nil];

}



@end
