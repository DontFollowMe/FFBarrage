//
//  BulleView.m
//  FFBarrage
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import "BulleView.h"
#import <UIImageView+WebCache.h>

#define RGB(colorRgb,__a)  [UIColor colorWithRed:((colorRgb & 0xFF0000) >> 16)/255.0 green:((colorRgb & 0xFF00) >> 8)/255.0 blue:((colorRgb & 0xFF)/255.0) alpha:__a]
#define SFONT(X)         [UIFont systemFontOfSize:X]

@interface BulleView ()

@property (nonatomic, strong) UIImageView * commentView;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * headUrl;
@property (nonatomic, assign) NSInteger groupType;

@end

@implementation BulleView
- (instancetype)initWithParam:(BulletModel *)param
{
    self = [super init];
    if (self) {
        self.comment = param.content;
        self.headUrl = [NSString stringWithFormat:@"%@", param.headerURL];
        [self addSubview:self.commentView];
        self.bounds = self.commentView.bounds;
    }
    
    return self;
}

- (CGSize)sizeOfTextFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize spacing:(CGFloat)spacing text:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName: paragraphStyle};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark ---- start 开始动画
- (void)startAnimation
{
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat duration = 8.0f;
    CGFloat wholeWidth = screenW + CGRectGetWidth(self.bounds);
    
    if (self.moveStatusBlock) {
        self.moveStatusBlock(MoveStatusStart);
    }
    
    //控制速度
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration animations:^{
        if (_direction == BulletDirectionR2L) {
            frame.origin.x -= wholeWidth;
        } else {
            frame.origin.x += wholeWidth;
        }
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(MoveStatusEnd);
        }
    }];
}

#pragma mark ---- stop 结束动画
- (void)stopAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//停止
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(MoveStatusEnter );
    }
}

#pragma mark ---- setter
- (void)setDirection:(BulletDirection)direction
{
    _direction = direction;
}

- (NSString *)cutText
{
    if (self.comment.length <= 12) {
        return self.comment;
    }
    NSString * tempStr = [self.comment substringToIndex:12];
    
    return tempStr;
}

#pragma mark ---- lazy 懒加载
/* 弹幕UI */
- (UIView *)commentView
{
    if (!_commentView) {
        _commentView.userInteractionEnabled = YES;
        CGFloat labelW = [self sizeOfTextFontSize:14
                                          maxSize:CGSizeMake(CGFLOAT_MAX, 30)
                                          spacing:0
                                             text:[self cutText]].width;
        _commentView = [[UIImageView alloc] init];
        _commentView.frame = CGRectMake(0, 0, labelW + 55, 42);
        UIImageView * headImageView = [[UIImageView alloc] init];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl]];
        [headImageView.layer setCornerRadius:15];
        [headImageView.layer setMasksToBounds:YES];
        headImageView.frame = CGRectMake(7, 6, 30, 30);
        [_commentView addSubview:headImageView];
        
        UILabel * label = [[UILabel alloc]init];
        label.text = self.comment;
        label.font = SFONT(12);
        [_commentView addSubview:label];
        CGFloat labelX = CGRectGetMaxX(headImageView.frame) + 7;
        label.frame = CGRectMake(labelX, 6, labelW, 30);
        
        //        if (self.groupType == 2) {
        //            _commentView.image = [UIImage imageNamed:@"blue_bg_normal"];
        label.textColor = RGB(0x0e6ac7, 1);
        //        } else {
        _commentView.image = [UIImage imageNamed:@"red_bg_normal"];
        label.textColor = RGB(0xe8110f, 1);
        //        }
    }
    
    return _commentView;
}

@end
