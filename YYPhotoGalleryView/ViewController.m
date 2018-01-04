//
//  ViewController.m
//  YYPhotoGalleryView
//
//  Created by 赵天旭 on 2018/1/3.
//  Copyright © 2018年 ZTX. All rights reserved.
//

#import "ViewController.h"
#import "YYPhotoGalleryView.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *imageArray;
@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
}

- (void)initView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 350/2)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray.firstObject] placeholderImage:nil];
    _imageView.center = self.view.center;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEven:)];
    [_imageView addGestureRecognizer:tap];
}

- (void)tapEven:(UIGestureRecognizer *)tap {
    [YYPhotoGalleryView showImages:self.imageArray beginView:_imageView];
    
//    这个方法大致的意思就是，，beginPage是从第几张图片开始，beginView是从哪个view开始，beginImage是哪个view上的image开始的。只要这些都传对了，，不管从屏幕的哪个地方点击，，自动计算初始位置，动画的位置就从那个地方开始的
//    [YYPhotoGalleryView showImages:self.imageArray beginPage:indexPath.row beginView:cell.photoView beginImage:cell.photoView.image delegate:nil];
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/Iyo5hL_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/HP8Kai_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/UAny2v_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/ebxBfG_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/7FvZFq_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/l36wZ7_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/Wh9MQ7_740x350_00.jpg",
                       @"http://pic4.40017.cn/scenery/destination/2017/03/10/11/cE7WWI_740x350_00.jpg",
                       nil];
    }
    return _imageArray;
}



@end
