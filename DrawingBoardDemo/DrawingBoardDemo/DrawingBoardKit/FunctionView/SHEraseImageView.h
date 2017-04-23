//
//  SHEraseImageView.h
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPathModel.h"

@class SHEraseImageView;
@protocol SZEraseImageViewDelegate <NSObject>

-(void)erasePathChange:(SHEraseImageView *)eraseImageView;

@end

@interface SHEraseImageView : UIView

@property(nonatomic,weak)id<SZEraseImageViewDelegate>delegate;

@property(nonatomic,strong)UIImage * image;

@property(nonatomic,assign,readonly)BOOL canUndo;

@property(nonatomic,assign,readonly)BOOL canRedo;

@property(nonatomic,assign)CGFloat eraserLineWidth;

@property(nonatomic,assign)CGLineCap eraserLineCap;

-(void)undo;
-(void)redo;

-(UIImage *)finishErase;


@end
