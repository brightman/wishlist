//
//  UIResponder+MotionRecognizersHelper.h
//  BID
//
//  Created by YoungShook on 13-7-17.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (MotionRecognizersHelper)
- (void)addMotionRecognizerWithAction:(SEL)action;
- (void)removeMotionRecognizer;
@end
