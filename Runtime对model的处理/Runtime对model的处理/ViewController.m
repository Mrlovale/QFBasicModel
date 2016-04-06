//
//  ViewController.m
//  Runtime对model的处理
//
//  Created by 赵大红 on 16/4/5.
//  Copyright © 2016年 赵大红. All rights reserved.
//

#import "ViewController.h"
#import "BeatifulGirlModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *dic = @{@"Name":@"lily",@"age":@23,@"height":@"ddd",@"aaa":@222,@"scdc":@"dcdds",
                          @"imagesArray": @[@"123",@"345",@"sdcd"]};
    BeatifulGirlModel *model = [BeatifulGirlModel modelWithDic:dic];
    
    NSLog(@"%zd",model.aaa);
}

@end
