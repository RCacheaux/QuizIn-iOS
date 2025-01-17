#import "QICalendarPickerView.h"
#import "QICalendarCellView.h"
#import "QICalendarData.h"
#import "QICalendarTableHeaderView.h"
#import "QICalendarTableFooterView.h"

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -94

@interface QICalendarPickerView ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topSlit;
@property (nonatomic, strong) UIImageView *bottomSlit;
@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) QICalendarTableFooterView *footerViewLoading;
@property (nonatomic, assign) int numberOfCalendarDataLoads; 

@end

@implementation QICalendarPickerView

//@synthesize tableView=_tableView;
@synthesize openCellLastTX, openCellIndexPath;

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _footerViewLoading = [self newFooterViewLoading];
      _tableView = [self newCalendarTable];
      _topSlit = [self newTopSlit];
      _bottomSlit = [self newBottomSlit];
      _viewBackground = [self newViewBackground];
      _quizButton = [self newQuizButton];
      _numberOfCalendarDataLoads = 1;
      
      //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties
-(void) setCalendarContent:(NSMutableArray *)calendarContent {
  if ([calendarContent isEqualToArray:_calendarContent]) {
    return;
  }
  _calendarContent = calendarContent;
}
#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self addSubview:self.viewBackground];
  [self addSubview:self.tableView];
  [self addSubview:self.topSlit];
  [self addSubview:self.bottomSlit];
  [self addSubview:self.quizButton];
  [self.tableView setTableFooterView:self.footerViewLoading];
}
#pragma Data Display

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
    
    //Constrain Background
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    self.viewConstraints = [NSMutableArray array];
    [self.viewConstraints addObjectsFromArray:hBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:vBackgroundContraints];
 
    
    //Constrain Main View Elements
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_topSlit,_tableView,_bottomSlit,_quizButton);
    
    NSArray *vMainViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_topSlit(==8)]-(-5)-[_tableView]-(-5)-[_bottomSlit(==8)]-[_quizButton(==54)]-6-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hTopSlitConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_topSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hTableViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_tableView]-15-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hBottomSlitConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_bottomSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_quizButton]-14-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    
    [self.viewConstraints addObjectsFromArray:hTopSlitConstraints];
    [self.viewConstraints addObjectsFromArray:hTableViewConstraints];
    [self.viewConstraints addObjectsFromArray:hBottomSlitConstraints];
    [self.viewConstraints addObjectsFromArray:vMainViewsConstraints];
    [self.viewConstraints addObjectsFromArray:hButtonConstraints];
    
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark Strings
-(NSString *)quizButtonTitle{
  return @"Take Quiz";
}
#pragma mark Factory Methods

-(UITableView *)newCalendarTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:.3f]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.rowHeight = 94;
  tableView.sectionHeaderHeight = 25;
  tableView.dataSource = self;
  tableView.delegate = self; 
  return tableView;
}

-(UIImageView *)newTopSlit{
  UIImageView *slit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_slittop"]];
  [slit setTranslatesAutoresizingMaskIntoConstraints:NO];
  return slit;
}

-(UIImageView *)newBottomSlit{
  UIImageView *slit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_slitbottom"]];
  [slit setTranslatesAutoresizingMaskIntoConstraints:NO];
  return slit;
}

-(UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

-(QICalendarTableFooterView *)newFooterViewLoading{
  QICalendarTableFooterView *footer = [[QICalendarTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
  //QICalendarTableFooterView *footer = [[QICalendarTableFooterView alloc] init];
  //[footer setTranslatesAutoresizingMaskIntoConstraints:NO];
  //[footer setBackgroundColor:[UIColor blackColor]];
  return footer;
}


- (UIButton *)newQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self quizButtonTitle] forState:UIControlStateNormal];
  [button setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 74, 0, 74)] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [self.calendarContent count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
  NSMutableArray *day = [self.calendarContent objectAtIndex:section];
  return [day count]-1;
} 

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  QICalendarTableHeaderView *headerView = [[QICalendarTableHeaderView alloc] init];
  headerView.backgroundColor = [UIColor colorWithWhite:.3f alpha:.8f];
  headerView.sectionTitle = [[self.calendarContent objectAtIndex:section] objectAtIndex:0];
  return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *cellIdentifier = @"CustomCell";
  QICalendarCellView *cell = (QICalendarCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QICalendarCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.backView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:1.0f]];
    [cell setImageURLs:[[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] objectForKey:@"images"]];
    [cell setMeetingTitle:[[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] objectForKey:@"title"]];
    [cell setMeetingLocation:[[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] objectForKey:@"location"]];
    [cell setMeetingTime:[[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] objectForKey:@"time"]];
  }
  
  BOOL selected = [[[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] objectForKey:@"selected"] boolValue];
  if (selected){
    [self snapView:cell.frontView toX:PAN_OPEN_X animated:NO];
  }
  else{
    [self snapView:cell.frontView toX:PAN_CLOSED_X animated:NO];
  }
  
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [panGestureRecognizer setDelegate:self];
  [cell addGestureRecognizer:panGestureRecognizer];
  return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
  NSArray *visibleRows = [self.tableView visibleCells];
  UITableViewCell *lastVisibleCell = [visibleRows lastObject];
  NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
  if(path.section == [self.calendarContent count]-1 && path.row == [[self.calendarContent objectAtIndex:path.section] count]-2)
  {
    [self.calendarContent addObjectsFromArray:[QICalendarData getCalendarDataWithIntervalIndex:self.numberOfCalendarDataLoads withEventStore:self.eventStore]];
     self.numberOfCalendarDataLoads++;
    [self.tableView reloadData];
  }
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
  QICalendarCellView *cell = (QICalendarCellView *)[panGestureRecognizer view];
  CGPoint translation = [panGestureRecognizer translationInView:[cell superview] ];
  return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
}

#pragma mark - Gesture handlers

-(void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
  float threshold = (PAN_OPEN_X+PAN_CLOSED_X)/2.0;
  float vX = 0.0;
  float compare;
  float finalX;
  NSIndexPath *indexPath = [self.tableView indexPathForCell:(QICalendarCellView *)[panGestureRecognizer view] ];
  UIView *view = ((QICalendarCellView *)panGestureRecognizer.view).frontView;
  
  switch ([panGestureRecognizer state]) {
    case UIGestureRecognizerStateBegan:
      if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
        [self setOpenCellIndexPath:nil];
        [self setOpenCellLastTX:0];
      }
      break;
    case UIGestureRecognizerStateEnded:
      vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self].x;
      compare = view.transform.tx + vX;
      if (compare > threshold) {
        finalX = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:0];
        [[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] setObject:@NO forKey:@"selected"];
      } else {
        finalX = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:view.transform.tx];
        [[[self.calendarContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] setObject:@YES forKey:@"selected"];
      }
      [self snapView:view toX:finalX animated:YES];
      if (finalX == PAN_CLOSED_X) {
        [self setOpenCellIndexPath:nil];
      }
      else {
        [self setOpenCellIndexPath:[self.tableView indexPathForCell:(QICalendarCellView *)panGestureRecognizer.view]];
      }
      break;
    case UIGestureRecognizerStateChanged:
      compare = self.openCellLastTX+[panGestureRecognizer translationInView:self].x;
      if (compare > MAX(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MAX(PAN_OPEN_X,PAN_CLOSED_X);
      }
      else if (compare < MIN(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MIN(PAN_OPEN_X,PAN_CLOSED_X);
      }
      [view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
      break;
    default:
      compare = 0;
      break;
  }
}

-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:FAST_ANIMATION_DURATION];
  }
  
  [view setTransform:CGAffineTransformMakeTranslation(x, 0)];
  
  if (animated) {
    [UIView commitAnimations];
  }
}

@end