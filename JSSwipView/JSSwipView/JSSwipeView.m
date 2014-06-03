//
//  JSSwipView.m
//
//  Created by Chuck Shen on 25/4/14.
//  Copyright (c) 2014 Chuck Shen. All rights reserved.
//

#import "JSSwipeView.h"

#define kBlankSpace 10.0
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface JSSwipView()

@property (assign) BOOL currentRightDirection;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic, nonatomic) CGFloat maxDragWidth;
@property (nonatomic, nonatomic) CGFloat viewHeight;
@property (nonatomic) UIButton *opencloseButton;

@end

@implementation JSSwipView

- (id)initWithDragView:(UIView *)dragView withMainView:(UIView *)mainView
{
	self.dragView = dragView;
	self.mainView = mainView;
	CGFloat frameWidth = CGRectGetWidth(dragView.frame) + CGRectGetWidth(mainView.frame);
	CGRect frame = (CGRect){CGPointZero, {frameWidth, CGRectGetHeight(mainView.frame)}};
	
    self = [super initWithFrame:frame];
    if (self) {
		
		self.buttons = [@[] mutableCopy];
		self.swapToRight = YES;
		self.maxDragWidth = 0.0;
		self.viewHeight = CGRectGetHeight(frame);
        
		UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
										   initWithTarget:self
										   action:@selector(viewDragged:)];
		self.dragView.userInteractionEnabled = YES;
		[self.dragView addGestureRecognizer:gesture];
		self.opencloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.opencloseButton.frame = (CGRect){CGPointZero, self.dragView.frame.size};
		[self.opencloseButton addTarget:self action:@selector(openButtonView) forControlEvents:UIControlEventTouchUpInside];
		[self.dragView addSubview:self.opencloseButton];
		[self addSubview:self.mainView];
		[self addSubview:self.dragView];
    }
	
	
    return self;
}

- (void)viewDragged:(UIPanGestureRecognizer *)gesture
{
    if (self.maxDragWidth == 0) {
        return;
    }
	UIView *view = (UIView *)gesture.view;
	CGPoint translation = [gesture translationInView:view];
	
	
    // move label
	view.center = CGPointMake(view.center.x + translation.x,
							  view.center.y);
	
	self.mainView.center = CGPointMake(self.mainView.center.x + translation.x,
									   self.mainView.center.y);
	
    if (self.swapToRight) {
        if (CGRectGetMinX(view.frame) < 0) {
            CGPoint point = view.frame.origin;
            point.x = 0;
            view.frame = (CGRect){point, view.frame.size};
            
            self.mainView.frame = (CGRect){{CGRectGetWidth(view.frame), point.y}, self.mainView.frame.size};
        } else if (CGRectGetMinX(view.frame) > self.maxDragWidth) {
            CGPoint point = view.frame.origin;
            point.x = self.maxDragWidth;
            view.frame = (CGRect){point, view.frame.size};
            
            self.mainView.frame = (CGRect){{self.maxDragWidth + CGRectGetWidth(view.frame), point.y}, self.mainView.frame.size};
        }
    } else {
        if (CGRectGetMaxX(view.frame) > CGRectGetWidth(self.frame)) {
            CGPoint point = view.frame.origin;
            point.x = CGRectGetWidth(self.frame) - CGRectGetWidth(view.frame);
            view.frame = (CGRect){point, view.frame.size};
            self.mainView.frame = (CGRect){CGPointZero, self.mainView.frame.size};
        } else if ((CGRectGetWidth(self.frame) - CGRectGetMaxX(view.frame)) > self.maxDragWidth) {
            CGPoint point = view.frame.origin;
            point.x = CGRectGetWidth(self.frame) - CGRectGetWidth(view.frame) - self.maxDragWidth;
            view.frame = (CGRect){point, view.frame.size};
            self.mainView.frame = (CGRect){{-self.maxDragWidth, point.y}, self.mainView.frame.size};
        }
    }
	
	
	// reset translation
	[gesture setTranslation:CGPointZero inView:view];
	
	if (translation.x > 0) {
		self.currentRightDirection = YES;
	} else if (translation.x < 0) {
		self.currentRightDirection = NO;
	}
	
	
	
	if(gesture.state == UIGestureRecognizerStateEnded)
	{
		//All fingers are lifted.
		if (self.currentRightDirection) {
            if (self.swapToRight) {
                if (view.center.x < self.maxDragWidth/3) {
                    [self closeButtonView];
                } else {
                    [self openButtonView];
                }
            } else {
                if ((CGRectGetWidth(self.frame) - view.center.x) < self.maxDragWidth/3*2) {
                    [self closeButtonView];
                } else {
                    [self openButtonView];
                }
            }
			
		} else {
            if (self.swapToRight) {
                if (view.center.x > self.maxDragWidth/3*2) {
                    [self openButtonView];
                } else {
                    [self closeButtonView];
                }
			} else {
                if ((CGRectGetWidth(self.frame) - view.center.x) > self.maxDragWidth/3) {
                    [self openButtonView];
                } else {
                    [self closeButtonView];
                }
            }
		}
		
	}
}

-(void)setSwapToRight:(BOOL)swapToRight
{
	if (swapToRight) {
		self.dragView.frame = (CGRect){CGPointZero, self.dragView.frame.size};
		self.mainView.frame = (CGRect){{CGRectGetWidth(self.dragView.frame),0}, self.mainView.frame.size};
	} else {
		self.mainView.frame = (CGRect){CGPointZero, self.mainView.frame.size};
		self.dragView.frame = (CGRect){{CGRectGetWidth(self.mainView.frame), 0}, self.dragView.frame.size};
	}
	_swapToRight = swapToRight;
}

-(void)closeButtonView
{
	[self.opencloseButton removeTarget:self action:@selector(closeButtonView) forControlEvents:UIControlEventTouchUpInside];
	[self.opencloseButton addTarget:self action:@selector(openButtonView) forControlEvents:UIControlEventTouchUpInside];
	[UIView beginAnimations:@"CVSwapViewClose" context:NULL];
	
    if (self.swapToRight) {
        self.dragView.frame = (CGRect){{0, CGRectGetMinY(self.dragView.frame)}, self.dragView.frame.size};
        self.mainView.frame = (CGRect){{CGRectGetMaxX(self.dragView.frame), CGRectGetMinY(self.mainView.frame)}, self.mainView.frame.size};
    } else {
        self.dragView.frame = (CGRect){{(CGRectGetWidth(self.frame) - CGRectGetWidth(self.dragView.frame)), CGRectGetMinY(self.dragView.frame)}, self.dragView.frame.size};
        self.mainView.frame = (CGRect){CGPointZero, self.mainView.frame.size};
    }
	
	
	[UIView setAnimationDuration:1];
	[UIView commitAnimations];
}

-(void)openButtonView
{
	[self.opencloseButton removeTarget:self action:@selector(openButtonView) forControlEvents:UIControlEventTouchUpInside];
	[self.opencloseButton addTarget:self action:@selector(closeButtonView) forControlEvents:UIControlEventTouchUpInside];
	[UIView beginAnimations:@"CVSwapViewOpen" context:NULL];
	
    if (self.swapToRight) {
        self.dragView.frame = (CGRect){{self.maxDragWidth, CGRectGetMinY(self.dragView.frame)}, self.dragView.frame.size};
        self.mainView.frame = (CGRect){{self.maxDragWidth + CGRectGetWidth(self.dragView.frame), CGRectGetMinY(self.mainView.frame)}, self.mainView.frame.size};
    } else {
        self.dragView.frame = (CGRect){{(CGRectGetWidth(self.frame) - CGRectGetWidth(self.dragView.frame) - self.maxDragWidth), CGRectGetMinY(self.dragView.frame)}, self.dragView.frame.size};
        self.mainView.frame = (CGRect){{-self.maxDragWidth, CGRectGetMinY(self.mainView.frame)}, self.mainView.frame.size};
    }
	
	
	[UIView setAnimationDuration:1];
	[UIView commitAnimations];
}


-(void)addButtonTitle:(NSString *)title withColor:(UIColor *)color withTarget:(id)target withAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (!self.swapToRight) {
        button.frame = (CGRect){self.maxDragWidth, 0, [self getButtonWidthByString:button], self.viewHeight};
    } else {
        button.frame = (CGRect){(CGRectGetWidth(self.frame) - CGRectGetWidth(button.frame) - self.maxDragWidth), 0, [self getButtonWidthByString:button], self.viewHeight};
    }
    button.backgroundColor = color;
    [self addButton:button withTarget:target withAction:action];
}

-(void)addButton:(UIButton *)button withTarget:(id)target withAction:(SEL)action
{
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addButton:button];
}

-(void)addButton:(UIButton *)button
{
    [self setButtonFrame:button];
	[self.buttons addObject:button];
	self.maxDragWidth += CGRectGetWidth(button.frame);
    [self addSubview:button];
    [self bringSubviewToFront:self.mainView];
    [self bringSubviewToFront:self.dragView];
}

-(void)setButtons:(NSArray *)buttons
{
	_buttons = [buttons mutableCopy];
	self.maxDragWidth = 0;
	for (UIButton *button in buttons) {
        [self setButtonFrame:button];
		self.maxDragWidth += CGRectGetWidth(button.frame);
        [self addSubview:button];
	}
    [self bringSubviewToFront:self.mainView];
    [self bringSubviewToFront:self.dragView];
}

-(CGFloat)getButtonWidthByString:(UIButton *)button;
{
    UIFont *font = button.titleLabel.font;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    NSString *title = [button titleForState:UIControlStateNormal];
    CGSize buttonSize = CGSizeZero;
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		buttonSize = [title sizeWithAttributes:attributes];
	} else {
		buttonSize = [title sizeWithFont:font];
	}
	
    return buttonSize.width + kBlankSpace*2;
}

-(void)setButtonFrame:(UIButton *)button
{
    CGFloat x = 0.0;
    if (self.swapToRight) {
        x = self.maxDragWidth;
    } else {
        x = CGRectGetWidth(self.frame) - CGRectGetWidth(button.frame) - self.maxDragWidth;
    }
    button.frame = (CGRect){{x, 0}, button.frame.size};
}

@end
