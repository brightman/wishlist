//
//  UIButton+Block.h
//  QPOS
//
//  Created by YoungShook on 13-4-12.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

typedef void (^ActionBlock)();

@interface UIButton (Block)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)callActionBlock:(id)sender;

@end