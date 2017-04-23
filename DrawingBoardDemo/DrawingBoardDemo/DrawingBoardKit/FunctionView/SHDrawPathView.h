//
//  SHDrawPathView.h
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHPathModel.h"

@class SHDrawPathView;
@protocol SHDrawPathViewDelegate <NSObject>

-(void)drawPathViewShowPathChange:(SHDrawPathView *)view;

@end


@interface SHDrawPathView : UIView

@property(nonatomic,weak)id<SHDrawPathViewDelegate>delegate;

@property(nonatomic,assign)CGFloat lineWidth;

@property(nonatomic,strong)UIColor * lineColor;

@property(nonatomic,assign)CGLineCap lineCap;


/**
 自动绘制封闭路径。defalut:NO
 */
@property(nonatomic,assign)BOOL drawAutoClosePath;

@property(nonatomic,strong)UIColor * fillClosePathColor;


/**
 允许存储多笔路径。defalut:YES
 */
@property(nonatomic,assign)BOOL storeMutablePaths;

@property(nonatomic,assign,readonly)BOOL canUndo;

@property(nonatomic,assign,readonly)BOOL canRedo;

@property(nonatomic,strong)NSArray<SHPathModel *> * pathModelArray;

-(void)didBeganDrawOnePath:(void(^)(void))completion;
-(void)didFinishDrawOnePath:(void(^)(SHPathModel * pathModel))completion;

-(void)undo;

-(void)redo;


@end
