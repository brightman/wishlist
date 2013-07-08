//
//  UserWish.h
//  BID
//
//  Created by brightman on 13-7-5.
//  Copyright (c) 2013年 brightman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserWish : NSObject

@property(nonatomic,strong)NSDictionary *_user;
@property(nonatomic,strong)NSMutableArray *_wishlist;
@property(nonatomic,strong)NSMutableArray *_randomwishlist;

- (void) AddUser:(NSString *)name withSex:(NSString *)sex;
- (void) AddWish:(NSString *)title withCost:(NSInteger)cost uptodate:(NSDate *)uptodate;
- (void) UpdateWish:(NSString *)title withCost:(NSInteger)cost uptodate:(NSDate *)uptodate;
- (NSDictionary *) Wishlist;
- (NSDictionary *) RandWishlist;
- (BOOL)PubWish:(NSInteger)wid withPub:(Boolean)pub;
- (BOOL)SupportWish:(NSInteger)wid;
- (BOOL)OwnWish:(NSInteger)wid;
@end
