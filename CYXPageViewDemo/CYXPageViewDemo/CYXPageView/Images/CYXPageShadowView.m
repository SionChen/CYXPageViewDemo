//
//  CYXPageShadowView.m
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "CYXPageShadowView.h"
#import "UIView+Size.h"
#import "CYXTopicCollectionViewCell.h"
#define screenWidth      [UIScreen mainScreen].bounds.size.width
#define screenHeight     [UIScreen mainScreen].bounds.size.height
@implementation CYXPageShadowView{
    NSInteger col;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _selectIndex = -1;
        col = 3;
        [self addSubview:self.shadowView];
        [self addSubview:self.collectionView];
    }
    return self;
}
-(void)setTitleList:(NSArray *)titleList
{
    if (_titleList!=titleList) {
        _titleList = titleList;
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
// 返回collection view里区(section)的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回指定区(section)包含的数据源条目数(number of items)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titleList count];
}

// 设定指定Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (collectionView.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing * (col - 1))/col;
    CGFloat itemHeight = itemWidth * 30.0/75.0;
    return CGSizeMake(itemWidth, itemHeight);
}

// 返回某个indexPath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYXTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXTopicCollectionViewCell class]) forIndexPath:indexPath];
    cell.text = self.titleList[indexPath.row];
    cell.selected = indexPath.row==_selectIndex;
    return cell;
}

// 当指定indexPath处的item被选择时触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndex!=indexPath.row) {//这是点击topic
        [self collectionView:collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        _selectIndex = indexPath.row;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.delegate didSelectIndex:_selectIndex];
        [self dissmissListView];
        if ([self.delegate respondsToSelector:@selector(didDismiss)]) {
            [self.delegate didDismiss];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    CYXTopicCollectionViewCell *cell = (CYXTopicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark Method
-(void)showItemListViewWithTop:(CGFloat)top
{
    [self removeFromSuperview];
    
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, top, screenWidth, screenHeight-top);
    [rootView addSubview:self];
    
    CGFloat itemWidth = (self.width - self.flowLayout.sectionInset.left - self.flowLayout.sectionInset.right - self.flowLayout.minimumInteritemSpacing * (col - 1))/col;
    CGFloat itemHeight = itemWidth * 30.0/75.0;
    CGFloat viewHeight;
    NSInteger cols= [_titleList count]/3;
    if ([_titleList count]%3!=0) {
        cols+=1;
    }
    viewHeight = cols*itemHeight + 15*(cols+1);
    
    self.shadowView.frame = self.bounds;
    self.collectionView.frame = CGRectMake(0, 0, self.width, 0);
    self.shadowView.hidden = NO;
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.frame = CGRectMake(0, 0, self.width, viewHeight);
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dissmissListView
{
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.collectionView.contentSize.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.frame = CGRectMake(0, 0, self.width, 0);
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark G
-(UICollectionView*)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.showsVerticalScrollIndicator = true;
        _collectionView.delaysContentTouches = false;
        _collectionView.scrollEnabled = false;
        _collectionView.scrollsToTop = false;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CYXTopicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CYXTopicCollectionViewCell class])];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout*)flowLayout{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; //设定滚动方向
        _flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15); //设定全局的区内边距
        _flowLayout.minimumInteritemSpacing = 15; //设定全局的Cell间距
        _flowLayout.minimumLineSpacing = 15; //设定全局的行间距
    }
    return _flowLayout;
}
-(UIView*)shadowView{
    if(!_shadowView){
        _shadowView = [[UIView alloc] init];
        _shadowView.hidden = YES;
        _shadowView.userInteractionEnabled = YES;
        __weak typeof(self) _weakSelf = self;
        [_shadowView setTapActionWithBlock:^{
            [_weakSelf dissmissListView];
            if ([_weakSelf.delegate respondsToSelector:@selector(didDismiss)]) {
                [_weakSelf.delegate didDismiss];
            }
        }];
    }
    return _shadowView;
}

@end
