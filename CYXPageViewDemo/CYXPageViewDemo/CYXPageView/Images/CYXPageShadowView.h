//
//  CYXPageShadowView.h
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYXPageShadowViewDelegate <NSObject>

-(void)didDismiss;
-(void)didSelectIndex:(NSInteger)index;

@end
@interface CYXPageShadowView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView           *collectionView;//顶部滑动标题
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSArray *titleList;
@property (nonatomic,weak) id<CYXPageShadowViewDelegate> delegate;

-(void)showItemListViewWithTop:(CGFloat)top;
-(void)dissmissListView;
@end


