//
//  ScrollViewVC.m
//  CoreTFManagerVC
//
//  Created by muxi on 15/3/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "ScrollViewVC.h"
#import "CoreTFManagerVC.h"

@interface ScrollViewVC ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UITextField *tf1;
@property (strong, nonatomic) IBOutlet UITextField *tf2;
@property (strong, nonatomic) IBOutlet UITextField *tf3;
@property (strong, nonatomic) IBOutlet UITextField *tf4;
@property (strong, nonatomic) IBOutlet UITextField *tf5;
@property (strong, nonatomic) IBOutlet UITextField *tf6;






@end



@implementation ScrollViewVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.scrollView.layer.borderColor=[UIColor brownColor].CGColor;
    self.scrollView.layer.borderWidth=2.0f;
    
    self.scrollView.contentInset=UIEdgeInsetsMake(40, 60, 80, 100);
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:self.scrollView tfModels:^NSArray *{
        UIDatePicker *picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];

        
        TFModel *tfm1=[TFModel modelWithTextFiled:_tf1 inputView:nil insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:_tf2 inputView:picker insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:_tf3 inputView:nil insetBottom:30];
        TFModel *tfm4=[TFModel modelWithTextFiled:_tf4 inputView:nil insetBottom:0];
        TFModel *tfm5=[TFModel modelWithTextFiled:_tf5 inputView:nil insetBottom:0];
        TFModel *tfm6=[TFModel modelWithTextFiled:_tf6 inputView:nil insetBottom:0];
        
        return @[tfm1,tfm2,tfm3,tfm4,tfm5,tfm6];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}


@end
