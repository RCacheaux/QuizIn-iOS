#import "QIRankView.h"
#import <UIKit/UIKit.h>

@interface QIRankViewController : UIViewController

@property (nonatomic, strong) QIRankView *rankView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UITabBarController *parentTabBarController; 

@end
