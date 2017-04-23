//
//  SHEraseImageView.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "SHEraseImageView.h"
#import "SHDrawPathView.h"
#import "UIImage+SHCut.h"

@interface SHEraseImageView ()<SHDrawPathViewDelegate>
{
    UIImageView * _imageView;
    SHDrawPathView * _drawPathView;
}
@end


@implementation SHEraseImageView

#pragma mark - Public Methods
-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

-(BOOL)canRedo
{
    return [_drawPathView canRedo];
}

-(BOOL)canUndo
{
    return [_drawPathView canUndo];
}

-(void)undo
{
    if ([self canUndo]) {
        [_drawPathView undo];
    }
}

-(void)redo
{
    if ([self canRedo]) {
        [_drawPathView redo];
    }
}

-(void)setEraserLineCap:(CGLineCap)eraserLineCap
{
    _eraserLineCap = eraserLineCap;
    _drawPathView.lineCap = _eraserLineCap;
}

-(void)setEraserLineWidth:(CGFloat)eraserLineWidth
{
    _eraserLineWidth = eraserLineWidth;
    _drawPathView.lineWidth = _eraserLineWidth;
}

-(UIImage *)finishErase
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i<_drawPathView.pathModelArray.count; i++) {
        SHPathModel * pathModel = [_drawPathView.pathModelArray objectAtIndex:i];
        [array addObject:pathModel.path];
    }
    if (array.count>0) {
        CGImageRef imageRef = CGImageRetain(_image.CGImage);
        CGFloat scale = CGImageGetWidth(imageRef)/_imageView.frame.size.width;
        CGImageRelease(imageRef);
        return [UIImage sh_eraseImage:_image withPathArray:array pathScale:scale];
    }
    else{
        return _image;
    }
}


#pragma mark - Custom Methods
-(void)buildVar
{
    self.backgroundColor = [UIColor whiteColor];
    
}
-(void)configUI
{
    self.userInteractionEnabled = YES;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.userInteractionEnabled = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _imageView.backgroundColor = self.backgroundColor;
    [self addSubview:_imageView];
    
    _drawPathView = [[SHDrawPathView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _drawPathView.backgroundColor = [UIColor clearColor];
    _drawPathView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _drawPathView.drawAutoClosePath = NO;
    _drawPathView.storeMutablePaths = YES;
    _drawPathView.lineColor = self.backgroundColor;
    _drawPathView.delegate = self;
    [self addSubview:_drawPathView];
}
#pragma mark - SZDrawPathViewDelegate
-(void)drawPathViewShowPathChange:(SHDrawPathView *)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(erasePathChange:)]) {
        [_delegate erasePathChange:self];
    }
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

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _imageView.backgroundColor = backgroundColor;
    _drawPathView.lineColor = backgroundColor;
}

-(void)dealloc
{
    _drawPathView.delegate = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
