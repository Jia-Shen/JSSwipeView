//
//  JSSwipView.h
//
//  Created by Chuck Shen on 25/4/14.
//  Copyright (c) 2014 Chuck Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSSwipView : UIView

@property (weak, nonatomic) UIView *dragView;
@property (weak, nonatomic) UIView *mainView;
@property (nonatomic) BOOL swapToRight;

- (id)initWithDragView:(UIView *)dragView withMainView:(UIView *)mainView;
- (void)addButtonTitle:(NSString *)title withColor:(UIColor *)color withTarget:(id)target withAction:(SEL)action;
- (void)addButton:(UIButton *)button withTarget:(id)target withAction:(SEL)action;
- (void)addButton:(UIButton *)button;
- (void)setButtons:(NSMutableArray *)buttons;

- (void)closeButtonView;
- (void)openButtonView;

@end
