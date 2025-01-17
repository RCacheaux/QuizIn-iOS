#import "QIBusinessCardViewController.h"
#import "QIQuizQuestionViewController_Protected.h"
#import "QIBusinessCardQuestion.h"
#import "QIPerson.h"
#import "LinkedIn.h"

@interface QIBusinessCardViewController ()
@property(nonatomic, strong, readonly) QIBusinessCardQuestion *businessCardQuestion;
@property(nonatomic, strong) QIPerson *loggedInUser; 
@end

@implementation QIBusinessCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _loggedInUser = [LinkedIn authenticatedUser];
  }
  return self;
}

- (void)loadView{
  self.view = [[QIBusinessCardQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.businessCardQuizView.interactor = self;
  self.businessCardQuizView.numberOfQuestions = 10;
  self.businessCardQuizView.quizProgress = 4;
  self.businessCardQuizView.questionImageURL = [NSURL URLWithString:self.businessCardQuestion.person.pictureURL];
  self.businessCardQuizView.answerNames = self.businessCardQuestion.names;
  self.businessCardQuizView.answerCompanies = self.businessCardQuestion.companies;
  self.businessCardQuizView.answerTitles = self.businessCardQuestion.titles;
  self.businessCardQuizView.answerPerson = self.businessCardQuestion.person;  
  self.businessCardQuizView.correctNameIndex = self.businessCardQuestion.correctNameIndex;
  self.businessCardQuizView.correctCompanyIndex = self.businessCardQuestion.correctCompanyIndex;
  self.businessCardQuizView.correctTitleIndex = self.businessCardQuestion.correctTitleIndex;
  
  [self setLoggedInUser:[LinkedIn authenticatedUser]]; 
  [self.businessCardQuizView setLoggedInUserID:self.loggedInUser.personID];
  [self.businessCardQuizView.rankDisplayView setProfileImageURL:[NSURL URLWithString:self.loggedInUser.pictureURL]];
  [self.businessCardQuizView.rankDisplayView setProfileName:self.loggedInUser.formattedName];
  
  [self.businessCardQuizView.checkAnswersView.helpButton addTarget:self
                                                          action:@selector(helpDialog)
                                                forControlEvents:UIControlEventTouchUpInside];
  [self.businessCardQuizView.checkAnswersView.seeProfilesButton addTarget:self
                                                                 action:@selector(showActionSheet:)
                                                       forControlEvents:UIControlEventTouchUpInside];
  [self.businessCardQuizView.rankDisplayView.exitButton addTarget:self.businessCardQuizView
                                                           action:@selector(hideRankDisplay)
                                                 forControlEvents:UIControlEventTouchUpInside];
  [self.businessCardQuizView.overlayMask addTarget:self.businessCardQuizView
                                            action:@selector(hideRankDisplay)
                                  forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Action Sheet Functions
- (void)showActionSheet:(id)sender{
  NSString *actionSheetTitle = @"Open LinkedIn Profile For:";
  NSString *other1 = [NSString stringWithFormat:@"%@ %@",self.businessCardQuestion.person.firstName,self.businessCardQuestion.person.lastName];
  NSString *cancelTitle = @"Cancel";
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:actionSheetTitle
                                delegate:self
                                cancelButtonTitle:cancelTitle
                                destructiveButtonTitle:nil
                                otherButtonTitles:other1, nil];
  
  [actionSheet setTintColor:[UIColor colorWithRed:.27f green:.45f blue:.64f alpha:1.0f]];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:{
      NSString *personID = self.businessCardQuestion.person.personID;
      NSString *actionUrl = [NSString stringWithFormat:@"linkedin://#profile/%@",personID];
      NSString *actionUrlWeb = self.businessCardQuestion.person.publicProfileURL;
      
      BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:actionUrl]];
      if (canOpenURL){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrl]];
      }
      else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrlWeb]];
      }
      break;
    }
      
    default:
      break;
  }
}

#pragma mark Alert Functions

- (void)helpDialog{

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Business Card Question"
                                                  message:@"Swipe the answer selectors left and right to fill out the business card and touch Check Answers"
                                                 delegate:nil
                                        cancelButtonTitle:@"Thanks"
                                        otherButtonTitles:nil];
  for (UIView *view in alert.subviews) {
    if([[view class] isSubclassOfClass:[UILabel class]]) {
      [((UILabel*)view) setTextAlignment:NSTextAlignmentLeft];
    }
  }
  [alert show];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (QIBusinessCardQuizView *)businessCardQuizView {
  return (QIBusinessCardQuizView *)self.view;
}

- (QIBusinessCardQuestion *)businessCardQuestion {
  return (QIBusinessCardQuestion *)self.question;
}

@end
