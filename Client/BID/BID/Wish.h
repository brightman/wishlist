//
//  Wish.h
//  BID
//
//  Created by YoungShook on 13-7-7.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wish : NSObject

@property(nonatomic,retain)NSNumber *ID;  //wish唯一ID
@property(nonatomic,retain)NSString *title; //wish名称
@property(nonatomic,retain)NSNumber *cost;  //成本
@property(nonatomic,retain)NSString *createdTime; //创建时间
@property(nonatomic,retain)NSNumber *supportCount; //被赞的数量
@property(nonatomic,retain)NSNumber *sameCount; //共有的数量
@property(nonatomic,assign)BOOL isDone;  //是否完成

@end
