//
//  TFModel.m
//  CoreTFManagerVC
//
//  Created by 沐汐 on 15-3-5.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "TFModel.h"

@implementation TFModel

/**
 *  包装textField
 *
 *  @param textField   textField
 *  @param insetBottom textField底部需要增加的距离
 *
 *  @return 实例
 */
+(instancetype)modelWithTextFiled:(UITextField *)textField inputView:(UIView *)inputView name:(NSString *)name insetBottom:(CGFloat)insetBottom{
    
    TFModel *tfm=[[TFModel alloc] init];
    
    tfm.textField=textField;
    
    tfm.inputView=inputView;
    
    tfm.name=name;
    
    tfm.insetBottom=insetBottom;
    
    return tfm;
}

/**
 *  从textField寻找对应的模型
 *
 *  @param textField textField
 *  @param tfModels  模型数组
 *
 *  @return textField对应的模型
 */
+(TFModel *)findTextField:(UITextField *)textField fromTFModels:(NSArray *)tfModels{
    
    if(tfModels==nil || tfModels.count==0) return nil;
    
    for (TFModel *tfModel in tfModels) {
        if(tfModel.textField != textField) continue;
        return tfModel;
    }

    return nil;
}



@end
