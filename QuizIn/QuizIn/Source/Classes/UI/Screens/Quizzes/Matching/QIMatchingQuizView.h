#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "QICheckAnswersView.h"

@interface QIMatchingQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QICheckAnswersView *checkAnswersView;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong, readonly) UIButton *nextQuestionButton;
@property(nonatomic, copy) NSArray *questionImageURLs;
@property(nonatomic, copy) NSArray *answers;


@end
