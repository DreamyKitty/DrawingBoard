//
//  SHMaskView.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "SHMaskView.h"

@implementation SHMaskView

-(void)setPathModelArray:(NSArray<SHPathModel *> *)pathModelArray
{
    _pathModelArray = pathModelArray;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context =CGContextRetain(UIGraphicsGetCurrentContext());
    CGContextSaveGState(context);
    {
        for (NSUInteger i = 0; i<_pathModelArray.count; i++) {
            SHPathModel * pathModel = [_pathModelArray objectAtIndex:i];
            CGContextSetLineWidth(context, pathModel.path.lineWidth);
            
            CGColorRef clearColorRef = CGColorRetain([UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context,clearColorRef);
            CGColorRelease(clearColorRef);
            
            CGContextSetLineCap(context, pathModel.path.lineCapStyle);
            
            CGPathRef pathRef = CGPathRetain(pathModel.path.CGPath);
            CGContextAddPath(context, pathRef);
            CGPathRelease(pathRef);
            
            CGContextSetBlendMode(context, kCGBlendModeClear);
            if (pathModel.isClosePath) {
                CGContextSetFillColorWithColor(context,CGColorRetain(clearColorRef));
                CGColorRelease(clearColorRef);
                
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else{
                CGContextStrokePath(context);
            }
        }
    }
    CGContextRestoreGState(context);
    CGContextRelease(context);
}

@end
