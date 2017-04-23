//
//  EraseImageViewController.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "EraseImageViewController.h"
#import "SHEraseImageView.h"

@interface EraseImageViewController ()<SZEraseImageViewDelegate>

@property (weak, nonatomic) IBOutlet SHEraseImageView *eraseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *redoBtn;

@end

@implementation EraseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eraseImageView.image = [UIImage imageNamed:@"小黄人.png"];
    self.eraseImageView.eraserLineWidth = 5;
    self.eraseImageView.eraserLineCap = kCGLineCapRound;
    self.eraseImageView.backgroundColor = [UIColor lightGrayColor];
    self.eraseImageView.delegate = self;
}

- (IBAction)didClickOnBold:(id)sender {
    self.eraseImageView.eraserLineWidth = 20;
    
}
- (IBAction)didClickOnNormal:(id)sender {
    self.eraseImageView.eraserLineWidth = 10;
}
- (IBAction)didClickOnThin:(id)sender {
    self.eraseImageView.eraserLineWidth = 5;
}
- (IBAction)didClickOnUndo:(id)sender {
    [self.eraseImageView undo];
}
- (IBAction)didClickOnRedo:(id)sender {
    [self.eraseImageView redo];
}
- (IBAction)didClickOnFinish:(UIButton *)sender {
    self.resultImageView.image = [self.eraseImageView finishErase];
}

-(void)erasePathChange:(SHEraseImageView *)eraseImageView
{    
    self.undoBtn.enabled = eraseImageView.canUndo;
    self.redoBtn.enabled = eraseImageView.canRedo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
