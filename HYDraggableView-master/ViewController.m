//
//  ViewController.m
//  HYDraggableView-master
//
//  Created by 黄海燕 on 16/9/29.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "UIView+HYDraggable.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UIImageView ignored user events by default, so set
    // `userInteractionEnabled` to YES for receive touch events.
    self.avaterImageView.userInteractionEnabled = YES;
    [self.avaterImageView makeDraggable];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.avaterImageView updateSnapPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
