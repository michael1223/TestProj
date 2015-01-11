//
//  BBSlider.m
//  BBSlider
//
//  Created by star on 12/15/14.
//  Copyright (c) 2014 star. All rights reserved.
//

#import "BBSlider.h"

#define SLIDER_HEIGHT 2.0
#define COLOR_PINK  [UIColor colorWithRed:169/255.0 green:33/255.0 blue:142/255.0 alpha:1.0]
#define COLOR_PURPLE [UIColor colorWithRed:125/255.0 green:76/255.0 blue:158/255.0 alpha:1.0]


@interface BBSlider()

@property (nonatomic, assign) float trackHeight;

@end

@implementation BBSlider

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.trackHeight = SLIDER_HEIGHT;
        [self valueDidChange];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.trackHeight = SLIDER_HEIGHT;
        [self valueDidChange];
    }
    return self;
}

- (void)valueDidChange
{
    if ((self.value - self.minimumValue) > 0) {
        [self setMinSliderTrackImage];
    }
    
    if ((self.maximumValue - self.value) > 0) {
        [self setMaxSliderTrackImage];
    }
}

/// thumb area increase
/// override function
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], -100 , -100);
}

- (void)setValue:(float)value
{
    [super setValue:value];
    [self valueDidChange];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    [self valueDidChange];
}

- (void) setMinSliderTrackImage
{
    
    float barwidth = (int)((self.value - self.minimumValue)/(self.maximumValue - self.minimumValue) * self.frame.size.width);
    UIGraphicsBeginImageContext(CGSizeMake(barwidth, self.trackHeight));
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    const CGFloat* col1 = CGColorGetComponents(COLOR_PURPLE.CGColor);
    const CGFloat* col2 = CGColorGetComponents(COLOR_PINK.CGColor);
//    NSLog(@"%.2f,%.2f,%.2f  :  %.2f,%.2f,%.2f", col1[0],col1[1],col1[2], col2[0], col2[1], col2[2]);
    float redVal    = col1[0] * (self.maximumValue - self.value)/self.maximumValue + col2[0] * self.value/self.maximumValue;
    float greenVal  = col1[1] * (self.maximumValue - self.value)/self.maximumValue + col2[1] * self.value/self.maximumValue;
    float blueVal   = col1[2] * (self.maximumValue - self.value)/self.maximumValue + col2[2] * self.value/self.maximumValue;
    float alphaVal  = CGColorGetAlpha(COLOR_PURPLE.CGColor) * (self.maximumValue - self.value)/self.maximumValue + CGColorGetAlpha(COLOR_PINK.CGColor) * self.value/self.maximumValue;
    
//    NSLog(@"%.2f,%.2f,%.2f", redVal, greenVal, blueVal);
    
    UIColor* color = [UIColor colorWithRed:redVal green:greenVal blue:blueVal alpha:alphaVal];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)COLOR_PURPLE.CGColor,
                               (id)color.CGColor, nil];
    CGFloat gradientLocations[] = {1, 0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Bezier Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, barwidth, self.trackHeight)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(barwidth, self.trackHeight/2.0), CGPointMake(-0, self.trackHeight/2.0), 0);
    UIImage *backgroundImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0) resizingMode:UIImageResizingModeStretch];
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    [self setMinimumTrackImage:backgroundImage forState:UIControlStateNormal];
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void) setMaxSliderTrackImage
{
    float barwidth = self.frame.size.width - (int)((self.value - self.minimumValue)/(self.maximumValue - self.minimumValue) * self.frame.size.width);
    UIGraphicsBeginImageContext(CGSizeMake(barwidth, self.trackHeight));
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    const CGFloat* col1 = CGColorGetComponents(COLOR_PURPLE.CGColor);
    const CGFloat* col2 = CGColorGetComponents(COLOR_PINK.CGColor);

    float redVal    = col1[0] * (self.maximumValue - self.value)/self.maximumValue + col2[0] * self.value/self.maximumValue;
    float greenVal  = col1[1] * (self.maximumValue - self.value)/self.maximumValue + col2[1] * self.value/self.maximumValue;
    float blueVal   = col1[2] * (self.maximumValue - self.value)/self.maximumValue + col2[2] * self.value/self.maximumValue;
    float alphaVal  = CGColorGetAlpha(COLOR_PURPLE.CGColor) * (self.maximumValue - self.value)/self.maximumValue + CGColorGetAlpha(COLOR_PINK.CGColor) * self.value/self.maximumValue;
    
    UIColor* color = [UIColor colorWithRed:redVal green:greenVal blue:blueVal alpha:alphaVal];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)color.CGColor,
                               (id)COLOR_PINK.CGColor, nil];
    CGFloat gradientLocations[] = {1, 0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Bezier Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, barwidth, self.trackHeight)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(barwidth, self.trackHeight/2.0), CGPointMake(-0, self.trackHeight/2.0), 0);
    UIImage *backgroundImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0) resizingMode:UIImageResizingModeStretch];
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    [self setMaximumTrackImage:backgroundImage forState:UIControlStateNormal];
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

@end
