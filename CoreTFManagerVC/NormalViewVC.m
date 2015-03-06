//
//  NormalViewVC.m
//  CoreTFManagerVC
//
//  Created by 沐汐 on 15-3-5.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NormalViewVC.h"
#import "CoreTFManagerVC.h"

@interface NormalViewVC ()

@property (strong, nonatomic) IBOutlet UITextField *tf1;
@property (strong, nonatomic) IBOutlet UITextField *tf2;
@property (strong, nonatomic) IBOutlet UITextField *tf3;
@property (strong, nonatomic) IBOutlet UITextField *tf4;
@property (strong, nonatomic) IBOutlet UITextField *tf5;


@property (nonatomic,strong) UIView *inputView2;


@end

@implementation NormalViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
    
        UIDatePicker *picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        
        TFModel *tfm1=[TFModel modelWithTextFiled:_tf1 inputView:nil name:@"tf1" insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:_tf2 inputView:picker name:@"tf2" insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:_tf3 inputView:nil name:@"tf3" insetBottom:0];
        TFModel *tfm4=[TFModel modelWithTextFiled:_tf4 inputView:nil name:@"tf4" insetBottom:40];
        TFModel *tfm5=[TFModel modelWithTextFiled:_tf5 inputView:nil name:@"tf5" insetBottom:0];
        
        return @[tfm1,tfm2,tfm3,tfm4,tfm5];
        
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}


@end
