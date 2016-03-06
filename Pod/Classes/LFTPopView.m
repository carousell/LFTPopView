//
//  LFTPopView.m
//  LFTPopView
//
//  Created by Theodore Felix Leo on 03/07/2016.
//  Copyright (c) 2016 Theodore Felix Leo. All rights reserved.
//

#import "LFTPopView.h"

CGFloat const LFTPopViewDefaultTipHeight = 12;
CGFloat const LFTPopViewDefaultTipOffset = 10;
CGFloat const LFTPopViewDefaultOffset = 10;
CGFloat const LFTPopViewDefaultCornerRadius = 6;

@interface LFTPopView ()

@property (weak, nonatomic) UIView *contentView;
@property (assign, nonatomic) CGFloat tipHeight;
@property (assign, nonatomic) LFTPopViewTipDirection tipDirection;
@property (assign, nonatomic) CGPoint tipPositionInFrame;

@end

@implementation LFTPopView

- (instancetype)initWithContentView:(UIView *)contentView {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
        self.tipHeight = LFTPopViewDefaultTipHeight;
        self.color = [UIColor whiteColor];
        self.showsShadow = YES;
        
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithContentView:[[UIView alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithContentView:[[UIView alloc] init]];
}

- (void)popAtPoint:(CGPoint)point {
    [self popAtPoint:point tipOffset:LFTPopViewDefaultTipOffset presentingView:[UIApplication sharedApplication].delegate.window];
}

- (void)popAtPoint:(CGPoint)point tipOffset:(CGFloat)tipOffset {
    [self popAtPoint:point tipOffset:tipOffset presentingView:[UIApplication sharedApplication].delegate.window];
}

- (void)popAtPoint:(CGPoint)point tipOffset:(CGFloat)tipOffset presentingView:(UIView *)presentingView {
    if (self.hidden == NO || self.superview != nil) return;

    CGRect boundingFrame = presentingView.frame;
    boundingFrame.origin.x += LFTPopViewDefaultOffset;
    boundingFrame.origin.y += LFTPopViewDefaultOffset;
    boundingFrame.size.width -= LFTPopViewDefaultOffset*2;
    boundingFrame.size.height -= LFTPopViewDefaultOffset*2;
    
    CGSize contentViewSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (contentViewSize.height == 0 || contentViewSize.width == 0) {
        contentViewSize = self.contentView.frame.size;
    }
    CGFloat targetWidth = MIN(contentViewSize.width, CGRectGetWidth(boundingFrame));
    CGFloat targetHeight = MIN(contentViewSize.height, CGRectGetHeight(boundingFrame));
    
    CGRect targetFrame = CGRectMake(0, 0, targetWidth, targetHeight + self.tipHeight);
    targetFrame.origin.x = point.x - targetFrame.size.width/2.0;
    
    point.x = MAX(boundingFrame.origin.x, MIN(point.x, CGRectGetMaxX(boundingFrame)));
    
    if (self.preferredTipDirection == LFTPopViewTipDirectionAutomatic) {
        if (point.y < CGRectGetMidY(boundingFrame)) {
            self.tipDirection = LFTPopViewTipDirectionUp;
        } else {
            self.tipDirection = LFTPopViewTipDirectionDown;
        }
    } else {
        self.tipDirection = self.preferredTipDirection;
    }
    
    if (self.tipDirection == LFTPopViewTipDirectionUp) {
        boundingFrame.size.height = MIN(CGRectGetMaxY(boundingFrame) - point.y, boundingFrame.size.height);
        boundingFrame.origin.y = point.y;
        targetFrame.origin.y = point.y + tipOffset;
    } else {
        boundingFrame.size.height = MIN(point.y - CGRectGetMinY(boundingFrame), boundingFrame.size.height);
        targetFrame.origin.y = point.y - targetFrame.size.height - tipOffset;
    }
    
    
    if (targetFrame.size.height > boundingFrame.size.height) {
        targetFrame.size.height = boundingFrame.size.height;
    }
    
    if (targetFrame.origin.x < boundingFrame.origin.x) {
        targetFrame.origin.x = boundingFrame.origin.x;
    } else if (CGRectGetMaxX(targetFrame) > CGRectGetMaxX(boundingFrame)) {
        targetFrame.origin.x -= CGRectGetMaxX(targetFrame) - CGRectGetMaxX(boundingFrame);
    }
    
    if (targetFrame.origin.y < boundingFrame.origin.y) {
        targetFrame.origin.y = boundingFrame.origin.y;
    } else if (CGRectGetMaxY(targetFrame) > CGRectGetMaxY(boundingFrame)) {
        targetFrame.origin.y -= CGRectGetMaxY(targetFrame) - CGRectGetMaxY(boundingFrame);
    }
    
    self.frame = targetFrame;
    if (self.tipDirection == LFTPopViewTipDirectionUp) {
        self.contentView.frame = CGRectMake(0, self.tipHeight, targetFrame.size.width, targetFrame.size.height - self.tipHeight);
        self.tipPositionInFrame = CGPointMake(point.x - self.frame.origin.x, point.y - self.frame.origin.y + tipOffset);
    } else {
        self.contentView.frame = CGRectMake(0, 0, targetFrame.size.width, targetFrame.size.height - self.tipHeight);
        self.tipPositionInFrame = CGPointMake(point.x - self.frame.origin.x, point.y - self.frame.origin.y - tipOffset);
    }
    
    self.hidden = NO;
    [presentingView addSubview:self];
    [self setNeedsDisplay];
    
    if (self.showsShadow) {
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset = CGSizeMake(0, 1);
    }
    
    CGPoint center = self.center;
    CGPoint targetCenter = [self.superview convertPoint:self.tipPositionInFrame fromView:self];
    if (self.tipDirection == LFTPopViewTipDirectionDown) {
        targetCenter.y -= LFTPopViewDefaultTipOffset;
    } else {
        targetCenter.y += LFTPopViewDefaultTipOffset;
    }
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.center = targetCenter;
    [UIView animateKeyframesWithDuration:1/6.0 delay:0 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
        self.center = center;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:1/8.0 delay:0 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(popViewDidShow:)]) {
        [self.delegate popViewDidShow:self];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    UIBezierPath *tipPath = [UIBezierPath bezierPath];
    CGPoint tipOriginInRect = self.tipPositionInFrame;
    CGFloat tipBaseMinX = tipOriginInRect.x - self.tipHeight;
    CGFloat tipBaseMaxX = tipOriginInRect.x + self.tipHeight;
    UIRectCorner roundedCorners = UIRectCornerAllCorners;
    if (tipBaseMinX < 0) {
        roundedCorners &= self.tipDirection == LFTPopViewTipDirectionUp ? ~UIRectCornerTopLeft : ~UIRectCornerBottomLeft;
        tipBaseMinX = 0;
    }
    if (tipBaseMaxX > rect.size.width) {
        roundedCorners &= self.tipDirection == LFTPopViewTipDirectionUp ? ~UIRectCornerTopRight : ~UIRectCornerBottomRight;
        tipBaseMaxX = rect.size.width;
    }
    CGFloat tipBaseY = self.tipDirection == LFTPopViewTipDirectionUp ? tipOriginInRect.y + self.tipHeight : tipOriginInRect.y - self.tipHeight;
    
    [tipPath moveToPoint:tipOriginInRect];
    [tipPath addLineToPoint:CGPointMake(tipBaseMinX, tipBaseY)];
    [tipPath addLineToPoint:CGPointMake(tipBaseMaxX, tipBaseY)];
    [tipPath closePath];
    [self.color setFill];
    [tipPath fill];
    
    CGContextRestoreGState(context);
    CGFloat originY = self.tipDirection == LFTPopViewTipDirectionUp ? rect.origin.y + self.tipHeight : rect.origin.y;
    UIBezierPath* viewBackgroundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x,
                                                                                          originY,
                                                                                          rect.size.width,
                                                                                          rect.size.height - self.tipHeight)
                                                             byRoundingCorners:roundedCorners
                                                                   cornerRadii:CGSizeMake(LFTPopViewDefaultCornerRadius, LFTPopViewDefaultCornerRadius)];
    [self.color setFill];
    [viewBackgroundPath fill];
}

- (void)dismiss {
    if (self.hidden == YES || self.superview == nil) {
        return;
    }
    
    CGPoint center = self.center;
    CGPoint targetCenter = [self.superview convertPoint:self.tipPositionInFrame fromView:self];
    if (self.tipDirection == LFTPopViewTipDirectionDown) {
        targetCenter.y -= LFTPopViewDefaultTipOffset;
    } else {
        targetCenter.y += LFTPopViewDefaultTipOffset;
    }
    
    [UIView animateKeyframesWithDuration:1/6.0 delay:0 options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:1/8.0 delay:0 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.center = targetCenter;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.center = center;
            [self removeFromSuperview];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
        [self.delegate popViewDidDismiss:self];
    }
}

@end
