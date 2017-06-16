//
//  BulleView.h
//  FFBarrage
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletModel.h"

typedef NS_ENUM(NSUInteger, BulletDirection) {
    BulletDirectionR2L = 1,  // 右向左
    BulletDirectionL2R = 2,  // 左向右
};

typedef enum : NSUInteger {
    MoveStatusStart,
    MoveStatusEnter ,
    MoveStatusEnd,
} MoveStatus;

@interface BulleView : UIView

@property (nonatomic, assign)  NSInteger trajectory;    //弹道
@property (nonatomic, assign) BulletDirection direction;
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);   //弹幕状态回调

- (instancetype)initWithParam:(BulletModel *)param;

- (void)startAnimation;
- (void)stopAnimation;

@end
