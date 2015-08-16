//
//  JWSliderView.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/17/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWSliderView.h"

#define kSliderViewSize CGSizeMake(265, 43)
#define kSliderVspace 10


@implementation JWSliderView

- (void)dealloc
{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    [self removeGestureRecognizer:self.tapPress];
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect zFrame = (CGRect){frame.origin, kSliderViewSize};
    self = [super initWithFrame:zFrame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"running_slider_bg"]];
        [self loadContent];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadContent];
    }
    return self;
}
-(void) awakeFromNib
{
    [self loadContent];
}

- (void) loadContent {
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:self.bounds];
    image.image = [UIImage imageNamed:@"running_slider_tip3"];
    image.animationImages = @[[UIImage imageNamed:@"running_slider_tip1"],
                              [UIImage imageNamed:@"running_slider_tip2"],
                              [UIImage imageNamed:@"running_slider_tip3"],
                              [UIImage imageNamed:@"running_slider_tip4"],
                              [UIImage imageNamed:@"running_slider_tip5"],
                              [UIImage imageNamed:@"running_slider_tip4"],
                              [UIImage imageNamed:@"running_slider_tip3"],
                              [UIImage imageNamed:@"running_slider_tip2"]];
    [self addSubview:image];
    image.animationDuration = 0.8f;
    image.contentMode = UIViewContentModeCenter;
    [image startAnimating];
    self.imageView = image;
    
    UIImageView *goal = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [goal setImage:[UIImage imageNamed:@"running_slider_btn_play"]];
    goal.contentMode = UIViewContentModeCenter;
    [self addSubview:goal];
    self.goalImageView = goal;
    self.goalImageName = @"running_slider_btn_play";
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGPoint ctr = slider.center;
    CGRect sliderFrame = slider.frame;
    sliderFrame.size.width -= 4; //each "edge" of the track is 2 pixels wide
    slider.frame = sliderFrame;
    slider.center = ctr;
    slider.backgroundColor = [UIColor clearColor];
    UIImage *thumbImage = [UIImage imageNamed:@"running_slider_btn_run"];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UIImage *clearImage = [self clearPixel];
    [slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    [slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.continuous = YES;
    slider.value = 0.0;
    [self addSubview:slider];
    self.slider = slider;
    
    // Set the slider action methods
    [slider addTarget:self
                action:@selector(sliderUp:)
      forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self
                action:@selector(sliderUp:)
      forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self
                action:@selector(sliderDown:)
      forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self
                action:@selector(sliderChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *press = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapPress:)];
    press.numberOfTapsRequired = 2;
    [self addGestureRecognizer:press];
    self.tapPress = press;
}

-(void)tapPress:(UITapGestureRecognizer *)sender{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    self.selected = !self.selected;
    [_delegate sliderDidSlide:self];
}

//一个像素的透明图片
- (UIImage *) clearPixel {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _slider.frame = CGRectMake(kSliderVspace, 0, self.bounds.size.width - kSliderVspace * 2, self.bounds.size.height);
    self.imageView.frame = CGRectMake(kSliderVspace * 2, 0, self.bounds.size.width - kSliderVspace * 4, self.bounds.size.height);
    self.goalImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.goalImageView.bounds.size.width - kSliderVspace,
                                          (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.goalImageView.bounds)) / 2, self.goalImageView.bounds.size.width, self.goalImageView.bounds.size.height);
}

- (BOOL) enabled {
	return _slider.enabled;
}

- (void) setEnabled:(BOOL)enabled{
	_slider.enabled = enabled;
//	_imageView.enabled = enabled;
	if (enabled) {
		_slider.value = 0.0;
		_imageView.alpha = 1.0;
		_sliding = NO;
	}
    if (enabled) {
        [_imageView startAnimating];
    }else{
        [_imageView stopAnimating];
    }
}



// UISlider actions
- (void) sliderUp:(UISlider *)sender {
    
	if (_sliding) {
		_sliding = NO;
        
        if (_slider.value == 1.0) {
            self.selected = !self.selected;
            [_delegate sliderDidSlide:self];
        }
        
		self.selected = self.selected;
		[_slider setValue:0.0 animated: YES];
        self.imageView.alpha = 1.0;
        [self.imageView startAnimating];
        self.goalImageView.alpha = 1.0;
	}
}

- (void) sliderDown:(UISlider *)sender {
    
	if (!_sliding) {
		[self.imageView stopAnimating];
	}
	_sliding = YES;
}

- (void) sliderChanged:(UISlider *)sender {
	self.imageView.alpha = MAX(0.0, 1.0 - (_slider.value * 3.5));
    if(!_selected){
        if (_slider.value > 0.5) {
            if (![self.goalImageName isEqualToString:@"running_slider_btn_suspend"]) {
                [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_suspend"]];
                self.goalImageName = @"running_slider_btn_suspend";
            }
            self.goalImageView.alpha = (_slider.value - 0.5) * 2;
            NSLog(@"%f",_slider.value);
        }else{
            if (![self.goalImageName isEqualToString:@"running_slider_btn_play"]) {
                [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_play"]];
                self.goalImageName = @"running_slider_btn_play";
            }
            self.goalImageView.alpha = (0.5 - _slider.value) * 2;
        }
    }else{
        if (_slider.value <= 0.5) {
            if (![self.goalImageName isEqualToString:@"running_slider_btn_suspend"]) {
                [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_suspend"]];
                self.goalImageName = @"running_slider_btn_suspend";
            }
            self.goalImageView.alpha = (0.5 -_slider.value) * 2;
        }else{
            if (![self.goalImageName isEqualToString:@"running_slider_btn_play"]) {
                [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_play"]];
                self.goalImageName = @"running_slider_btn_play";
            }
            self.goalImageView.alpha = (_slider.value - 0.5) * 2;
        }
    }
    
}

#pragma mark - get/set

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        if (![self.goalImageName isEqualToString:@"running_slider_btn_suspend"]) {
            [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_suspend"]];
            self.goalImageName = @"running_slider_btn_suspend";
        }
    }else{
        if (![self.goalImageName isEqualToString:@"running_slider_btn_play"]) {
            [self.goalImageView setImage:[UIImage imageNamed:@"running_slider_btn_play"]];
            self.goalImageName = @"running_slider_btn_play";
        }
    }
}

@end
