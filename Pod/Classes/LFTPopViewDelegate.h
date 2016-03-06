//
//  LFTPopViewDelegate.h
//  LFTPopView
//
//  Created by Theodore Felix Leo on 03/07/2016.
//  Copyright (c) 2016 Theodore Felix Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFTPopView;

@protocol LFTPopViewDelegate <NSObject>

@optional

- (void)popViewDidShow:(LFTPopView *)popView;
- (void)popViewDidDismiss:(LFTPopView *)popView;

@end
