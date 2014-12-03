//
//  ViewController.m
//  KeyboradNotificationCenterDemo
//
//  Created by alex on 13-7-23.
//  Copyright (c) 2013年 alex. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textField=_textField;
@synthesize closeBtn=_closeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //当前爱你controller监听键盘事件
        __block ViewController *selfBlock=self;
        //__block用于修饰self，保证不会循环引用
        [[KeyboradNotificationCenter defaultCenter] addObserver:self
                                                       willShow:^(NSKeyboradNotification *keyboradObj) {
                                                           CGRect keyboardFrameEnd_View = [selfBlock.view convertRect:keyboradObj.keyboardFrameEnd fromView:nil];
                                                           
                                                           NSLog(@"NSKeyboradNotification");
                                                           
                                                           /* Move the toolbar to above the keyboard */
                                                           [UIView beginAnimations:nil context:NULL];
                                                           [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
                                                           [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
                                                           [UIView setAnimationBeginsFromCurrentState:YES];
                                                           CGRect frame = selfBlock.textField.frame;
                                                           frame.origin.y= keyboardFrameEnd_View.origin.y-selfBlock.textField.frame.size.height;//键盘高度
                                                           selfBlock.textField.frame = frame;
                                                           [UIView commitAnimations];
                                                       }
                                                       willHide:^(NSKeyboradNotification *keyboradObj) {
                                                            CGRect keyboardFrameEnd_View = [selfBlock.view convertRect:keyboradObj.keyboardFrameEnd fromView:nil];
                                                           
                                                           /* Move the toolbar to above the keyboard */
                                                           [UIView beginAnimations:nil context:NULL];
                                                           [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
                                                           [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
                                                           [UIView setAnimationBeginsFromCurrentState:YES];
                                                           CGRect frame = selfBlock.textField.frame;
                                                           frame.origin.y= keyboardFrameEnd_View.origin.y-selfBlock.textField.frame.size.height;//键盘高度
                                                           selfBlock.textField.frame = frame;
                                                           [UIView commitAnimations];
                                                       }
         ];

    }
    return self;
}

-(void)dealloc{
    [[KeyboradNotificationCenter defaultCenter] removeKeyBoradObserver:self];
    
    [_textField release];
    _textField=nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewDidLoad");
    UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-30,self.view.frame.size.width, 30)];
    textField.borderStyle=UITextBorderStyleRoundedRect;//边框类型
    textField.font=[UIFont systemFontOfSize:12.0f];
    textField.text=@"";
    textField.placeholder=@"请输入";//提示语
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    self.textField=textField;
    [self.view addSubview:textField];
    [textField release];
    
    //结束编辑
    UIButton *endBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [endBtn setTitle:@"结束" forState:UIControlStateNormal];
    endBtn.titleLabel.textColor=[UIColor redColor];
    endBtn.frame=CGRectMake(100,100,80,40);
    [endBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.textField.text=nil;
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark custom
-(IBAction)closeAction:(id)sender{
    [self.textField resignFirstResponder];
}
@end
