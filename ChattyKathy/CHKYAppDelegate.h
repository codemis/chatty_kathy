#import "StackMob.h"
@class SMClient;
@class SMCoreDataStore;
@class SMPushClient;
@interface CHKYAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) SMCoreDataStore *coreDataStore;
@property (strong, nonatomic) SMClient *client;
@property (strong, nonatomic) SMPushClient *pushClient;
@end
