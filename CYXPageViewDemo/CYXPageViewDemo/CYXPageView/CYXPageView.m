//
//  CYXPageView.m
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "CYXPageView.h"
#import "UIView+Size.h"
#import "CYXTopicCollectionViewCell.h"
#import "CYXPageCollectionViewCell.h"

#define Show_Time     0.2
@implementation CYXPageView{
    NSInteger _selectIndex;
    CYXPageShadowView * _pageShadowView;
}
-(void)dealloc
{
    [_pageShadowView removeFromSuperview];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _selectIndex = 0;
        self.isTouchScroll = NO;
        self.topicHeight = 44;
        [self addSubview:self.topicCollectionView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectButton];
        [self.topicCollectionView addSubview:self.selectLine];
        [self addSubview:self.pageCollectionView];
        _pageShadowView = [[CYXPageShadowView alloc] init];
        _pageShadowView.delegate = self;
    }
    return self;
}
-(void)setTitleList:(NSArray *)titleList
{
    if (_titleList!=titleList) {
        _titleList = titleList;
        _pageShadowView.titleList =titleList;
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.topicCollectionView.frame = CGRectMake(0, 0, self.width-50, self.topicHeight);
    self.selectButton.frame = CGRectMake(0, 0, 50, self.topicHeight);
    self.selectButton.right = self.width;
    self.titleLabel.frame = CGRectMake(0, 0, self.width, self.topicHeight);
    self.pageCollectionView.frame = CGRectMake(0, self.topicCollectionView.bottom, self.width, self.height-self.topicCollectionView.height);
    [self.topicCollectionView reloadData];
    [self.pageCollectionView reloadData];
    if (_selectIndex<[self.titleList count]) {
        [self selectIndex:[NSIndexPath indexPathForRow:_selectIndex inSection:0] topicCollectionView:self.topicCollectionView withAnimation:NO];
    }
}

#pragma mark Method
-(void)selectButtonAction:(CYXPageButton *)btn
{
    btn.selected = !btn.selected;
    self.titleLabel.hidden = NO;
    self.titleLabel.alpha = !btn.selected;
    [UIView animateWithDuration:Show_Time animations:^{
        self.titleLabel.alpha = btn.selected;
    } completion:^(BOOL finished) {
        self.titleLabel.hidden = !btn.selected;
    }];
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    
    _pageShadowView.selectIndex = _selectIndex;
    btn.selected?[_pageShadowView showItemListViewWithTop:[self convertRect:self.bounds toView:rootView].origin.y+self.topicHeight]:[_pageShadowView dissmissListView];
}
/**
 手动设置两个collectionview的偏移量
 
 @param indexPath indexpath
 @param collectionView topicCollectionView
 @param animation 是否有动画
 */
-(void)selectIndex:(NSIndexPath *)indexPath topicCollectionView:(UICollectionView *)collectionView withAnimation:(BOOL)animation
{
    self.isTouchScroll = NO;
    if (_selectIndex!=indexPath.row) {//这是点击topic
        [self collectionView:self.topicCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        _selectIndex = indexPath.row;
        //[self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    [self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animation];
    //设置选中偏移量
    CGFloat itemCenterX = [self getCenterXWithRow:indexPath.row];
    CGFloat aimContentOffSetX = itemCenterX - collectionView.width/2-50;
    aimContentOffSetX = (aimContentOffSetX<0?0:aimContentOffSetX);
    if (collectionView.contentSize.width-collectionView.width>0) {
        aimContentOffSetX = ((aimContentOffSetX>collectionView.contentSize.width-collectionView.width)?(collectionView.contentSize.width-collectionView.width):aimContentOffSetX);
    }
    if (animation) {
        [UIView animateWithDuration:Show_Time animations:^{
            [collectionView setContentOffset:CGPointMake(aimContentOffSetX, 0)];
        }];
    }else{
        [collectionView setContentOffset:CGPointMake(aimContentOffSetX, 0)];
    }
    
    //设置底部红线
    CGSize size = [self collectionView:self.topicCollectionView layout:self.topicFlowLayout sizeForItemAtIndexPath:indexPath];
    if (animation) {
        [UIView animateWithDuration:Show_Time animations:^{
            self.selectLine.size = CGSizeMake(size.width, 2);
            self.selectLine.centerX = itemCenterX;
        } completion:^(BOOL finished) {
            CYXTopicCollectionViewCell *cell = (CYXTopicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.selected = YES;
        }];
    }else{
        self.selectLine.size = CGSizeMake(size.width, 2);
        self.selectLine.centerX = itemCenterX;
        CYXTopicCollectionViewCell *cell = (CYXTopicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selected = YES;
    }
    self.selectLine.bottom = self.topicCollectionView.height;
    
    [self.topicCollectionView reloadData];//刷新选择状态
}
#pragma mark CYXPageShadowViewDelegate
-(void)didDismiss
{
    self.selectButton.selected = NO;
    self.titleLabel.hidden = NO;
    self.titleLabel.alpha = !self.selectButton.selected;
    [UIView animateWithDuration:Show_Time animations:^{
        self.titleLabel.alpha = self.selectButton.selected;
    } completion:^(BOOL finished) {
        self.titleLabel.hidden = !self.selectButton.selected;
    }];
}
-(void)didSelectIndex:(NSInteger)index
{
    if (_selectIndex!=index) {
        [self collectionView:self.topicCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        [self collectionView:self.topicCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
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
    if (collectionView == self.topicCollectionView) {
        NSString * keyWords = self.titleList[indexPath.row];
        CGSize size = [keyWords sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        CGFloat itemWidth = size.width+10*2;
        CGFloat itemHeight = collectionView.height;
        return CGSizeMake(itemWidth, itemHeight);
    }
    if (collectionView==self.pageCollectionView) {
        return collectionView.size;
    }
    return CGSizeZero;
}

// 返回某个indexPath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.topicCollectionView) {
        CYXTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXTopicCollectionViewCell class]) forIndexPath:indexPath];
        cell.text = self.titleList[indexPath.row];
        cell.selected = indexPath.row==_selectIndex;
        return cell;
    }
    if (collectionView==self.pageCollectionView) {
        CYXPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYXPageCollectionViewCell class]) forIndexPath:indexPath];
        cell.backgroundColor = indexPath.row%2==0?[UIColor redColor]:[UIColor yellowColor];
        return cell;
    }
    return nil;
}

// 当指定indexPath处的item被选择时触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.topicCollectionView) {
        [self selectIndex:indexPath topicCollectionView:collectionView withAnimation:YES];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.topicCollectionView) {
        CYXTopicCollectionViewCell *cell = (CYXTopicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selected = NO;
    }
    
}
-(CGFloat)getCenterXWithRow:(NSInteger)row
{
    if (row<0) {row=0;}
    if (row>=[self.titleList count]) {row = [self.titleList count]-1;}
    UICollectionViewLayoutAttributes * att = [self.topicCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return att.center.x;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageCollectionView&&self.isTouchScroll) {
        NSInteger aimIndex = (int)scrollView.contentOffset.x/scrollView.width;
        _selectIndex = aimIndex;
        //设置选中偏移量
        CGFloat itemCenterX = [self getCenterXWithRow:_selectIndex];
        CGFloat aimContentOffSetX = itemCenterX - self.topicCollectionView.width/2-50;
        aimContentOffSetX = ((aimContentOffSetX>self.topicCollectionView.contentSize.width-self.topicCollectionView.width)?(self.topicCollectionView.contentSize.width-self.topicCollectionView.width):aimContentOffSetX);
        aimContentOffSetX = (aimContentOffSetX<0?0:aimContentOffSetX);
        [UIView animateWithDuration:Show_Time animations:^{
            [self.topicCollectionView setContentOffset:CGPointMake(aimContentOffSetX, 0)];
            //self.viewControler.title = bar.name;
        } completion:^(BOOL finished) {
            CYXTopicCollectionViewCell *cell = (CYXTopicCollectionViewCell *)[self.topicCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
            cell.selected = YES;
        }];
        
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isTouchScroll = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.pageCollectionView&&self.isTouchScroll) {
        NSInteger index = (int)scrollView.contentOffset.x/scrollView.width;
        if (index==[self.titleList count]-1) {
            index--;
        }
        CYXTopicCollectionViewCell *indexcell = (CYXTopicCollectionViewCell *)[self.topicCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        CGFloat indexCenterX = [self getCenterXWithRow:index];
        //CGFloat indexCenterX = indexcell.centerX;
        NSInteger aimIndex = index+1;
        CYXTopicCollectionViewCell *aimcell = (CYXTopicCollectionViewCell *)[self.topicCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:aimIndex inSection:0]];
        CGFloat aimIndexCenterX = [self getCenterXWithRow:aimIndex];
        //CGFloat aimIndexCenterX = aimcell.centerX;
        CGFloat scale = ABS(index*scrollView.width-scrollView.contentOffset.x)/scrollView.width;
        _selectLine.centerX = indexCenterX+(aimIndexCenterX - indexCenterX)*scale;//设置位移
        CGSize indexSize = [self collectionView:self.topicCollectionView layout:self.topicFlowLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        CGSize aimIndexSize = [self collectionView:self.topicCollectionView layout:self.topicFlowLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:aimIndex inSection:0]];
        _selectLine.width = (indexSize.width)+(aimIndexSize.width-indexSize.width)*scale;//设置宽度
        if (scale>0.5) {
            [self collectionView:self.topicCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            aimcell.selected = YES;
        }else{
            [self collectionView:self.topicCollectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForRow:aimIndex inSection:0]];
            indexcell.selected = YES;
        }
        
        
    }
}
#pragma mark G
-(CYXPageButton*)selectButton{
    if(!_selectButton){
        _selectButton = [CYXPageButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return _selectButton;
}
-(UICollectionViewFlowLayout*)topicFlowLayout{
    if(!_topicFlowLayout){
        _topicFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _topicFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //设定滚动方向
        _topicFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); //设定全局的区内边距
        _topicFlowLayout.minimumInteritemSpacing = 0; //设定全局的Cell间距
        _topicFlowLayout.minimumLineSpacing = 0; //设定全局的行间距
    }
    return _topicFlowLayout;
}
-(UICollectionView*)topicCollectionView{
    if(!_topicCollectionView){
        _topicCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:self.topicFlowLayout];
        _topicCollectionView.backgroundColor = [UIColor whiteColor];
        _topicCollectionView.showsHorizontalScrollIndicator = false;
        _topicCollectionView.showsVerticalScrollIndicator = false;
        _topicCollectionView.delaysContentTouches = false;
        _topicCollectionView.scrollEnabled = true;
        _topicCollectionView.scrollsToTop = false;
        _topicCollectionView.dataSource = self;
        _topicCollectionView.delegate = self;
        [_topicCollectionView registerClass:[CYXTopicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CYXTopicCollectionViewCell class])];
    }
    return _topicCollectionView;
}
-(UICollectionViewFlowLayout*)pageFlowLayout{
    if(!_pageFlowLayout){
        _pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //设定滚动方向
        _pageFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); //设定全局的区内边距
        _pageFlowLayout.minimumInteritemSpacing = 0; //设定全局的Cell间距
        _pageFlowLayout.minimumLineSpacing = 0; //设定全局的行间距
    }
    return _pageFlowLayout;
}
-(UICollectionView*)pageCollectionView{
    if(!_pageCollectionView){
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:self.pageFlowLayout];
        _pageCollectionView.backgroundColor = [UIColor whiteColor];
        _pageCollectionView.showsHorizontalScrollIndicator = false;
        _pageCollectionView.showsVerticalScrollIndicator = true;
        _pageCollectionView.delaysContentTouches = false;
        _pageCollectionView.scrollEnabled = true;
        _pageCollectionView.scrollsToTop = false;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.bounces = NO;
        [_pageCollectionView registerClass:[CYXPageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CYXPageCollectionViewCell class])];
    }
    return _pageCollectionView;
}
-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"  全部频道";
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
-(UIView*)selectLine{
    if(!_selectLine){
        _selectLine = [[UIView alloc] init];
        _selectLine.backgroundColor = [UIColor redColor];
    }
    return _selectLine;
}

@end
