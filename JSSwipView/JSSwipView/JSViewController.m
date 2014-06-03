//
//  JSViewController.m
//  JSSwipView
//
//  Created by Chuck Shen on 3/6/14.
//  Copyright (c) 2014 Chuck Shen. All rights reserved.
//

#import "JSViewController.h"


@interface JSViewController ()

@property (nonatomic) UIView *mainview;

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,250,50}];
	scrollview.contentSize = CGSizeMake(1000, 50);
	scrollview.backgroundColor = [UIColor yellowColor];
	scrollview.pagingEnabled = YES;
	UILabel *longLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1000, 50)];
	longLabel.backgroundColor = [UIColor greenColor];
	longLabel.text = @"aassasdjkahsdkjfhakjsdhfkhasdkjfhkajsdhfkjashdfkjhakjsdhfkjashdfkjhaskdjfhaklsdhfkasjdhflkasjhdfaskljdfhlksafhalksdfhdklashflkasdhfklashfklashf";
	[scrollview addSubview:longLabel];
	
	UIView *draggbleView = [self createViewWithNibName:@"DraggableButton"];
	
	JSSwipView *swipview = [[JSSwipView alloc] initWithDragView:draggbleView withMainView:scrollview];
    swipview.swapToRight = NO;
    swipview.frame = (CGRect){{20, 100}, swipview.frame.size};
    swipview.backgroundColor = [UIColor orangeColor];
    [swipview addButtonTitle:@"button1" withColor:[UIColor grayColor] withTarget:self withAction:@selector(button1Click:)];
    [swipview addButtonTitle:@"button2" withColor:[UIColor redColor] withTarget:self withAction:@selector(button2Click:)];
	
	UIView *mainview = [[UIView alloc] initWithFrame:(CGRect){0,0, 180, 50}];
	mainview.backgroundColor = [UIColor darkGrayColor];
	self.mainview = mainview;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self action:@selector(changeBackground) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"change BG" forState:UIControlStateNormal];
	[mainview addSubview:button];
	button.frame = (CGRect){30, 5 , 100, 30};
	UIView *draggbleView2 = [self createViewWithNibName:@"DraggableButton"];
	
	JSSwipView *swipview2 = [[JSSwipView alloc] initWithDragView:draggbleView2 withMainView:mainview];
    swipview2.swapToRight = YES;
    swipview2.frame = (CGRect){{20, 200}, swipview2.frame.size};
    swipview2.backgroundColor = [UIColor orangeColor];
    [swipview2 addButtonTitle:@"button1" withColor:[UIColor grayColor] withTarget:self withAction:@selector(button1Click:)];
    [swipview2 addButtonTitle:@"button2" withColor:[UIColor redColor] withTarget:self withAction:@selector(button2Click:)];
	
	[self.view addSubview:swipview];
	[self.view addSubview:swipview2];
	
}


- (UIView *) createViewWithNibName:(NSString *)nibName
{
	NSArray *nibViews = nil;
    @try
    {
        nibViews = [[NSBundle mainBundle] loadNibNamed:nibName
                                                 owner:nil
                                               options:nil];
    }
    @catch (NSException *ex)
    {
    }
    
    UIView *retView = nil;
    for (id oneObject in nibViews){
        if ([oneObject isKindOfClass:[UIView class]]){
            retView = (UIView *)oneObject;
            break;
        }
    }
	
    return retView;
}


- (void)button1Click:(id)sender {
	NSLog(@"button1Clicked");

}

- (void)button2Click:(id)sender {
	NSLog(@"button2Clicked");
}

- (void)changeBackground {
	NSInteger randomNumberRed = arc4random() % 256;
	NSInteger randomNumberGreen = arc4random() % 256;
	NSInteger randomNumberblue = arc4random() % 256;
	self.mainview.backgroundColor = [UIColor colorWithRed:randomNumberRed/255.0 green:randomNumberGreen/255.0 blue:randomNumberblue/255.0 alpha:1];
}


@end
