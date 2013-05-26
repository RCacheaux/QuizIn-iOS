#import "QIMultipleChoiceQuizView.h"
#import "AsyncImageView.h"



@interface QIMultipleChoiceQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIImageView *dividerTop;
@property(nonatomic, strong) UIImageView *dividerBottom;
@property(nonatomic, strong) UIImageView *profileImageBackground;

@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UILabel *questionLabel;
@property(nonatomic, strong) NSArray *answerButtons;

@property(nonatomic, strong) NSMutableArray *progressViewConstraints;
@property(nonatomic, strong) NSMutableArray *multipleChoiceConstraints; 
@end

@implementation QIMultipleChoiceQuizView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _question = @"";
    _answers = @[];
    
    _viewBackground = [self newViewBackground];
    _dividerTop = [self newDivider];
    _dividerBottom = [self newDivider];
    _profileImageBackground = [self newProfileImageBackground];
    
    _progressView = [self newProgressView];
    _profileImageView = [self newProfileImageView];
    _questionLabel = [self newQuestionLabel];
    _answerButtons = @[];
    _nextQuestionButton = [self newNextQuestionButton];
    
    
  
    //TODO rkuhlman not sure if this shoudl stay here. 
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self constructViewHierarchy];
  }
  return self;
}


#pragma mark Properties

- (void)setQuizProgress:(NSUInteger)quizProgress {
  _quizProgress = quizProgress;
  [self updateProgress];
}

- (void)setNumberOfQuestions:(NSUInteger)numberOfQuestions {
  _numberOfQuestions = numberOfQuestions;
  [self updateProgress];
}

- (void)setQuestion:(NSString *)question {
  if ([question isEqualToString:_question]) {
    return;
  }
  _question = question;
  self.questionLabel.text = _question;
}

- (void)setProfileImage:(UIImage *)profileImage {
  if ([profileImage isEqual:_profileImage]) {
    return;
  }
  _profileImage = profileImage;
  self.profileImageView.image = _profileImage;
}

- (void)setAnswers:(NSArray *)answers {
  if ([answers isEqualToArray:_answers]) {
    return;
  }
  _answers = [answers copy];
  [self updateAnswerButtons];
}

- (void)setAnswerButtons:(NSArray *)answerButtons {
  if ([answerButtons isEqualToArray:_answerButtons]) {
    return;
  }
  _answerButtons = answerButtons;
  [self loadAnswerButtons];
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.viewBackground];
  [self addSubview:self.profileImageBackground];
  [self addSubview:self.profileImageView];
  [self addSubview:self.progressView];
  [self addSubview:self.questionLabel];
  [self addSubview:self.nextQuestionButton];
  [self addSubview:self.dividerTop];
  [self addSubview:self.dividerBottom];
}

- (void)loadAnswerButtons {
  for (UIButton *button in self.answerButtons) {
    [self addSubview:button];
  }
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
    
  if (!self.multipleChoiceConstraints) {
    
    // Constrain Self
    NSDictionary *selfConstraintView =NSDictionaryOfVariableBindings(self);
    
    NSArray *hSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:selfConstraintView];
    
    NSArray *vSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                            options:0
                                            metrics:nil
                                              views:selfConstraintView];
    
    NSMutableArray *selfConstraints = [NSMutableArray array];
    [selfConstraints addObjectsFromArray:hSelf];
    [selfConstraints addObjectsFromArray:vSelf];
    [self.superview addConstraints:selfConstraints];
    
    //Constrain Background Image
    self.multipleChoiceConstraints = [NSMutableArray array];
  
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    [self.multipleChoiceConstraints addObjectsFromArray:hBackgroundContraints];
    [self.multipleChoiceConstraints addObjectsFromArray:vBackgroundContraints];
    
    //Constrain View Elements
    NSDictionary *multipleChoiceViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _progressView,       @"_progressView",
                                         _profileImageView,   @"_profileImageView",
                                         _questionLabel,      @"_questionLabel",
                                         _nextQuestionButton, @"_nextQuestionButton",
                                         _answerButtons[0],   @"_answerButtons0",
                                         _answerButtons[1],   @"_answerButtons1",
                                         _answerButtons[2],   @"_answerButtons2",
                                         _answerButtons[3],   @"_answerButtons3",
                                         nil];
    
    NSLayoutConstraint *centerImageX = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *imageWidth = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *centerQuestionX = [NSLayoutConstraint constraintWithItem:_questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
   
    NSMutableArray *choiceButtonConstraints = [NSMutableArray array];
    for (UIButton *button in self.answerButtons){
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:283.0f]];
    }
    
    NSLayoutConstraint *hNextButton = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
    
    NSString *quizChoiceVertical = @"V:|[_progressView][_profileImageView(==120)]-[_questionLabel]-[_answerButtons0(==55)]-[_answerButtons1(==_answerButtons0)]-[_answerButtons2(==_answerButtons0)]-[_answerButtons3(==_answerButtons0)]-[_nextQuestionButton]-|";
    NSArray *quizChoiceVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:quizChoiceVertical
                                            options:0
                                            metrics:nil
                                              views:multipleChoiceViews];
    
    
    [self.multipleChoiceConstraints addObjectsFromArray:@[centerImageX,imageWidth,centerQuestionX,hNextButton]];
    [self.multipleChoiceConstraints addObjectsFromArray:choiceButtonConstraints];
    [self.multipleChoiceConstraints addObjectsFromArray:quizChoiceVerticalConstraints];
    
    //Constrain Profile Image Holder
    NSDictionary *profileImageConstraintView = NSDictionaryOfVariableBindings(_profileImageBackground);
    
    [self addConstraints:self.multipleChoiceConstraints];
  }
}

#pragma mark Strings

- (NSString *)nextQuestionButtonText {
  return @"Next Question >";
}

#pragma mark Data Display

-(void)updateProgress{
  self.progressView.numberOfQuestions = _numberOfQuestions;
  self.progressView.quizProgress = _quizProgress;
}


- (void)updateAnswerButtons {
  if ([self.answers count] == 0) {
    return;
  }
  NSMutableArray *answerButtons = [NSMutableArray arrayWithCapacity:[self.answers count]];
  for (NSString *answer in self.answers) {
    UIButton *answerButton = [self newAnswerButtonWithTitle:answer];
    [answerButtons addObject:answerButton];
  }
  self.answerButtons = [answerButtons copy];
}

- (void)answerButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  if (pressedButton.selected == NO){
    for (UIButton *button in self.answerButtons){
      button.selected = NO;
    }
    pressedButton.selected = YES;
  }
}


#pragma mark Factory Methods

- (QIProgressView *)newProgressView{  //progressView
  QIProgressView *progressView = [[QIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  progressView.numberOfQuestions = _numberOfQuestions;
  progressView.quizProgress = _quizProgress;
  return progressView;
}

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}
- (UIImageView *)newDivider{
  UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_divider"]];
  [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
  return divider;
}
- (UIImageView *)newProfileImageBackground{
  UIImageView *profileBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiplechoice_pictureholder"]];
  [profileBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
  return profileBackground;
}

- (AsyncImageView *)newProfileImageView {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  //profileImageView.image = [UIImage imageNamed:@"placeholderHead"];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
 
  //super large test image
  profileImageView.imageURL = [NSURL URLWithString:@"http://cdn.urbanislandz.com/wp-content/uploads/2011/10/MMSposter-large.jpg"];
 
  // rick image (realistic size)
  //profileImageView.imageURL = [NSURL URLWithString:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-1GoRs4ppiKY3Ta53ROlRJPt6osaXKdBTflGKXf0fT3XT433d"];
  return profileImageView;
}

- (UILabel *)newQuestionLabel {
  UILabel *questionLabel = [[UILabel alloc] init];
  questionLabel.textAlignment = NSTextAlignmentCenter;
  questionLabel.backgroundColor = [UIColor clearColor];
  [questionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return questionLabel;
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [answerButton setTitle:title forState:UIControlStateNormal];
  answerButton.titleLabel.font = [UIFont fontWithName:@"Tahoma-Bold" size:15.0f];
  answerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  answerButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
  answerButton.titleLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [answerButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f)];
  [answerButton setBackgroundImage:[UIImage imageNamed:@"multiplechoice_answer_btn"] forState:UIControlStateNormal];
  [answerButton setBackgroundImage:[UIImage imageNamed:@"multiplechoice_answer_btn_pressed"] forState:UIControlStateSelected];
  [answerButton setBackgroundImage:[UIImage imageNamed:@"multiplechoice_answer_btn_pressed"] forState:UIControlStateSelected | UIControlStateHighlighted];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerButton setAdjustsImageWhenHighlighted:NO];
  [answerButton setReversesTitleShadowWhenHighlighted:NO];
  
  [answerButton addTarget:self action:@selector(answerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  return answerButton;
}

- (UIButton *)newNextQuestionButton {
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}


@end
