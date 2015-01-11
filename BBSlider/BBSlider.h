//
//  BBSlider.h
//  BBSlider
//
//  Created by star on 12/15/14.
//  Copyright (c) 2014 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBSliderDelegate;


@interface BBSlider : UISlider

@property (nonatomic, strong) UIColor *minValueColor;
@property (nonatomic, strong) UIColor *maxValueColor;
@property (nonatomic, readonly) id<BBSliderDelegate> delegate;

@end

@protocol BBSliderDelegate <NSObject>
@required
/**
 @param sender The slider object whose value changed.
 @param value of the slider.  Readonly property that can only be set in initialization.
 */
- (void)slider:(BBSlider *)sender valueDidChangeTo:(float)value;

@end