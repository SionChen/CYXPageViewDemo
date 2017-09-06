//
//  CYXTopicCollectionViewCell.m
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "CYXTopicCollectionViewCell.h"
#import "UIView+Size.h"

@implementation CYXTopicCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =  [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.textLabel];
    }
    
    return self;
}
-(void)setText:(NSString *)text
{
    if (_text != text) {
        _text =text;
        [self setNeedsLayout];
    }
}
-(void)setSelected:(BOOL)selected
{
    self.textLabel.textColor = selected?[UIColor redColor]:[UIColor blackColor];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text = _text;
    self.textLabel.frame =CGRectMake(0, 0, self.width, self.height);
}
@end
