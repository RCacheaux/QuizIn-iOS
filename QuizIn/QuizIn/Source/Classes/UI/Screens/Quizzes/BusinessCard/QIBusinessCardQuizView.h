#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "BusinessCardAnswer/QIBusinessCardAnswerView.h"
#import "QICheckAnswersView.h"
#import "QIRankDisplayView.h"
#import "QIPerson.h"
#import "QIQuizQuestionViewInteractor.h"


@interface QIBusinessCardQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QICheckAnswersView *checkAnswersView;
@property(nonatomic, strong) QIRankDisplayView *rankDisplayView;
@property(nonatomic, strong) QIPerson *answerPerson; 
@property(nonatomic, strong) NSURL *questionImageURL;
@property(nonatomic, strong) NSArray *answerNames;
@property(nonatomic, strong) NSArray *answerCompanies;
@property(nonatomic, strong) NSArray *answerTitles;
@property(nonatomic, assign) NSUInteger correctNameIndex;
@property(nonatomic, assign) NSUInteger correctCompanyIndex;
@property(nonatomic, assign) NSUInteger correctTitleIndex;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong) NSString *loggedInUserID;
@property(nonatomic, weak) id<QIQuizQuestionViewInteractor> interactor;
@property (nonatomic, strong) UIButton *overlayMask;

-(void)hideRankDisplay;

@end
