//
//  YYPhotoGalleryView.m
//  YYPhotoGalleryView
//
//  Created by 赵天旭 on 2018/1/3.
//  Copyright © 2018年 ZTX. All rights reserved.
//

#import "YYPhotoGalleryView.h"
#import "UIView+TXView.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

@interface YYPhotoGalleryView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGRect beginRect;
@property(nonatomic,strong)UIImage *beginImage;
@property(nonatomic,strong)NSMutableArray *imageViews;
@property(nonatomic,strong)UILabel *pageLabel;
@end
@implementation YYPhotoGalleryView


+(void)showImages:(NSArray *)images beginView:(UIImageView *)view{
    [YYPhotoGalleryView showImages:images beginPage:0 beginView:view beginImage:view.image delegate:nil];
}

+(void)showImages:(NSArray *)images beginPage:(NSInteger)page beginView:(UIView *)beginView beginImage:(UIImage *)beginImage delegate:(id<YYPhotoGalleryDelegate>)delegate{
    
    CGRect beginRect=[beginView.superview convertRect:beginView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    YYPhotoGalleryView *view=[[YYPhotoGalleryView alloc]initWithFrame:beginRect];
    view.imageArray=images;
    view.currentIndex=page;
    view.scrollView.contentOffset=CGPointMake(kScreenWidth*page, 0);
    view.beginImage= beginImage;
    view.delegate=delegate;
    view.beginRect=beginRect;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    imageView.image=beginImage;
    
    [view addSubview:imageView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    CGFloat realHeight=imageView.image!=nil?kScreenWidth*(imageView.image.size.height/imageView.image.size.width):imageView.height;
    
    [UIView animateWithDuration:0.4f animations:^{
        view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        imageView.frame=CGRectMake(0, (kScreenHeight-realHeight)/2, kScreenWidth, realHeight);
    } completion:^(BOOL finished) {
        view.scrollView.hidden=NO;
        view.scrollView.leftTop=CGPointMake(0, 0);
        [imageView removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        _scrollView=[[UIScrollView alloc]initWithFrame:kScreenBounds];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.hidden=YES;
        _scrollView.showsVerticalScrollIndicator =NO;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        _imageViews=[[NSMutableArray alloc]init];
        
        _pageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _pageLabel.font=[UIFont systemFontOfSize:16.0f];
        _pageLabel.textColor=[UIColor whiteColor];
        [self addSubview:_pageLabel];
    }
    return self;
}

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray=imageArray;
    [_imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i=0; i<imageArray.count; i++) {
        
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        scrollView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight);
        scrollView.showsVerticalScrollIndicator =NO;
        scrollView.showsHorizontalScrollIndicator =NO;
        scrollView.scrollEnabled=YES;
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.0;
        scrollView.clipsToBounds = NO;
        scrollView.zoomScale=1.0;
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *zoomTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
        zoomTap.numberOfTouchesRequired=1;
        zoomTap.numberOfTapsRequired=2;
        [imageView addGestureRecognizer:zoomTap];
        
        UITapGestureRecognizer *cancelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap:)];
        cancelTap.numberOfTapsRequired=1;
        cancelTap.numberOfTouchesRequired=1;
        cancelTap.cancelsTouchesInView=YES;
        [imageView addGestureRecognizer:cancelTap];
        [cancelTap requireGestureRecognizerToFail:zoomTap];
        
        id image=_imageArray[i];
        if ([image isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:nil];
        }
        else if ([image isKindOfClass:[UIImage class]]){
            imageView.image=image;
            imageView.size=CGSizeMake(kScreenWidth, kScreenWidth*(imageView.image.size.height/imageView.image.size.width));
            imageView.center=CGPointMake(kScreenWidth/2, kScreenHeight/2);
        }
        [scrollView addSubview:imageView];
        [_scrollView addSubview:scrollView];
        [_imageViews addObject:scrollView];
        
    }
    _scrollView.contentSize=CGSizeMake(kScreenWidth*imageArray.count, kScreenHeight);
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex=currentIndex;
    _pageLabel.text=[NSString stringWithFormat:@"%zd / %zd",_currentIndex+1,_imageArray.count];
    [_pageLabel sizeToFit];
    _pageLabel.rightTop=CGPointMake(kScreenWidth-10, kScreenHeight-60);
}

#pragma mark - ScrollView 方法

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (_imageViews.count>0) {
        UIScrollView *view=_imageViews[_currentIndex];
        return view.subviews.firstObject;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        for (UIScrollView *view in _imageViews){
            if ([view isKindOfClass:[UIScrollView class]]){
                view.zoomScale=1.0;
                UIImageView *imageView=view.subviews.firstObject;
                imageView.size=CGSizeMake(kScreenWidth, kScreenHeight);
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        self.currentIndex = scrollView.contentOffset.x / kScreenWidth;
    }
}

-(void)cancelTap:(UITapGestureRecognizer *)sender{
    UIImageView *imageView=(UIImageView *)sender.view;
    UIImageView *beginView;
    if (imageView.image) {
        beginView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*(imageView.image.size.height/imageView.image.size.width))];
    }
    else{
        beginView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    beginView.center=CGPointMake(kScreenWidth/2, kScreenHeight/2);
    beginView.clipsToBounds = YES;
    beginView.image=imageView.image;
    [self addSubview:beginView];
    [_scrollView removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        beginView.frame=CGRectMake(0, 0, self.beginRect.size.width, self.beginRect.size.height);
        self.frame=self.beginRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

-(void)zoomTap:(UITapGestureRecognizer*)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(cancelTap:)
                                               object:nil];
    float newScale=[(UIScrollView*)sender.view.superview zoomScale];
    if (newScale<2) {
        newScale = newScale * 1.5;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)sender.view.superview withCenter:[sender locationInView:sender.view]];
    [(UIScrollView*)sender.view.superview zoomToRect:zoomRect animated:YES];
}

@end
