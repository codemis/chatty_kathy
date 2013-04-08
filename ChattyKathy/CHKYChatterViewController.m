#import "CHKYChatterViewController.h"
#import "CHKYAppDelegate.h"
#import "Message.h"

@interface CHKYChatterViewController ()
// An array to house all of our fetched Label objects
@property (strong, nonatomic) NSArray *messageArray;
@end

@implementation CHKYChatterViewController

- (IBAction)returnHome:(UIStoryboardSegue *)segue
{
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

#pragma mark - Private methods
- (CHKYAppDelegate *)appDelegate {
    return (CHKYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

// This method executes a fetch request and reloads the table view.
- (void) loadTableData {
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    // Construct a fetch request
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    fetchRequest.entity = [NSEntityDescription entityForName:@"Message"
                                      inManagedObjectContext:context];
    NSError *error = nil;
    self.messageArray = [context executeFetchRequest:fetchRequest error:&error];
    [self.tableView reloadData];
}
@end