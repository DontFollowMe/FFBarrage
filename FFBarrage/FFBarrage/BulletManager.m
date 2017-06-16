//
//  BulletManager.m
//  FFBarrage
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletManager.h"
#import "BulleView.h"

@interface BulletManager ()

@property (nonatomic, strong) NSMutableArray<BulletModel *> * bulletComments;      //过程中的数据
@property (nonatomic, strong) NSMutableArray * bulletViews;         //存储弹幕view
@property (nonatomic, assign) BOOL bStopAnimation;

@end

@implementation BulletManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
        self.trackNumber = self.trackNumber ? self.trackNumber : 3;
    }
    
    return self;
}

//随机分配弹道
- (void)initBulletComment
{
    NSMutableArray * trajectorys = [NSMutableArray array];
    for (int i = 0; i < self.trackNumber; i ++) {
        [trajectorys addObject:@(i)];
    }
    for (int i = 0; i < trajectorys.count; i ++) {
        if (self.bulletComments.count > 0) {
            //通过随机送获取弹幕轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕中逐一取出弹幕数据
            BulletModel * param = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            [self createBulletView:param trajectory:trajectory];
        }
    }
}

//创建弹幕view
- (void)createBulletView:(BulletModel *)param trajectory:(int)trajectory
{
    if (self.bStopAnimation) return;
    BulleView * bulleView = [[BulleView alloc] initWithParam:param];
    bulleView.trajectory = trajectory;
    [self.bulletViews addObject:bulleView];
    __weak typeof (bulleView) weakView = bulleView;
    __weak typeof (self) weakSelf = self;
    bulleView.moveStatusBlock = ^(MoveStatus status) {
        if (self.bStopAnimation) return;
        switch (status) {
            case MoveStatusStart:
                //弹幕开始进入屏幕
                [weakSelf.bulletViews addObject:weakView];
                break;
            case MoveStatusEnter:
            {
                //弹幕完全进入屏幕, 判断是否还有其他内容, 如果有, 在该轨道再创建一个弹幕
                BulletModel * param = [weakSelf nextComment];
                if (param) {
                    [weakSelf createBulletView:param  trajectory:trajectory];
                }
            }
                break;
            case MoveStatusEnd:
                //移除并是个资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if (weakSelf.bulletViews.count == 0) {
                    //已经没有弹幕, 开始循环
                    weakSelf.bStopAnimation = YES;
                    [weakSelf start];
                }
                break;
        }
    };
    if (self.geenerateViewBlock) {
        self.geenerateViewBlock(bulleView);
    }
}

//从数据源中取下一条弹幕
- (BulletModel *)nextComment
{
    if (self.bulletComments.count == 0) return nil;
    BulletModel * param = [self.bulletComments firstObject];
    if (param) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return param;
}

- (void)start
{
    if (!self.bStopAnimation) return;
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}

- (void)stop
{
    if (self.bStopAnimation) return;
    self.bStopAnimation = YES;
    //    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        BulleView * bulleView = obj;
    //        [bulleView stopAnimation];
    //        bulleView = nil;
    //    }];
    //    [self.bulletViews removeAllObjects];
}

#pragma mark ---- lazy
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)bulletComments
{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
