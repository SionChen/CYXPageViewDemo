//
//  CYXPageButton.m
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "CYXPageButton.h"
#import "UIView+Size.h"

@implementation CYXPageButton

{
    UIImageView * arrowImageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"categoryDown"];
        [self addSubview:arrowImageView];
    }
    
    return self;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //CGAffineTransform transform = CGAffineTransformRotate(arrowImageView.transform,selected?M_PI:-M_PI);
    CGAffineTransform transform = CGAffineTransformMakeRotation(selected?M_PI:0.000001 - M_PI);
    //动画开始
    
    [UIView beginAnimations:@"rotate" context:nil ];
    
    //动画时常
    
    [UIView setAnimationDuration:0.5];
    
    //添加代理
    [UIView setAnimationDelegate:self];
    
    //获取transform的值
    
    [arrowImageView setTransform:transform];
    
    //关闭动画
    
    [UIView commitAnimations];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    arrowImageView.transform = CGAffineTransformIdentity;
    arrowImageView.image =  [UIImage imageNamed:self.selected?@"categoryUp":@"categoryDown"];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    arrowImageView.size = arrowImageView.image.size;
    arrowImageView.centerY = self.height/2;
    arrowImageView.centerX = self.width/2;
}

@end
