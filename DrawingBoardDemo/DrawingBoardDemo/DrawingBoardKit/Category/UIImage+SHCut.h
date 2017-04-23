//
//  UIImage+SHCut.h
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SHCut)

+(UIImage *)sh_cutImage:(UIImage *)toCutImage withOneClosePath:(UIBezierPath *)path pathScale:(CGFloat)pathScale;

+(UIImage *)sh_eraseImage:(UIImage *)eraseImage withPathArray:(NSArray<UIBezierPath *>*)pathArray pathScale:(CGFloat)pathScale;


@end
