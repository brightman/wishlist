//
//  MyWishListC.h
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPGestureTableViewCell.h"
@interface MyWishListC : UIViewController<UITableViewDataSource,UITableViewDelegate,TPGestureTableViewCellDelegate,UserASIDelegate,UITextFieldDelegate>
@property(nonatomic,retain) NSDate *countdownDate;
@property(nonatomic,retain) UILabel *countdownLabel;
@end
