//
//  SHPathModel.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "SHPathModel.h"

@implementation SHPathModel

-(id)copyWithZone:(NSZone *)zone
{
    SHPathModel * pathModel = [[[self class]allocWithZone:zone]init];
    pathModel.closePath = _closePath;
    pathModel.strokeColor = [_strokeColor copy];
    pathModel.path = [_path copy];
    pathModel.fillColor = [_fillColor copy];
    return pathModel;
}

@end
