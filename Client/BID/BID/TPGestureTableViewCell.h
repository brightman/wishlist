//
//  TPGestureTableViewCell.h
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UIButton+Block.h"
//展开或滑动状态
typedef enum {
    kFeedStatusNormal = 0,
    kFeedStatusLeftExpanded,
    kFeedStatusLeftExpanding,
    kFeedStatusRightExpanded,
    kFeedStatusRightExpanding,
}kFeedStatus;

@class TPGestureTableViewCell;

@protocol TPGestureTableViewCellDelegate <NSObject>

- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell;  
- (void)cellDidReveal:(TPGestureTableViewCell *)cell;      

@end

@interface TPGestureTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,assign) id<TPGestureTableViewCellDelegate> delegate;                     
@property (nonatomic,assign) kFeedStatus currentStatus;                 
@property (nonatomic,assign) BOOL revealing;                            
@property (nonatomic,retain) Wish* itemData;
@property (nonatomic,retain) UITextField *titleTextView;
@property (nonatomic,retain) UIImageView *doneFlagView;
@end
