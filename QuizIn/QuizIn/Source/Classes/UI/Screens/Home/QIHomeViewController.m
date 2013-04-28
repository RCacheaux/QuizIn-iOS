#import "QIHomeViewController.h"

#import "QIHomeView.h"
#import "QIQuizViewController.h"

@interface QIHomeViewController ()
@property(nonatomic, strong, readonly) QIHomeView *homeView;
@end

@implementation QIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self loadNavigation];
  }
  return self;
}

- (void)loadNavigation {
  self.title = [self homeScreenTitle];
}

- (void)loadView {
  self.view = [[QIHomeView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.homeView.connectionsQuizButton addTarget:self
                                          action:@selector(startConnectionsQuiz:)
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (void)startConnectionsQuiz:(id)sender {
  [self presentViewController:[self newQuizViewController] animated:YES completion:nil];
}

#pragma mark Strings

- (NSString *)homeScreenTitle {
  return @"Quizin";
}
   
#pragma mark Properties

- (QIHomeView *)homeView {
  return (QIHomeView *)self.view;
}

#pragma mark Factory Methods

- (QIQuizViewController *)newQuizViewController {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] init];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

@end
