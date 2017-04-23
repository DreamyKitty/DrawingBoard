//
//  CutImageViewController.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "CutImageViewController.h"
#import "SHCutoutImageView.h"

@interface CutImageViewController ()
{
    __weak IBOutlet NSLayoutConstraint *_cutoutImageViewWidth;
    __weak IBOutlet NSLayoutConstraint *_cutoutImageViewHeight;
    UIImage * _toCutImage;
}
@property (weak, nonatomic) IBOutlet SHCutoutImageView *cutoutImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation CutImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _toCutImage = [UIImage imageNamed:@"小黄人.png"];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _cutoutImageViewWidth.constant = screenWidth;
    _cutoutImageViewHeight.constant = screenWidth * _toCutImage.size.height/_toCutImage.size.width;
    _cutoutImageView.image = _toCutImage;
    _cutoutImageView.drawPathLineWidth = 2.f;
    __weak SHCutoutImageView * weakCutoutImageView = _cutoutImageView;
    __weak CutImageViewController * weakSelf = self;
    [_cutoutImageView finishDrawOnePath:^{
        __strong CutImageViewController * strongSelf = weakSelf;
        strongSelf->_resultImageView.image =  [weakCutoutImageView finishCutout];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
