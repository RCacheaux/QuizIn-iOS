
#import <UIKit/UIKit.h>

@interface QICalendarPickerView : UIView <UITableViewDataSource, UIGestureRecognizerDelegate,
UIScrollViewDelegate,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *calendarContent;
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) NSIndexPath *openCellIndexPath;
- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated;

@property(nonatomic, strong, readonly) UIButton *quizButton;

@end
