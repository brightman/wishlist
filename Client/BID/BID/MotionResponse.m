//
//  MotionResponse.m
//  BID
//
//  Created by YoungShook on 13-7-17.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "MotionResponse.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation MotionResponse

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceShaken" object:self];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
