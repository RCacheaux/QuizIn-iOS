
#import <UIKit/UIKit.h>
#import "QIStatsView.h"
#import "QIStatsData.h"

@interface QIStatsViewController : UIViewController

@property (nonatomic, strong) QIStatsView *statsView;
@property (nonatomic, strong) NSString *userID; 

@end