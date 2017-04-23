//
//  DrawingViewController.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "DrawingViewController.h"
#import "SHDrawPathView.h"

@interface DrawingViewController ()

@property (weak, nonatomic) IBOutlet SHDrawPathView *drawPathView;


@end

@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画板";
    self.drawPathView.lineWidth = 5;
    self.drawPathView.lineCap = kCGLineCapRound;
    self.drawPathView.lineColor = [UIColor redColor];
}

- (IBAction)didClickOnRed:(id)sender {
    self.drawPathView.lineColor = [UIColor redColor];
}
- (IBAction)didClickOnYellow:(id)sender {
    self.drawPathView.lineColor = [UIColor yellowColor];
}

- (IBAction)didClickOnBlue:(id)sender {
    self.drawPathView.lineColor = [UIColor blueColor];

}
- (IBAction)didClickOnBlack:(id)sender {
    self.drawPathView.lineColor = [UIColor blackColor];

}
- (IBAction)didClickOnBlod:(id)sender {
    self.drawPathView.lineWidth = 10;
}
- (IBAction)didClickOnNormal:(id)sender {
    self.drawPathView.lineWidth = 5;

}
- (IBAction)didClickOnThin:(id)sender {
    self.drawPathView.lineWidth = 1;
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
