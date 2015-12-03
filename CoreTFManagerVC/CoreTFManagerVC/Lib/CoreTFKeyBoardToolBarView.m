//
//  CoreTFKeyBoardToolBarView.m
//  CoreTextFieldManager
//
//  Created by muxi on 15/2/15.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreTFKeyBoardToolBarView.h"

@interface CoreTFKeyBoardToolBarView ()

@property (strong, nonatomic) IBOutlet UIButton *preBtn;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;



@end




@implementation CoreTFKeyBoardToolBarView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.preBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


+(instancetype)keyBoardToolBarView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


#pragma mark  上一个
- (IBAction)preBtnClick:(id)sender {
    if(self.preClickBlock != nil) self.preClickBlock();
}

#pragma mark  下一个
- (IBAction)nextBtnClick:(id)sender {
    if(self.nextClickBlock != nil) self.nextClickBlock();
}

#pragma mark  完成
- (IBAction)doneBtnClick:(id)sender {
    if(self.doneClickBlock != nil) self.doneClickBlock();
}

-(void)setIsFirst:(BOOL)isFirst{
    
    //记录
    _isFirst=isFirst;
    
    _preBtn.enabled=!isFirst;
    
}

-(void)setIsLast:(BOOL)isLast{
    
    //记录
    _isLast=isLast;
    
    _nextBtn.enabled=!isLast;
}

-(void)setMsg:(NSString *)msg{_msg=msg; self.msgLabel.text = msg;}

-(void)setHideToggleBtnsForSingleTF:(BOOL)hideToggleBtnsForSingleTF{
    _hideToggleBtnsForSingleTF = hideToggleBtnsForSingleTF;
    if(!hideToggleBtnsForSingleTF) return;
    self.preBtn.hidden = YES; self.nextBtn.hidden=YES;
}

@end
