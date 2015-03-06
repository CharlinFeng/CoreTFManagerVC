//
//  CoreTFKeyBoardToolBarView.h
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreTFKeyBoardToolBarView : UIView

@property (nonatomic,copy) void(^preClickBlock)();                                              //上一个

@property (nonatomic,copy) void(^nextClickBlock)();                                             //下一个

@property (nonatomic,copy) void(^doneClickBlock)();                                             //完成

@property (nonatomic,assign) BOOL isFirst;                                                      //到达第一个按钮

@property (nonatomic,assign) BOOL isLast;                                                       //到达最后一个按钮


+(instancetype)keyBoardToolBarView;

@end
