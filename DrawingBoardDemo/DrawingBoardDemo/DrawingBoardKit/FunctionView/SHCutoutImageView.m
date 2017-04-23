//
//  SHCutoutImageView.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "SHCutoutImageView.h"
#import "SHDrawPathView.h"
#import "SHMaskView.h"
#import "UIImage+SHCut.h"


@interface SHCutoutImageView ()
{
    UIImageView * _imageView;
    SHDrawPathView * _drawPathView;
    SHMaskView * _maskView;
    void(^_finishDrawOnePathBlock)(void);
}
@end

@implementation SHCutoutImageView
#pragma mark - Public Methods
-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

-(UIImage *)finishCutout
{
    SHPathModel * lastPathModel = [_drawPathView.pathModelArray lastObject];
    CGFloat scale = CGImageGetWidth(_image.CGImage)/self.frame.size.width;
    UIImage * resultImage = [UIImage sh_cutImage:_image withOneClosePath:lastPathModel.path pathScale:scale];
    return resultImage;
}

-(void)setMaskViewColor:(UIColor *)maskViewColor
{
    _maskViewColor = maskViewColor;
    _maskView.backgroundColor = _maskViewColor;
}

-(void)setShowMaskView:(BOOL)showMaskView
{
    _showMaskView = showMaskView;
    _maskView.hidden = !_showMaskView;
}

-(void)setDrawPathLineColor:(UIColor *)drawPathLineColor
{
    _drawPathLineColor = drawPathLineColor;
    _drawPathView.lineColor = _drawPathLineColor;
}

-(void)setDrawPathLineWidth:(CGFloat )drawPathLineWidth
{
    _drawPathLineWidth = drawPathLineWidth;
    _drawPathView.lineWidth = _drawPathLineWidth;
}

-(void)finishDrawOnePath:(void (^)(void))completion
{
    _finishDrawOnePathBlock = [completion copy];
}


#pragma mark - Custom Methods
-(void)buildVar
{
    _maskViewColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _showMaskView = YES;
    
    _drawPathLineWidth = 1;
    _drawPathLineColor = [UIColor yellowColor];
    _finishDrawOnePathBlock = nil;
}
-(void)configUI
{
    self.userInteractionEnabled = YES;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.userInteractionEnabled = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
    _maskView = [[SHMaskView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _maskView.userInteractionEnabled = NO;
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _maskView.backgroundColor = _maskViewColor;
    _maskView.hidden = !_showMaskView;
    [self addSubview:_maskView];
    
    _drawPathView = [[SHDrawPathView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _drawPathView.backgroundColor = [UIColor clearColor];
    _drawPathView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _drawPathView.drawAutoClosePath = YES;
    _drawPathView.storeMutablePaths = NO;
    _drawPathView.fillClosePathColor = nil;
    _drawPathView.lineColor = _drawPathLineColor;
    _drawPathView.lineWidth = _drawPathLineWidth;
    _drawPathView.lineCap = kCGLineCapRound;
    __weak SHDrawPathView * weakPathView = _drawPathView;
    __weak SHCutoutImageView * weakSelf = self;
    [_drawPathView didBeganDrawOnePath:^{
        __strong SHCutoutImageView * strongSelf = weakSelf;
        strongSelf->_maskView.pathModelArray = nil;
        
    }];
    [_drawPathView didFinishDrawOnePath:^(SHPathModel *pathModel) {
        __strong SHCutoutImageView * strongSelf = weakSelf;
        strongSelf->_maskView.pathModelArray = weakPathView.pathModelArray;
        if (strongSelf->_finishDrawOnePathBlock) {
            strongSelf->_finishDrawOnePathBlock();
        }
    }];
    [self addSubview:_drawPathView];
}

#pragma mark - Override Methods

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildVar];
        [self configUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildVar];
        [self configUI];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
