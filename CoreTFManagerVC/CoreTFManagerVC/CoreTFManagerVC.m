//
//  CoreTFManagerVC.m
//  CoreTFManagerVC
//
//  Created by 沐汐 on 15-3-5.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreTFManagerVC.h"
#import "CoreTFKeyBoardToolBarView.h"
#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f

@interface CoreTFManagerVC ()<UITextFieldDelegate>

//控制器
@property (nonatomic,strong) UIViewController *superVC;

//输入框的父级控件
@property (nonatomic,strong) UIScrollView *scrollView;

//输入框模型数组
@property (nonatomic,strong) NSArray *tfModels;

//键盘工具条
@property (nonatomic,strong) CoreTFKeyBoardToolBarView *keyBoardToolBarView;

//当前的输入框对象
@property (nonatomic,strong) TFModel *currentTFModel;

//动画曲线
@property (nonatomic,assign) NSInteger keyBoardCurve;

//动画时长
@property (nonatomic,assign) CGFloat keyBoardDuration;

//键盘高度
@property (nonatomic,assign) CGFloat keyBoardHeight;

//scrollView转换到window中的frame
@property (nonatomic,assign) CGFloat scrollWindowFrameY;

//keyBoardToolBarView的高度
@property (nonatomic,assign) CGFloat keyBoardToolBarViewH;

//屏幕高度：性能优化
@property (nonatomic,assign) CGFloat screenH;

//window
@property (nonatomic,strong) UIWindow *window;


@end

@implementation CoreTFManagerVC



/**
 *  安装
 *
 *  @param vc         需要安装的控制器
 *  @param scrollView textField所在的scrollView
 *  @param tfModels   textField包装模型数组
 */
+(void)installManagerForVC:(UIViewController *)vc scrollView:(UIScrollView *)scrollView tfModels:(NSArray *(^)())tfModels{
    
    if(vc==nil){
        NSLog(@"CoreTFManagerVC：安装失败，您传入的控制器不合法，不能为nil");
        return;
    }

    NSArray *tfModelsArray=nil;
    
    if(tfModels!=nil) tfModelsArray=tfModels();

    BOOL res=[self checkTFModels:tfModelsArray];
    
    if(!res) return;
    
    CoreTFManagerVC *tfManagerVC=[[CoreTFManagerVC alloc] init];
    
    //记录自己，保命
    [vc addChildViewController:tfManagerVC];
    
    //记录
    tfManagerVC.superVC=vc;
    
    //scrollView
    tfManagerVC.scrollView=scrollView;
    
    //输入框模型数组
    if(tfModels!=nil) tfManagerVC.tfModels=tfModels();
    
    //注册键盘监听
    [tfManagerVC keyboardObserver];
}

/**
 *  数据合法性校验
 */
+(BOOL)checkTFModels:(NSArray *)tfModels{
    
    if(tfModels==nil || tfModels.count==0){
        
        NSLog(@"CoreTFManagerVC：安装失败，您传入的textField数组不合法，没有数据");
        
        return NO;
    }

    for (id obj in tfModels) {
        
        if([obj isKindOfClass:[TFModel class]]) continue;
        
        NSLog(@"CoreTFManagerVC：安装失败，tfModels数组内部的对象不是TFModel模型对象");
        
        return NO;
    }
    
    return YES;
}


/**
 *  注册键盘监听
 */
-(void)keyboardObserver{
    
    //添加键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //添加键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}




#pragma mark - 键盘弹出通知
-(void)keyBoardWillShow:(NSNotification *)noti{
    
    //此方法调用时机：
    //1.弹出不同键盘
    //2.键盘初次中文输入
    //3.屏幕旋转
    
    //键盘即将弹出，更新以下值
    //如果是相同的键盘，此方法不会重复调用，我们应该在此处记录重要数据
    NSDictionary *userInfo=noti.userInfo;
    
    //记录动画曲线
    self.keyBoardCurve=[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    //时间时长
    self.keyBoardDuration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //键盘高度
    self.keyBoardHeight=[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrame];
}

-(void)keyBoardWillHide:(NSNotification *)noti{
    //视图恢复原位
    [UIView animateWithDuration:_keyBoardDuration animations:^{
        //动画曲线
        [UIView setAnimationCurve:_keyBoardCurve];
        self.superVC.view.transform=CGAffineTransformIdentity;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.currentTFModel.textField resignFirstResponder];
    
    //如果有scrollView，需要考虑恢复scrollView的状态
    if(self.scrollView!=nil) self.keyBoardToolBarView.doneClickBlock();
    
    return YES;
}



#pragma mark  -代理方法区
#pragma mark  即将开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //记录
    self.currentTFModel=[TFModel findTextField:textField fromTFModels:self.tfModels];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self adjustFrame];
    });

    return YES;
}






#pragma mark - 调整当前视图的frame
-(void)adjustFrame{
    
    //控件获取最大的y值
    CGFloat tfMaxY=CGRectGetMaxY(self.currentTFModel.textFiledWindowFrame);
    CGFloat insetBottom=self.currentTFModel.insetBottom;
    
    
    //计算得到最大的y值:主要是避开一些按钮
    CGFloat totalMaxY=tfMaxY + insetBottom;
    
    //计算键盘最小的Y值
    CGFloat keyBoardMinY=self.screenH - _keyBoardHeight;
    
    CGFloat deltaY= keyBoardMinY - totalMaxY;
    
    CGAffineTransform transform=deltaY>0?CGAffineTransformIdentity:CGAffineTransformMakeTranslation(0,deltaY);
    
    if(self.scrollView==nil){//NormalView
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //视图上移
            [UIView animateWithDuration:_keyBoardDuration animations:^{
                //动画曲线
                [UIView setAnimationCurve:_keyBoardCurve];
                self.superVC.view.transform=transform;
            }];
        });
    }else{//ScrollView
        
        //我们不需要windowFrame
        //1.将文本框直接置顶
        CGFloat testFieldX = self.scrollView.contentOffset.x;
        //下移动:
        CGFloat textFieldY =CGRectGetMaxY(self.currentTFModel.textFieldScrollFrame) -(self.screenH - self.scrollWindowFrameY - self.keyBoardHeight - insetBottom);
        
        if(ios6x) textFieldY+=20.0f;
        
        CGFloat minY=-self.scrollView.contentInset.top;
        
        if(textFieldY<= minY) textFieldY=minY;
        
        CGPoint contentOffset=CGPointMake(testFieldX,textFieldY);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:_keyBoardDuration animations:^{
            
                //动画曲线
                [UIView setAnimationCurve:_keyBoardCurve];
                
                [self.scrollView scrollRectToVisible:self.currentTFModel.textFieldScrollFrame animated:NO];
                
                self.scrollView.contentOffset=contentOffset;
            }];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新键盘工具条的状态
        [self updateStatusForKeyboardTool];
    });
}





-(void)setTfModels:(NSArray *)tfModels{
    
    //遍历所有文本框
    [tfModels enumerateObjectsUsingBlock:^(TFModel *tfm, NSUInteger idx, BOOL *stop) {
        
        //取出文本框
        UITextField *textField=tfm.textField;
        
        //设置代理
        textField.delegate=self;
        
        //设置placeHolder
        if(textField.placeholder==nil) textField.placeholder=tfm.name;
        
        //设置键盘
        if(tfm.inputView!=nil) textField.inputView=tfm.inputView;
        
        //设置键盘工具条
        textField.inputAccessoryView=self.keyBoardToolBarView;
        
        //返回键样式
        textField.returnKeyType=UIReturnKeyDefault;
        
        //window
        if(self.window==nil) self.window=self.superVC.view.window;
        
        //textField在window中的frame
        tfm.textFiledWindowFrame = [self.window convertRect:textField.frame fromView:textField.superview];
        
        //textField在scrollView中的frame
        if(self.scrollView!=nil) tfm.textFieldScrollFrame=[self.scrollView convertRect:textField.frame fromView:textField.superview];
        
        //scrollView在window中的frame
        if(self.scrollView!=nil && self.scrollWindowFrameY==0) self.scrollWindowFrameY = [self.window convertRect:self.scrollView.frame fromView:self.scrollView.superview].origin.y;

    }];
    
    //数组重新排序
    tfModels = [tfModels sortedArrayUsingComparator:^NSComparisonResult(TFModel *tfm1,TFModel *tfm2) {
        
        if(tfm1.textFiledWindowFrame.origin.y<tfm2.textFiledWindowFrame.origin.y) return NSOrderedAscending;
        
        if(tfm1.textFiledWindowFrame.origin.y>tfm2.textFiledWindowFrame.origin.y) return NSOrderedDescending;
        
        return NSOrderedSame;
        
    }];
    
    //记录
    _tfModels=tfModels;
    
}



-(CoreTFKeyBoardToolBarView *)keyBoardToolBarView{
    
    __weak typeof(self) weakSelf=self;
    
    if(!_keyBoardToolBarView){
        
        _keyBoardToolBarView=[CoreTFKeyBoardToolBarView keyBoardToolBarView];
        
        //上一个
        _keyBoardToolBarView.preClickBlock=^{
            
            [weakSelf toggleTFIsPre:YES];
        };
        
        //下一个
        _keyBoardToolBarView.nextClickBlock=^{
            
            [weakSelf toggleTFIsPre:NO];
        };
        
        //完成
        _keyBoardToolBarView.doneClickBlock=^{
            
            if(weakSelf.scrollView!=nil){
                
                //如果当前的scrollView的offset值超出正常值，应该调整到最大值
                CGFloat maxOffsetY=weakSelf.scrollView.contentSize.height - weakSelf.scrollView.bounds.size.height + weakSelf.scrollView.contentInset.bottom;
                if(maxOffsetY<=0) maxOffsetY=0;
                CGFloat currentOffsetY=weakSelf.scrollView.contentOffset.y;
                
                CGPoint offset=CGPointMake(weakSelf.scrollView.contentOffset.x, maxOffsetY);
                
                if(currentOffsetY>maxOffsetY){
                    [UIView animateWithDuration:weakSelf.keyBoardDuration animations:^{
                        //动画曲线
                        [UIView setAnimationCurve:weakSelf.keyBoardCurve];
                        [weakSelf.scrollView scrollRectToVisible:weakSelf.currentTFModel.textFieldScrollFrame animated:NO];
                        
                        weakSelf.scrollView.contentOffset=offset;
                    }];
                }
            }
 
            [weakSelf.currentTFModel.textField resignFirstResponder];
        };
        
    }
    
    return _keyBoardToolBarView;
}



-(void)toggleTFIsPre:(BOOL)isPre{
    
    //获取当前的index
    NSUInteger index=[self.tfModels indexOfObject:self.currentTFModel];
    NSUInteger count=self.tfModels.count;
    if(index>count) index=0;
    
    NSInteger i=isPre?-1:1;
    NSInteger nextIndex=index + i;
    if(nextIndex<0)nextIndex=0;
    if(nextIndex>=count) nextIndex=count-1;
    
    
    //下一个输入框获取焦点
    TFModel *tfModel=self.tfModels[nextIndex];

    //优化不同键盘的动画
    if(self.currentTFModel.inputView!=tfModel.inputView){
        [self.currentTFModel.textField resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tfModel.textField becomeFirstResponder];
        });
        
    }else{
        
        [tfModel.textField becomeFirstResponder];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        //更新键盘工具条的状态
        [self updateStatusForKeyboardTool];
    });
}


#pragma mark  更新键盘工具条的状态
-(void)updateStatusForKeyboardTool{
    //获取当前的index
    NSUInteger nowIndex=[self.tfModels indexOfObject:self.currentTFModel];
    
    _keyBoardToolBarView.isFirst=nowIndex==0;
    _keyBoardToolBarView.isLast=nowIndex==(self.tfModels.count - 1);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.currentTFModel.textField resignFirstResponder];
}


-(CGFloat)screenH{
    
    if(_screenH==0.){
        _screenH=self.window.bounds.size.height;
    }
    
    return _screenH;
}




/**
 *  卸载
 */
+(void)uninstallManagerForVC:(UIViewController *)vc{
    
    //键盘退下
    
    if(vc==nil) return;
    
    NSArray *childVCs=vc.childViewControllers;
    
    if(childVCs==nil || childVCs.count==0) return;
    
    for (UIViewController *vc in childVCs) {
        
        if(![vc isKindOfClass:[self class]]) continue;
        
        //移除
        [vc removeFromParentViewController];
        break;
    }
    
}



/**
 *  空值校验
 *
 *  @param tfModels  textField包装模型数组
 *  @return 如果没有textField存在空值，返回nil；如果有textField为空，则返回对应的TFModel模型
 */
+(TFModel *)checkNullValueInTFModels:(NSArray *)tfModels{
    
    //数据合法性校验
    BOOL res=[self checkTFModels:tfModels];
    
    if(!res) return [[TFModel alloc] init];
    
    //遍历
    for (TFModel *tfModel in tfModels) {
        if([tfModel.textField.text isEqualToString:@""]) return tfModel;
    }
    
    return nil;
}




-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //键盘退下
    [self.currentTFModel.textField resignFirstResponder];
    
    //清空数据
    self.window=nil;
    
    self.superVC=nil;
    
    self.scrollView=nil;
    
    self.tfModels=nil;
}


@end
