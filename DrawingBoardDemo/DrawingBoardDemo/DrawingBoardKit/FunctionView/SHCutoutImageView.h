//
//  SHCutoutImageView.h
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCutoutImageView : UIView

@property(nonatomic,strong)UIImage * image;

@property(nonatomic,assign)BOOL showMaskView;

@property(nonatomic,strong)UIColor * maskViewColor;

@property(nonatomic,strong)UIColor * drawPathLineColor;

@property(nonatomic,assign)CGFloat drawPathLineWidth;

-(void)finishDrawOnePath:(void(^)(void))completion;

-(UIImage *)finishCutout;

@end
