//
//  QYViewController.m
//  SliderDemo
//
//  Created by jiwei on 15/1/28.
//  Copyright (c) 2015年 weiji.info. All rights reserved.
//

#import "QYViewController.h"
#import "JWSliderView.h"

@interface QYViewController ()<JWSliderViewDelegate>

@end

@implementation QYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //横向滑块
    JWSliderView *slider = [[JWSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    slider.center = self.view.center;
    slider.delegate = self;
    [self.view addSubview:slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JWSlider delegate

- (void)sliderDidSlide:(JWSliderView *)slideView{
    NSLog(@"%d", slideView.selected);
}

@end
