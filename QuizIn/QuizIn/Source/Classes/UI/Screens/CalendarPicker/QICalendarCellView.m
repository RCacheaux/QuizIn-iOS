//
//  QICalendarCellView.m
//  QuizIn
//
//  Created by Rick Kuhlman on 6/16/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QICalendarCellView.h"

@interface QICalendarCellView ()



@end

@implementation QICalendarCellView
@synthesize frontView,backView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
