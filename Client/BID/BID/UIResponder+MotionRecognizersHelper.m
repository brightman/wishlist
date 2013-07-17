//
//  UIResponder+MotionRecognizersHelper.m
//  BID
//
//  Created by YoungShook on 13-7-17.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "UIResponder+MotionRecognizersHelper.h"

@implementation UIResponder (MotionRecognizersHelper)

//添加感应器响应
- (void)addMotionRecognizerWithAction:(SEL)action {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:action name:@"DeviceShaken" object:nil];
}

//移除当前注册的感应器
- (void)removeMotionRecognizer {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceShaken" object:nil];
}

@end
