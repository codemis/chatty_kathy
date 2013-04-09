#import "CHKYChatterViewController.h"
#import "CHKYAppDelegate.h"
#import "Message.h"

@interface CHKYChatterViewController ()
// An array to house all of our fetched Label objects
@property (strong, nonatomic) NSArray *messageArray;
@end

@implementation CHKYChatterViewController

- (IBAction)addNewMessage:(UIStoryboardSegue *)segue
{
    NSManagedObjectContext *context = self.appDelegate.coreDataStore.contextForCurrentThread;
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message"
                                                     inManagedObjectContext:context];
    message.name = self.addedMessage[@"name"];
    message.text = self.addedMessage[@"text"];
    message.messageId = message.assignObjectId;
    [context saveOnSuccess:^
    {
        NSLog(@"I was saved!");
        NSMutableArray *messageArrayCopy = self.messageArray.mutableCopy;
        [messageArrayCopy addObject:message];
        self.messageArray = messageArrayCopy;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
                 onFailure:^(NSError *error)
     {
         NSLog(@"The save wasn’t successful: %@", error);
     }
    ];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Here we call the method to load the table data */
    [self loadTableData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Grab the label
    Message *message = [self.messageArray objectAtIndex:indexPath.row];
    // Set the text of the cell to the label name
    cell.textLabel.text = message.name;
    cell.detailTextLabel.text = message.text;
    return cell;
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.appDelegate.coreDataStore.contextForCurrentThread;
        Message *currentMessage = self.messageArray[indexPath.row];
        [context deleteObject:[context objectWithID:currentMessage.objectID]];
        [context saveOnSuccess:^
        {
            NSMutableArray *messageArrayCopy = self.messageArray.mutableCopy;
            [messageArrayCopy removeObjectAtIndex:indexPath.row];
            self.messageArray = messageArrayCopy;
            NSLog(@"I delete your base!");
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
                     onFailure:^(NSError *error)
        {
            NSLog(@"Delete failed: %@", error);
        }
         ];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark - Private methods
- (CHKYAppDelegate *)appDelegate {
    return (CHKYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

// This method executes a fetch request and reloads the table view.
- (void) loadTableData {
    NSManagedObjectContext *context = self.appDelegate.coreDataStore.contextForCurrentThread;
    // Construct a fetch request
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    fetchRequest.entity = [NSEntityDescription entityForName:@"Message"
                                      inManagedObjectContext:context];
    [context executeFetchRequest:fetchRequest onSuccess:^(NSArray *results)
    {
        self.messageArray = results;
        [self.tableView reloadData];
    }
                       onFailure:^(NSError *error)
     {
         NSLog(@"Unable to get results error: %@", error);
     }];
}
@end