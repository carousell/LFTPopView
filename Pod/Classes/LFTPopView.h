//
//  LFTPopView.h
//  LFTPopView
//
//  Created by Theodore Felix Leo on 03/07/2016.
//  Copyright (c) 2016 Theodore Felix Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFTPopViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LFTPopViewTipDirection) {
    LFTPopViewTipDirectionAutomatic,
    LFTPopViewTipDirectionUp,
    LFTPopViewTipDirectionDown
};

@interface LFTPopView : UIView

@property (weak, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) BOOL showsShadow;
@property (assign, nonatomic) LFTPopViewTipDirection preferredTipDirection;
@property (weak, nonatomic, nullable) id<LFTPopViewDelegate> delegate;

- (instancetype)initWithContentView:(UIView *)contentView NS_DESIGNATED_INITIALIZER;
- (void)popAtPoint:(CGPoint)point;
- (void)popAtPoint:(CGPoint)point tipOffset:(CGFloat)tipOffset;
- (void)popAtPoint:(CGPoint)point tipOffset:(CGFloat)tipOffset presentingView:(UIView *)presentingView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
