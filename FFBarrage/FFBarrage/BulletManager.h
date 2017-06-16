//
//  BulletManager.h
//  FFBarrage
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import "BulletModel.h"
@class  BulleView;

@interface BulletManager : NSObject

@property (nonatomic, strong) NSMutableArray<BulletModel *> * dataSource;          //弹幕的数据来源
@property (nonatomic, assign) NSInteger trackNumber;                //弹道数量
@property (nonatomic, copy) void(^geenerateViewBlock)(BulleView * bulleView);

- (void)start;
- (void)stop;

@end
