#import "QIRankView.h"
#import "QIRankCellView.h"
#import "QIRankTableHeaderView.h"
#import "QIRankDefinition.h"

@interface QIRankView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) QIRankTableHeaderView *headerView; 
@property (nonatomic, retain) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSArray *rankDelineations;
@property (nonatomic, strong) NSArray *rankBadges;
@property (nonatomic, strong) NSArray *rankDescriptions;

@end

@implementation QIRankView
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _viewBackground = [self newViewBackground];
    _headerView = [self newHeaderView];
    _tableView = [self newRankTable];
    _rankDelineations = [QIRankDefinition getRankDelineations];
    _rankBadges = [QIRankDefinition getAllRankBadges];
    _rankDescriptions = [QIRankDefinition getAllRankDescriptions];
    
    [self contstructViewHierarchy];
  }
  return self;
}

#pragma mark Properties

- (void)setRank:(NSString *)rank{
  _rank = rank; 
}

#pragma mark Layout
- (void)contstructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.tableView];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
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
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_tableView);
    
    NSArray *hTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_tableView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:mainViews];
    NSArray *vTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_tableView]|"
                                            options:0
                                            metrics:nil
                                              views:mainViews];
    
    [self.viewConstraints addObjectsFromArray:hTableViewContraints];
    [self.viewConstraints addObjectsFromArray:vTableViewContraints];
    
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

-(QIRankTableHeaderView *)newHeaderView{
  QIRankTableHeaderView *headerView = [[QIRankTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  headerView.backgroundColor = [UIColor redColor];
  return headerView;
}

-(UITableView *)newRankTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  //[tableView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:.3f]];
  //[tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.rowHeight = 94;
  tableView.sectionHeaderHeight = 25;
  tableView.tableHeaderView = self.headerView;
  tableView.dataSource = self;
  tableView.delegate = self;
  return tableView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.rankDelineations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *cellIdentifier = @"CustomCell";
  QIRankCellView *cell = (QIRankCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QIRankCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  }
  cell.textLabel.text = [self.rankDescriptions objectAtIndex:indexPath.row];
  return cell;
}

@end