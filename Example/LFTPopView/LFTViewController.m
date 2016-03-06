//
//  LFTViewController.m
//  LFTPopView
//
//  Created by Theodore Felix Leo on 03/07/2016.
//  Copyright (c) 2016 Theodore Felix Leo. All rights reserved.
//

#import "LFTViewController.h"
#import <LFTPopView/LFTPopView.h>
#import <PureLayout/PureLayout.h>

@interface LFTViewController () <LFTPopViewDelegate>

@property (strong, nonatomic) LFTPopView *popView;

@end

@implementation LFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    [super loadView];
    
    UIButton *button1 = [self buttonWithTitle:@"Pop Corner" action:@selector(didTapShow:)];
    button1.tag = 1;
    UIButton *button2 = [self buttonWithTitle:@"Pop Above" action:@selector(didTapShow:)];
    button2.tag = 2;
    UIButton *button3 = [self buttonWithTitle:@"Pop Below" action:@selector(didTapShow:)];
    button3.tag = 3;
    UIButton *button4 = [self buttonWithTitle:@"Pop" action:@selector(didTapShow:)];
    button4.tag = 4;
    UIButton *button5 = [self buttonWithTitle:@"Pop" action:@selector(didTapShow:)];
    button5.tag = 5;
    UIButton *button6 = [self buttonWithTitle:@"Pop Corner" action:@selector(didTapShow:)];
    button6.tag = 6;
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
    
    [button1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [button1 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10];
    [button2 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [button2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:80];
    [button3 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:-80];
    [button3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:button2];
    [button4 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button4 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [button5 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button5 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
    [button6 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [button6 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.16 green:0.50 blue:0.73 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.20 green:0.60 blue:0.86 alpha:1.0] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (LFTPopView *)popView {
    if (!_popView) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Example";
        
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        subtitleLabel.font = [UIFont systemFontOfSize:14];
        subtitleLabel.textColor = [UIColor whiteColor];
        subtitleLabel.textAlignment = NSTextAlignmentJustified;
        subtitleLabel.numberOfLines = 0;
        subtitleLabel.preferredMaxLayoutWidth = 200;
        subtitleLabel.text = @"It pops!. To dismiss, click the button below";
        
        UIButton *dismissButton = [[UIButton alloc] init];
        dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
        dismissButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor colorWithRed:0.74 green:0.76 blue:0.78 alpha:1.0] forState:UIControlStateHighlighted];
        [dismissButton addTarget:self action:@selector(didTapDismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *contentView = [[UIView alloc] init];
        [contentView addSubview:titleLabel];
        [contentView addSubview:subtitleLabel];
        [contentView addSubview:dismissButton];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:10];
        [subtitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
        [subtitleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10];
        [dismissButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:subtitleLabel withOffset:10];
        [dismissButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [dismissButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        
        CGSize contentViewSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        contentView.frame = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);
        
        _popView = [[LFTPopView alloc] initWithContentView:contentView];
        _popView.color = [UIColor colorWithRed:0.09 green:0.63 blue:0.52 alpha:1.0];
        _popView.delegate = self;
    }
    return _popView;
}

- (void)didTapShow:(UIButton *)button {
    if (button.tag == 2) {
        self.popView.preferredTipDirection = LFTPopViewTipDirectionDown;
    } else if (button.tag == 3) {
        self.popView.preferredTipDirection = LFTPopViewTipDirectionUp;
    } else {
        self.popView.preferredTipDirection = LFTPopViewTipDirectionAutomatic;
    }
    [self.popView popAtPoint:button.center];
}

- (void)didTapDismiss:(UIButton *)button {
    [self.popView dismiss];
}

#pragma mark - LFTPopViewDelegate

- (void)popViewDidDismiss:(LFTPopView *)popView {
    NSLog(@"Pop view dismiss");
}

- (void)popViewDidShow:(LFTPopView *)popView {
    NSLog(@"Pop view shown");
}

@end
