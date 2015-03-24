//
//  TFModel.h
//  CoreTFManagerVC
//
//  Created by 沐汐 on 15-3-5.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFModel : NSObject

//textField
@property (nonatomic,strong) UITextField *textField;

//textField的名称
@property (nonatomic,copy) NSString *name;

//textField在window中的frame
@property (nonatomic,assign) CGRect textFiledWindowFrame;

//textField在scrollView中的frame
@property (nonatomic,assign) CGRect textFieldScrollFrame;

//底部需要增加的距离
@property (nonatomic,assign) CGFloat insetBottom;

//inputView
@property (nonatomic,strong) UIView *inputView;


/**
 *  包装textField
 *
 *  @param textField   textField
 *  @param insetBottom textField底部需要增加的距离
 *
 *  @return 实例
 */
+(instancetype)modelWithTextFiled:(UITextField *)textField inputView:(UIView *)inputView name:(NSString *)name insetBottom:(CGFloat)insetBottom;


/**
 *  从textField寻找对应的模型
 *
 *  @param textField textField
 *  @param tfModels  模型数组
 *
 *  @return textField对应的模型
 */
+(TFModel *)findTextField:(UITextField *)textField fromTFModels:(NSArray *)tfModels;

@end
