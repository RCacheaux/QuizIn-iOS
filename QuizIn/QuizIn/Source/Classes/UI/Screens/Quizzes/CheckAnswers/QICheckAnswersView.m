
#import "QICheckAnswersView.h"
#import "QIFontProvider.h"

@interface QICheckAnswersView ()

@property(nonatomic, strong) UILabel *resultLabel;
@property(nonatomic, strong) UIView *resultView;
@property(nonatomic, strong,) UIImageView *backgroundImage;
@property(nonatomic, strong) NSMutableArray *checkAnswersViewConstraints;
@property(nonatomic, strong) NSMutableArray *resultViewConstraints;

@end

@implementation QICheckAnswersView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _backgroundImage = [self newBackgroundImage];
      _resultView = [self newResultView];
      _resultLabel = [self newResultLabel];
      _checkButton = [self newCheckButton];
      _helpButton = [self newHelpButton];
      _againButton = [self newAgainButton];
      _nextButton = [self newNextButton];
      _resultHideButton = [self newResultHideButton];
      _seeProfilesButton = [self newSeeProfilesButton];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setCheckButton:(UIButton *)checkButton{
  if ([checkButton isEqual:_checkButton]) {
    return;
  }
  _checkButton = checkButton;
}


#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self.resultView addSubview:self.resultLabel];
  [self addSubview:self.backgroundImage];
  [self addSubview:self.seeProfilesButton];
  [self addSubview:self.resultView];
  [self addSubview:self.helpButton];
  [self addSubview:self.resultHideButton];
  [self addSubview:self.checkButton];
  [self addSubview:self.againButton];
  [self addSubview:self.nextButton];
  [self resetView]; 
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.checkAnswersViewConstraints) {
    
    self.checkAnswersViewConstraints = [NSMutableArray array];
    
    //Constrain Background Image
    NSDictionary *backgroundImageViews = NSDictionaryOfVariableBindings(_backgroundImage);
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageViews];
     NSArray *vBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageViews];
    
    [self.checkAnswersViewConstraints addObjectsFromArray:hBackground];
    [self.checkAnswersViewConstraints addObjectsFromArray:vBackground];
    
    //Check Answer View Constraints

    NSDictionary *checkAnswerViews = NSDictionaryOfVariableBindings(_resultView, _checkButton, _helpButton, _againButton, _seeProfilesButton);
    
    NSArray *hHelpButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_helpButton(==30)]-5-[_seeProfilesButton(==30)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    
    NSArray *vHelpButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_helpButton(==30)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
   
    NSArray *vProfileButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_seeProfilesButton(==30)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    
    NSArray *hCheckButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_againButton(==108)]-10-[_checkButton(==108)]-10-|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *hResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *vResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_checkButton(==25)]-9-[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *vAgainButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_againButton(==25)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    //Overlay the Next Button
    NSLayoutConstraint *hCenterNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];

    //Overlay the Result Hide Button
    NSLayoutConstraint *hCenterHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    [self.checkAnswersViewConstraints addObjectsFromArray:@[hCenterHideButton,vCenterHideButton,widthHideButton,heightHideButton]];
    [self.checkAnswersViewConstraints addObjectsFromArray:@[hCenterNextButton,vCenterNextButton,widthNextButton,heightNextButton]];
    [self.checkAnswersViewConstraints addObjectsFromArray:hHelpButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vHelpButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vProfileButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:hCheckButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vAgainButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:hResultConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vResultConstraints];
    
    [self addConstraints:self.checkAnswersViewConstraints];
    
    //Result View Constraints
    self.resultViewConstraints = [NSMutableArray array];
    
    NSLayoutConstraint *hCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    [self.resultViewConstraints addObjectsFromArray:@[hCenterLabel,vCenterLabel]];
  
    [_resultView addConstraints:self.resultViewConstraints];
  }
}

#pragma mark Actions
-(void)correct:(BOOL)correct{
  [self.helpButton setHidden:YES];
  [self.seeProfilesButton setHidden:NO];
  [self.nextButton setHidden:NO];
  [self.checkButton setHidden:YES];
  [self.resultHideButton setHidden:NO];
  if(correct){
    [self.againButton setHidden:YES];
    [self.backgroundImage setImage:[UIImage imageNamed:@"quizin_navbar_correct"]];
    [self.resultLabel setText:[self resultCorrectText]];
  }
  else {
    [self.backgroundImage setImage:[UIImage imageNamed:@"quizin_navbar_incorrect"]];
    [self.resultLabel setText:[self resultIncorrectText]];
    [self.againButton setHidden:NO];
  }
}

- (void)resetView {
  [self.helpButton setHidden:NO];
  [self.seeProfilesButton setHidden:YES];
  [self.nextButton setHidden:YES];
  [self.againButton setHidden:YES];
  [self.checkButton setHidden:NO];
  [self.resultHideButton setHidden:YES];
}

#pragma mark Strings
- (NSString *)checkButtonText{
  return @"Check Answer";
}
- (NSString *)nextButtonText{
  return @"Continue";
}
- (NSString *)againButtonText{
  return @"Try Again";
}
- (NSString *)resultCorrectText{
  return @"Correct";
}
- (NSString *)resultIncorrectText{
  return @"Incorrect";
}


#pragma mark Factory Methods

-(UIImageView *)newBackgroundImage{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_navbar_correct"]];
  [imageView setContentMode:UIViewContentModeScaleToFill];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}
- (UIView *)newResultView{
  UIView *view = [[UIView alloc] init];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

- (UILabel *)newResultLabel {
  UILabel *resultLabel = [[UILabel alloc] init];
  [resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [resultLabel setBackgroundColor:[UIColor clearColor]];
  [resultLabel setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [resultLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  return resultLabel;
}

- (UIButton *)newCheckButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self checkButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_std_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}
- (UIButton *)newNextButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self nextButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_forward_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES];
  return button;
}
- (UIButton *)newAgainButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self againButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_std_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES];
  return button;
}
- (UIButton *)newHelpButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"hobnob_question_icon"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setAdjustsImageWhenHighlighted:YES];
  return button;
}

- (UIButton *)newResultHideButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"hobnob_stretch_icon"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setAdjustsImageWhenHighlighted:YES];
  [button setHidden:YES];
  return button;
}

- (UIButton *)newSeeProfilesButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"hobnob_profile_icon"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setAdjustsImageWhenHighlighted:YES];
  return button;
}

@end