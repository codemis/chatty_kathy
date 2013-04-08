#import "CHKYMessageViewController.h"
#import "CHKYChatterViewController.h"
@interface CHKYMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;
@end

@implementation CHKYMessageViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableDictionary *newMessage = [[NSMutableDictionary alloc] init];
    newMessage[@"name"] = self.nameTextField.text;
    newMessage[@"text"] = self.messageTextField.text;
    CHKYChatterViewController *chatterVC = segue.destinationViewController;
    chatterVC.addedMessage = newMessage;
}
@end