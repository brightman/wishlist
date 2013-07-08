//
//  User.h
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//


#import "Wish.h"
@protocol UserASIDelegate <NSObject>
@optional

- (void)connection:(NSDictionary *)dic successConType:(int)type;

- (void)connection:(NSDictionary *)dic failConType:(int)type;
@end

@interface User : NSObject

@property(nonatomic,retain)NSMutableArray *_wishlist;

+ (User *)shared;

- (void)AddUser:(NSString *)name withSex:(NSString *)sex withDelegate:(id<UserASIDelegate>)delegate;

- (void)AddWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate;

//修改更新wish
- (void)UpdateWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate;

//得到用户最新的数据
- (void)WishlistwithDelegate:(id<UserASIDelegate>)delegate;

//随即得到陌生人公开的wish数据
- (void)RandWishlistwithDelegate:(id<UserASIDelegate>)delegate;

//公开wish
- (void)PubWish:(Wish*)wish withPub:(Boolean)pub withDelegate:(id<UserASIDelegate>)delegate;

//赞别人wish
- (void)SupportWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate;

//共享wish
- (void)OwnWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate;

@end
