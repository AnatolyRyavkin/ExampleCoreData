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
@property (atomic) NSArray<Client*>* arrayClients;
@property (atomic) NSMutableArray<NSString*>* arrayNameClients;

@property Story* story;

@end

@implementation StoriesViewController
@synthesize arrayStories = _arrayStories;

-(void)dealloc{
    NSLog(@"dealloc");
}

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

    NSManagedObjectContext* context = PersistentManager.Shared.contextBackground;

    NSError* error = nil;
    
    Bank* bank = [context executeFetchRequest:[Bank fetchRequest] error: &error].lastObject;

    if(!bank) {
        bank = [[Bank alloc]initWithContext:context];
    }
        for (int i = 0; i < 10; i++) {
            dispatch_group_async(group, queue_for_grupp, ^{
                [bank addStoriesObject: [[Story alloc]initWithContext:context]];
            });
        }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [context save];
        self->_arrayStories = nil;
        [self.tableView reloadData];
    });

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    [PersistentManager.Shared performBlockAndSaveContextAndPerformCompletedBlockAtMainQueueBlock:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *requestStory = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
        NSSortDescriptor*sortDescriptorStory = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
        requestStory.sortDescriptors=@[sortDescriptorStory];
        NSError*error = nil;
        NSArray<Story*>*arrayResult = [context executeFetchRequest:requestStory error:&error];
        if(error!=nil)
            NSLog(@"error=%@",error);
        self.story = arrayResult[indexPath.row];

        NSFetchRequest* requestClient = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
        NSSortDescriptor*sortDescriptorClient = [[NSSortDescriptor alloc]initWithKey:@"cache" ascending:YES];
        requestClient.sortDescriptors=@[sortDescriptorClient];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"creditHistory=%d&&region=%@",self.story.lavelCreditHistory,self.story.region];
        requestClient.predicate = predicate;
        self.arrayClients = [context executeFetchRequest:requestClient error:&error];
        self.arrayNameClients = [NSMutableArray new];
        for (Client*client in self.arrayClients){
            [self.arrayNameClients addObject: [NSString stringWithFormat:@"%@   ---   %@   ---   %@",client.region, (client.creditHistory==0)?@"bad":@"good",client.name]];
        }
        if(error!=nil)
            NSLog(@"error=%@",error);
    } completion:^(NSManagedObjectContext * _Nonnull context) {

        UIWindow* window = [UIApplication.sharedApplication.windows firstObject];
        UINavigationController* nc = (UINavigationController*) window.rootViewController;
        PresenterTableViewController*pvc = [[PresenterTableViewController alloc]initArrayNames:self.arrayNameClients
            andHeaderString:[NSString stringWithFormat:@"Clients match Story - %@ with region-%@ creditHistory-%@",self.story.name,self.story.region,
                             (self.story.lavelCreditHistory==0)?@"bad":@"good"]];

        [nc pushViewController:pvc animated:YES];

    }];

}



@end



