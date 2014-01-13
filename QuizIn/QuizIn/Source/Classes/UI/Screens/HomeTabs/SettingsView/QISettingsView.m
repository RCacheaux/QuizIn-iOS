#import "QISettingsView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"

@interface QISettingsView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) UIView *businessCardView;
@property (nonatomic, strong) UILabel *loggedInLabel;
@property (nonatomic, strong) UIImageView *businessCardBackground;
@property (nonatomic, strong) AsyncImageView *profileImageView;
@property (nonatomic, strong) UILabel *cardFirstName;
@property (nonatomic, strong) UILabel *cardLastName;
@property (nonatomic, strong) UILabel *cardTitle;

@property (nonatomic, strong) NSMutableArray *viewConstraints; 

@end

@implementation QISettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      _logoutButton = [self newLogoutButton];
      _loggedInLabel = [self newLoggedInLabel];
      _businessCardView = [self newBusinessCardView];
      _businessCardBackground = [self newBusinessCardBackground];
      _profileImageView = [self newProfileImageView];
      _cardFirstName = [self newCardFirstName];
      _cardLastName = [self newCardLastName];
      _cardTitle = [self newCardTitle];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties
- (void)setFirstName:(NSString *)firstName{
  _firstName = firstName;
  [self updateFirstName];
}

- (void)setLastName:(NSString *)lastName{
  _lastName = lastName;
  [self updateLastName];
}

- (void)setTitle:(NSString *)title{
  _title = title;
  [self updateTitle];
}

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL;
  [self updateProfileImage]; 
}

#pragma mark Data Layout
- (void)updateFirstName{
  self.cardFirstName.text = self.firstName;
}

- (void)updateLastName{
  self.cardLastName.text = self.lastName;
}

- (void)updateTitle{
  self.cardTitle.text = self.title;
}

- (void)updateProfileImage{
  self.profileImageView.imageURL = self.profileImageURL;
}


#pragma mark Layout

- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.loggedInLabel];
  
  [_businessCardView addSubview:self.businessCardBackground];
  [_businessCardView addSubview:self.profileImageView];
  [_businessCardView addSubview:self.cardFirstName];
  [_businessCardView addSubview:self.cardLastName];
  [_businessCardView addSubview:self.cardTitle];
  [_businessCardView addSubview:self.logoutButton];

  [self addSubview:self.businessCardView];
}


- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
    
    // Constrain Base Views
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
    
    //Business Card Container View
    NSDictionary *businessCardView = NSDictionaryOfVariableBindings(_businessCardView,_loggedInLabel);

    NSString *hBusinessCardView = @"H:|-[_businessCardView(==283)]";
    NSArray *hBusinessCardViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hBusinessCardView
                                            options:0
                                            metrics:nil
                                              views:businessCardView];
    
    NSString *vBusinessCardView = @"V:|-50-[_loggedInLabel(==15)][_businessCardView(==180)]";
    NSArray *vBusinessCardViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vBusinessCardView
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:businessCardView];
    
    [self.viewConstraints addObjectsFromArray:vBusinessCardViewConstraints];
    [self.viewConstraints addObjectsFromArray:hBusinessCardViewConstraints];
    
    //Business Card Background Image
    
    NSLayoutConstraint *hCardBackgroundCenter =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vCardBackgroundCenter =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *CardBackgroundWidth =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:283.0f];
    
    NSLayoutConstraint *CardBackgroundHeight =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:180.0f];
    
    [self.viewConstraints addObjectsFromArray:@[hCardBackgroundCenter,vCardBackgroundCenter,CardBackgroundHeight,CardBackgroundWidth]];
    
    //Constrain Business Card Elements
    NSDictionary *cardViews = NSDictionaryOfVariableBindings(_businessCardBackground,
                                                             _profileImageView,
                                                             _cardFirstName,
                                                             _cardLastName,
                                                             _cardTitle,
                                                             _logoutButton);
    NSArray *hProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSArray *vProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-22-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hFirstName = @"H:[_profileImageView]-5-[_cardFirstName]-|";
    NSArray *hFirstNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hFirstName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hLastName = @"H:[_profileImageView]-5-[_cardLastName]-|";
    NSArray *hLastNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hLastName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hTitle= @"H:[_profileImageView]-5-[_cardTitle]-|";
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hTitle
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *vCardFirstName = @"V:|-25-[_cardFirstName]";
    NSArray *vCardFirstNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCardFirstName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSLayoutConstraint *vCardLastNameConstraint =
    [NSLayoutConstraint constraintWithItem:_cardLastName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cardFirstName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-7.0f];
    
    NSString *vCardCompany = @"V:[_cardLastName][_cardTitle(==20)]";
    NSArray *vCardCompanyConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCardCompany
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSLayoutConstraint *hCardLogoutConstraint =
    [NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vCardLogoutConstraint =
    [NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-30.0f];
 
    
    [self.viewConstraints addObjectsFromArray:hProfileImageConstraints];
    [self.viewConstraints addObjectsFromArray:vProfileImageConstraints];
    [self.viewConstraints addObjectsFromArray:hFirstNameConstraints];
    [self.viewConstraints addObjectsFromArray:hLastNameConstraints];
    [self.viewConstraints addObjectsFromArray:hTitleConstraints];
    [self.viewConstraints addObjectsFromArray:vCardFirstNameConstraints];
    [self.viewConstraints addObjectsFromArray:@[vCardLastNameConstraint,hCardLogoutConstraint,vCardLogoutConstraint]];
    [self.viewConstraints addObjectsFromArray:vCardCompanyConstraints];
    
    [self addConstraints:self.viewConstraints];
  }
}


#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UILabel *)newLoggedInLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setText:@"Currently Logged In"];
  [label setFont:[QIFontProvider fontWithSize:13.0f style:Regular]];
  [label setTextColor:[UIColor colorWithWhite:0.50f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setTextAlignment:NSTextAlignmentCenter];
  return label;
}

- (UIButton *)newLogoutButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_preview_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

-(UIView *) newBusinessCardView{
  UIView *businessCardView = [[UIView alloc] init];
  [businessCardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return businessCardView;
}

-(UIImageView *)newBusinessCardBackground{
  int imagePicker = arc4random_uniform(5);
  DDLogInfo(@"%d",imagePicker);
  NSString *imageName = @"cardquiz_businesscard";
  UIImageView *businessCardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  [businessCardBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
  return businessCardBackground;
}

- (AsyncImageView *)newProfileImageView {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  profileImageView.image = [UIImage imageNamed:@"placeholderHead"];
  return profileImageView;
}

-(UILabel *)newCardFirstName{
  UILabel *cardName = [[UILabel alloc] init];
  [cardName setText:self.firstName];
  [cardName setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardName setBackgroundColor:[UIColor clearColor]];
  [cardName setFont:[QIFontProvider fontWithSize:26.0f style:Regular]];
  [cardName setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [cardName setAdjustsLetterSpacingToFitWidth:YES];
  [cardName setAdjustsFontSizeToFitWidth:YES];
  [cardName setNumberOfLines:1];
  [cardName setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardName;
}
-(UILabel *)newCardLastName{
  UILabel *cardName = [[UILabel alloc] init];
  [cardName setText:self.lastName];
  [cardName setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardName setBackgroundColor:[UIColor clearColor]];
  [cardName setFont:[QIFontProvider fontWithSize:26.0f style:Regular]];
  [cardName setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [cardName setAdjustsLetterSpacingToFitWidth:YES];
  [cardName setAdjustsFontSizeToFitWidth:YES];
  [cardName setNumberOfLines:1];
  [cardName setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardName;
}
-(UILabel *)newCardTitle{
  UILabel *cardTitle = [[UILabel alloc] init];
  [cardTitle setText:self.title];
  [cardTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardTitle setBackgroundColor:[UIColor clearColor]];
  [cardTitle setFont:[QIFontProvider fontWithSize:14.0f style:Italics]];
  [cardTitle setTextColor:[UIColor colorWithWhite:.50f alpha:1.0f]];
  [cardTitle setAdjustsLetterSpacingToFitWidth:YES];
  [cardTitle setAdjustsFontSizeToFitWidth:YES];
  [cardTitle setMinimumScaleFactor:.8f];
  [cardTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardTitle;
}

@end