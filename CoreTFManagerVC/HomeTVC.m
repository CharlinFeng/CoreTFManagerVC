//
//  HomeTVC.m
//  CoreTFManagerVC
//
//  Created by 沐汐 on 15-3-5.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "HomeTVC.h"
#import "NormalViewVC.h"
#import "ScrollViewVC.h"

@interface HomeTVC ()

@property (nonatomic,strong) NSArray *dataList;

@end

@implementation HomeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList=@[@"NormalView",@"ScrollView"];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *rid=@"rid";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    
    cell.textLabel.text=self.dataList[indexPath.row];
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *vcs=@[@"NormalViewVC",@"ScrollViewVC"];
    
    Class vcClass=NSClassFromString(vcs[indexPath.row]);
    
    UIViewController *vc=[[vcClass alloc] init];
    
    vc.title=self.dataList[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}








@end
