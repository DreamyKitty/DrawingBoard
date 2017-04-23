//
//  UIImage+SHCut.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "UIImage+SHCut.h"

@implementation UIImage (SHCut)

+(UIImage *)sh_cutImage:(UIImage *)toCutImage withOneClosePath:(UIBezierPath *)path pathScale:(CGFloat)pathScale
{
    CGImageRef oldImageRef = CGImageRetain(toCutImage.CGImage);
    
    size_t contextWidth = CGImageGetWidth(oldImageRef);
    size_t contextHeight = CGImageGetHeight(oldImageRef);

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contextWidth,contextHeight),NO,1);
    CGContextRef context =CGContextRetain(UIGraphicsGetCurrentContext());
    
    //context的剪裁
    UIBezierPath * copyPath = [path copy];
    [copyPath applyTransform:CGAffineTransformMakeScale(pathScale, pathScale)];
    CGPathRef cgPath = CGPathRetain(copyPath.CGPath);
    CGContextAddPath(context, cgPath);
    CGPathRelease(cgPath);
    CGContextClosePath(context);
    CGContextClip(context);
    
    //坐标系转换。因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(context, 0, contextHeight);
    CGContextScaleCTM(context, 1, -1);
    //图片以倒置的方式绘制到已经剪裁好的context上去
    CGContextDrawImage(context, CGRectMake(0, 0, contextWidth, contextHeight),oldImageRef);
    
    //结束绘画
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    
    //裁图。只保留有图片内容的最小矩形部分，其他空白处剪裁掉。
    CGImageRef imageRef = CGImageRetain(tempImage.CGImage);
    CGRect turnRect = CGRectMake(copyPath.bounds.origin.x*(CGImageGetWidth(imageRef)/tempImage.size.width), copyPath.bounds.origin.y*(CGImageGetHeight(imageRef)/tempImage.size.height),copyPath.bounds.size.width* (CGImageGetWidth(imageRef)/tempImage.size.width),copyPath.bounds.size.height*(CGImageGetHeight(imageRef)/tempImage.size.height));
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, turnRect);
    CGImageRelease(imageRef);
    
    UIImage * resultImage = [[UIImage alloc]initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    return resultImage;
}

+(UIImage *)sh_eraseImage:(UIImage *)eraseImage withPathArray:(NSArray<UIBezierPath *> *)pathArray pathScale:(CGFloat)pathScale
{
    CGImageRef oldImageRef = CGImageRetain(eraseImage.CGImage);
    
    CGFloat eraseImageCGWidth = CGImageGetWidth(oldImageRef);
    CGFloat eraseImageCGHeight = CGImageGetHeight(oldImageRef);

    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(eraseImageCGWidth, eraseImageCGHeight),NO,1);
    
    CGContextRef context = CGContextRetain(UIGraphicsGetCurrentContext());
    
    //context坐标系上下翻转
    CGContextTranslateCTM(context, 0, eraseImageCGHeight);
    CGContextScaleCTM(context, 1, -1);

    //将倒置图以倒置方向绘画上去。
    CGContextDrawImage(context, CGRectMake(0, 0, eraseImageCGWidth, eraseImageCGHeight), oldImageRef);
    CGImageRelease(oldImageRef);
    
    //context坐标系再次上下翻转
    CGContextTranslateCTM(context, 0, eraseImageCGHeight);
    CGContextScaleCTM(context, 1, -1);
    for (NSUInteger i = 0; i<pathArray.count; i++) {
        UIBezierPath * path = [pathArray objectAtIndex:i];
        //因为下面到对path进行缩放，所以为了不改变原对象，因此要copy一个对象。
        UIBezierPath * copyPath =[path copy];
        [copyPath applyTransform:CGAffineTransformMakeScale(pathScale, pathScale)];
        CGContextSetLineWidth(context,copyPath.lineWidth*pathScale);
        CGContextSetLineCap(context, copyPath.lineCapStyle);
        CGPathRef cgPath = CGPathRetain(copyPath.CGPath);
        CGContextAddPath(context, cgPath);
        CGPathRelease(cgPath);
        //设置blend模式kCGBlendModeClear并绘制上clearColor，则被绘制路径则为透明。
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGColorRef clearColorRef = CGColorRetain([UIColor clearColor].CGColor) ;
        CGContextSetStrokeColorWithColor(context, clearColorRef);
        CGColorRelease(clearColorRef);
        CGContextStrokePath(context);
    }
    CGContextRelease(context);
    
    //结束绘画
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


@end
