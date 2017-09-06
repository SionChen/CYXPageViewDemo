//
//  CYXPageView.h
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYXPageButton.h"
#import "CYXPageShadowView.h"

@interface CYXPageView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,CYXPageShadowViewDelegate>

@property (nonatomic,strong) CYXPageButton              *selectButton;//箭头按钮
@property (nonatomic,strong) UICollectionView           *topicCollectionView;//顶部滑动标题
@property (nonatomic,strong) UICollectionViewFlowLayout *topicFlowLayout;
@property (nonatomic,strong) UICollectionView           *pageCollectionView;//可滑动的页面
@property (nonatomic,strong) UICollectionViewFlowLayout *pageFlowLayout;
@property (nonatomic,strong) UILabel                    *titleLabel;//
@property (nonatomic,strong) UIView *selectLine;//红线
@property (nonatomic,assign) CGFloat topicHeight;//顶部高度默认44

@property (nonatomic,strong) NSArray *titleList;

@end
