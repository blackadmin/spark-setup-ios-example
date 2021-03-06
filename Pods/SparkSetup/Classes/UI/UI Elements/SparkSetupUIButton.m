//
//  SparkSetupUIButton.m
//  teacup-ios-app
//
//  Created by Ido on 1/16/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIButton.h"
#import "SparkSetupCustomization.h"
@implementation SparkSetupUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didUntouchButton:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(didUntouchButton:) forControlEvents:UIControlEventTouchUpInside];


    }
    return self;
}

-(void)replacePredefinedText
{
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{device}" withString:[SparkSetupCustomization sharedInstance].deviceName];
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{brand}" withString:[SparkSetupCustomization sharedInstance].brandName];
    NSString *orgName = [SparkSetupCustomization sharedInstance].organizationName;
    if (orgName)
        self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{org name}" withString:orgName];
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{color}" withString:[SparkSetupCustomization sharedInstance].listenModeLEDColorName];
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{mode button}" withString:[SparkSetupCustomization sharedInstance].modeButtonName];
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{network prefix}" withString:[SparkSetupCustomization sharedInstance].networkNamePrefix];
    self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"{app name}" withString:[SparkSetupCustomization sharedInstance].appName];
}



- (UIColor *)darkerColorForColor:(UIColor *)c // TODO: category for UIColor?
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}


- (void)didTouchButton:(id)sender
{
    if ([self.type isEqualToString:@"action"])
    {
        UIColor *color = [SparkSetupCustomization sharedInstance].elementBackgroundColor;
        self.backgroundColor = [self darkerColorForColor:color];
    }
    [self setNeedsDisplay];

}

- (void)didUntouchButton:(id)sender
{
    if ([self.type isEqualToString:@"action"])
    {
        self.backgroundColor = [SparkSetupCustomization sharedInstance].elementBackgroundColor;
    }
    [self setNeedsDisplay];
    
}


-(void)setType:(NSString *)type
{
    _type = type;
    [self replacePredefinedText];

    
    if ([type isEqualToString:@"action"])
    {
        UIFont *boldFont = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].boldTextFontName size:self.titleLabel.font.pointSize+[SparkSetupCustomization sharedInstance].fontSizeOffset];
        self.titleLabel.font = boldFont;
        self.titleLabel.textColor = [SparkSetupCustomization sharedInstance].elementTextColor;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [SparkSetupCustomization sharedInstance].elementBackgroundColor;
        
    }

    if ([type isEqualToString:@"link"])
    {
        NSMutableAttributedString *s;
        NSString *text = self.titleLabel.text;
        
        s = [[NSMutableAttributedString alloc] initWithString:text];
        [s addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [s length])];

        [self setAttributedTitle:s forState:UIControlStateNormal];
        self.titleLabel.textColor = [SparkSetupCustomization sharedInstance].linkTextColor;
        self.titleLabel.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].normalTextFontName size:self.titleLabel.font.pointSize+[SparkSetupCustomization sharedInstance].fontSizeOffset];
        self.backgroundColor = [UIColor clearColor];
    }

    [self setNeedsDisplay];
    [self layoutIfNeeded];
}


-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = 0.5;
    }
    [self setNeedsDisplay];
    
}
@end
