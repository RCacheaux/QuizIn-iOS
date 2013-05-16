#import "QIQuizViewController.h"

#import "QIQuizView.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardViewController.h"

@interface QIQuizViewController ()
@property(nonatomic, strong, readonly) QIQuizView *quizView;
@property(nonatomic, strong) QIMultipleChoiceQuizViewController *multipleChoiceController;
@property(nonatomic, strong) QIBusinessCardViewController *businessCardController;
@end

@implementation QIQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)loadView {
  self.view = [[QIQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // TODO(rcacheaux): Clean up.
  
  // switch to the other view to test other view (rkuhlman)
  self.businessCardController = [[QIBusinessCardViewController alloc] init];
  [self addChildViewController:self.businessCardController];
  [self.view addSubview:self.businessCardController.view];
/*
  self.multipleChoiceController = [[QIMultipleChoiceQuizViewController alloc] init];
  [self addChildViewController:self.multipleChoiceController];
  [self.view addSubview:self.multipleChoiceController.view];
*/
}



- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.multipleChoiceController.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions


#pragma mark Properties

- (QIQuizView *)quizView {
  return (QIQuizView *)self.view;
}

@end
