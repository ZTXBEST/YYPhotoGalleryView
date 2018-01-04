//
//  YYPhotoGalleryView.h
//  YYPhotoGalleryView
//
//  Created by 赵天旭 on 2018/1/3.
//  Copyright © 2018年 ZTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  YYPhotoGalleryDelegate <NSObject>
-(void)clickEvenInPage:(NSInteger)page;
@end

@interface YYPhotoGalleryView : UIView
@property(nonatomic,weak)id<YYPhotoGalleryDelegate>delegate;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSArray *imageArray;

+(void)showImages:(NSArray *)images beginView:(UIImageView *)view;

+(void)showImages:(NSArray *)images beginPage:(NSInteger)page beginView:(UIView *)beginView beginImage:(UIImage *)beginImage delegate:(id<YYPhotoGalleryDelegate>)delegate;

@end
