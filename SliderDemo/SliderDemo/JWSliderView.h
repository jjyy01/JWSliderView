//
//  JWSliderView.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/17/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWSliderViewDelegate;

@interface JWSliderView : UIView

@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *goalImageView;//目标图片
@property (nonatomic, strong) NSString *goalImageName;
@property (nonatomic, weak) IBOutlet id<JWSliderViewDelegate> delegate;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL sliding;//处于滑动状态
@property (nonatomic) BOOL selected;//处于第二状态

@property (nonatomic, weak) UITapGestureRecognizer *tapPress;

@end



@protocol JWSliderViewDelegate <NSObject>

- (void) sliderDidSlide:(JWSliderView *)slideView;

@end
