//
//  SHDrawPathView.m
//  DrawingBoardDemo
//
//  Created by Rebecca on 2017/4/23.
//  Copyright © 2017年 RebeccaLiu. All rights reserved.
//

#import "SHDrawPathView.h"

@interface SHDrawPathView()
{
    CGPoint _originalPoint;
    CGPoint _lastPoint;
    CGPoint _nextPoint;
    
    UIBezierPath * _currentPath;
    SHPathModel * _currentPathModel;
    
    NSMutableArray * _allPathModelArray;
    NSMutableArray * _showPathModelArray;
    
    void (^_didBeganDrawOnePathBlock)(void);
    void (^_didFinishDrawOnePathBlock)(SHPathModel * pathModel);
}

@end

@implementation SHDrawPathView
#pragma mark - Public Methods

-(void)didBeganDrawOnePath:(void (^)(void))completion
{
    _didBeganDrawOnePathBlock = [completion copy];
}

-(void)didFinishDrawOnePath:(void (^)(SHPathModel *))completion
{
    _didFinishDrawOnePathBlock = [completion copy];
}

-(NSArray<SHPathModel *> *)pathModelArray
{
    NSArray * array = [[NSArray alloc]initWithArray:_showPathModelArray];
    return array;
}

-(void)undo
{
    if ([self canUndo]) {
        [_showPathModelArray removeLastObject];
        [self setNeedsDisplay];
        [self callBackDelegate];
    }
}

-(void)redo
{
    if ([self canRedo]) {
        NSUInteger toAddIndex = _showPathModelArray.count;
        [_showPathModelArray addObject:[_allPathModelArray objectAtIndex:toAddIndex]];
        [self setNeedsDisplay];
        [self callBackDelegate];
    }
}

-(BOOL)canRedo
{
    if (_allPathModelArray.count>_showPathModelArray.count) {
        return YES;
    }
    else{
        return NO;
    }
    
}

-(BOOL)canUndo
{
    if (_showPathModelArray.count>0) {
        return YES;
    }
    else{
        return NO;
    }
}


#pragma mark - Private Methods
-(void)buildVar
{
    _didBeganDrawOnePathBlock = nil;
    _didFinishDrawOnePathBlock = nil;
    
    _allPathModelArray = [[NSMutableArray alloc]init];
    _showPathModelArray = [[NSMutableArray alloc]init];
    
    _lineWidth = 1;
    _lineCap = kCGLineCapButt;
    _lineColor = [UIColor blackColor];
    _drawAutoClosePath = NO;
    _fillClosePathColor = nil;
    _storeMutablePaths = YES;
    
}

-(void)clearMemoryPath
{
    if (_allPathModelArray.count>_showPathModelArray.count) {
        NSUInteger removeLength = _allPathModelArray.count-_showPathModelArray.count;
        NSUInteger beginIndex = _showPathModelArray.count;
        [_allPathModelArray removeObjectsInRange:NSMakeRange(beginIndex, removeLength)];
    }
}

-(void)addPanGesture
{
    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:panGR];
}

-(void)callBackDelegate
{
    if (_delegate && [_delegate respondsToSelector:@selector(drawPathViewShowPathChange:)]) {
        [_delegate drawPathViewShowPathChange:self];
    }
}

-(void)didPan:(UIPanGestureRecognizer *)panGR
{
    CGPoint point = [panGR translationInView:self];
    
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:{
            if (_storeMutablePaths == NO) {
                [_showPathModelArray removeAllObjects];
                [_allPathModelArray removeAllObjects];
            }
            [self clearMemoryPath];
            
            _currentPathModel = [[SHPathModel alloc]init];
            _currentPathModel.strokeColor = _lineColor;
            _currentPathModel.closePath = _drawAutoClosePath;
            _currentPathModel.fillColor = _fillClosePathColor;
            
            _currentPath = [UIBezierPath bezierPath];
            _currentPath.lineWidth = _lineWidth;
            _currentPath.lineCapStyle = _lineCap;
            _currentPathModel.path = _currentPath;
            
            [_currentPath moveToPoint:_originalPoint];
            _lastPoint = _originalPoint;
            
            if (_didBeganDrawOnePathBlock) {
                _didBeganDrawOnePathBlock();
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint nextPoint =CGPointMake(_lastPoint.x+point.x, _lastPoint.y+point.y);
            [_currentPath addLineToPoint:nextPoint];
            _lastPoint = nextPoint;
            [self setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (_drawAutoClosePath == YES) {
                [_currentPathModel.path closePath];
            }
            
            SHPathModel * copyPathModel =[_currentPathModel copy];
            [_showPathModelArray addObject:copyPathModel];
            [_allPathModelArray addObject:copyPathModel];
            
            if (_didFinishDrawOnePathBlock) {
                _didFinishDrawOnePathBlock([_currentPathModel copy]);
            }
            _currentPathModel = nil;
            _currentPath = nil;
            [self setNeedsDisplay];
            [self callBackDelegate];
        }
            break;
        default:
            break;
    }
    [panGR setTranslation:CGPointZero inView:self];
}


#pragma mark - Override Methods
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildVar];
        [self addPanGesture];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildVar];
        [self addPanGesture];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context =CGContextRetain(UIGraphicsGetCurrentContext()) ;
    CGContextSaveGState(context);
    {
//        NSLog(@"_showPathModelArray count:%@",_showPathModelArray);
        for (NSUInteger i = 0; i<_showPathModelArray.count; i++) {
            SHPathModel * pathModel = [_showPathModelArray objectAtIndex:i];
            CGContextSetLineWidth(context, pathModel.path.lineWidth);
            
            CGColorRef cgStrokeColor = CGColorRetain(pathModel.strokeColor.CGColor);
            CGContextSetStrokeColorWithColor(context,cgStrokeColor);
            CGColorRelease(cgStrokeColor);
    
            CGPathRef cgPath = CGPathRetain(pathModel.path.CGPath);
            CGContextAddPath(context, cgPath);
            CGPathRelease(cgPath);
            
            CGContextSetLineCap(context, pathModel.path.lineCapStyle);

            
            if (pathModel.isClosePath && pathModel.fillColor) {
                CGColorRef cgfillClosePathColor = CGColorRetain(_fillClosePathColor.CGColor);
                CGContextSetFillColorWithColor(context,cgfillClosePathColor);
                CGColorRelease(cgfillClosePathColor);

                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else{
                CGContextStrokePath(context);
            }
        }
        if (_currentPathModel) {
            CGContextSetLineWidth(context, _currentPathModel.path.lineWidth);
            
            CGColorRef currentStrokeColor = CGColorRetain(_currentPathModel.strokeColor.CGColor);
            CGContextSetStrokeColorWithColor(context,currentStrokeColor);
            CGColorRelease(currentStrokeColor);
            
            CGContextSetLineCap(context, _currentPathModel.path.lineCapStyle);
            
            CGPathRef currentCGPath = CGPathRetain(_currentPathModel.path.CGPath);
            CGContextAddPath(context, currentCGPath);
            CGPathRelease(currentCGPath);
            
            CGContextStrokePath(context);
        }
    }
    CGContextRestoreGState(context);
    CGContextRelease(context);
}

#pragma mark - UITouch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    _originalPoint = [touch locationInView:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}



@end
