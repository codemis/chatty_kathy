@interface CHKYChatterViewController : UITableViewController
@property(strong, nonatomic) NSMutableDictionary *addedMessage;
-(IBAction)addNewMessage:(UIStoryboardSegue*) segue;
@end