//
//  ViewController.m
//  FFBarrage
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulleView.h"
#import "BulletModel.h"

#define MAIN_SCREEN_BOUNDS  [[UIScreen mainScreen] bounds]
#define MAIN_SCREEN_WIDTH   MAIN_SCREEN_BOUNDS.size.width
#define MAIN_SCREEN_HEIGHT  MAIN_SCREEN_BOUNDS.size.height

@interface ViewController ()

@property (nonatomic, strong) BulletManager * leftManager;
@property (nonatomic, strong) BulletManager * rightManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BulletModel * model1 = [[BulletModel alloc] init];
    model1.headerURL = @"http://ww2.sinaimg.cn/mw690/7d696162jw8fbnq2y548dj20yi0yidh5.jpg";
    model1.content = @"这是一条弹幕啊啊啊啊啊";
    BulletModel * model2 = [[BulletModel alloc] init];
    model2.content = @"就是弹幕";
    model2.headerURL = @"http://ww4.sinaimg.cn/mw690/7d696162jw8fayeo83657j205a05amx4.jpg";
    BulletModel * model3 = [[BulletModel alloc] init];
    model3.content = @"11111111111111111";
    model3.headerURL = @"http://ww3.sinaimg.cn/mw690/7d696162jw8f87cjsvpqhj20ig0igjs6.jpg";
    self.leftManager.dataSource = [NSMutableArray arrayWithArray:@[model1, model2, model3]];
    self.rightManager.dataSource = [NSMutableArray arrayWithArray:@[model3, model2, model1]];
    [self startManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- 开始/结束 弹幕
- (void)start
{
    [self startManager];
}

- (void)startManager
{
    [self.leftManager start];
    [self.rightManager start];
    NSLog(@"弹幕开始飞呀飞~~~~~~~~~~");
}

- (void)stop
{
    [_leftManager stop];
    [_rightManager stop];
}

#pragma mark -------------------- 弹幕 --------------------
- (void)addBulletView:(BulleView * )bulleView direction:(BulletDirection)direction
{
    bulleView.direction = direction;
    [self.view addSubview:bulleView];
    [bulleView startAnimation];
}

#pragma mark ---- lazy 懒加载
#warning 弹幕方向不同, view frame 的 X 坐标不同 !
- (BulletManager *)leftManager
{
    if (!_leftManager) {
        _leftManager = [[BulletManager alloc] init];
        _leftManager.trackNumber = 1;
        //        NSDictionary * dic = @{@"comment" : @"弹幕1~~~~~~~~~~",
        //                               @"headUrl" : @"http://ww3.sinaimg.cn/mw1024/7d696162jw1f9kpjmn58oj20qo0qoafv.jpg",
        //                               @"groupType" : @(1)};
        __weak typeof (self) weakself = self;
        _leftManager.geenerateViewBlock = ^(BulleView * bulleView) {
            bulleView.frame = CGRectMake(-CGRectGetWidth(bulleView.bounds), 10, CGRectGetWidth(bulleView.bounds), CGRectGetHeight(bulleView.bounds));
            [weakself addBulletView:bulleView direction:BulletDirectionL2R];
        };
    }
    return _leftManager;
}

- (BulletManager *)rightManager
{
    if (!_rightManager) {
        _rightManager = [[BulletManager alloc] init];
        _rightManager.trackNumber = 1;
        __weak typeof (self) weakself = self;
        _rightManager.geenerateViewBlock = ^(BulleView * bulleView) {
            bulleView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 100, CGRectGetWidth(bulleView.bounds), CGRectGetHeight(bulleView.bounds));
            [weakself addBulletView:bulleView direction:BulletDirectionR2L];
        };
    }
    return _rightManager;
}

#pragma mark ---- 返回弹幕高度
/*
- (CGFloat)bulleViewY:(BulletDirection)direction
{
    int trajectory = direction == BulletDirectionR2L ? 1 : 0;
    CGRect firstImageF = [self.frames.picFrames firstObject].CGRectValue;
    CGFloat firstY = firstImageF.origin.y;
    NSInteger count = _model.resource.count;
    if (_model.topicType == TopicTypeAndVideo) {
        firstY = _frames.videoViewF.origin.y;
        count = 4;
    }
    if (count == 1) {
        CGFloat defH = ((ContentW - 8) / 3) + kSprayCellPaddingPic;
        count = (_frames.imageSize.width / defH) * 3;
    }
    if (count == 2 || count == 3) {
        return firstY + 60 * trajectory;
    } else if (count > 3 && count <= 6) {
        return firstY + 100 * trajectory + 20;
    } else if (count == 0) {
        [_leftManager stop];
        [_rightManager stop];
        return 0;
    } else {
        return firstY + 100 * trajectory + 50;
    }
    
}*/


@end
