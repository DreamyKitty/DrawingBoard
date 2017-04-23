//
//  SHPathModel.h
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPathModel : NSObject<NSCopying>

//@property(nonatomic,assign)CGFloat lineWidth;
//@property(nonatomic,assign)CGLineCap lineCap;
@property(nonatomic,strong)UIColor * strokeColor;
@property(nonatomic,strong)UIBezierPath * path;

@property(nonatomic,assign,getter=isClosePath)BOOL closePath;

@property(nonatomic,strong)UIColor * fillColor;


@end
