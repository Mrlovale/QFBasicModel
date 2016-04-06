//
//  BaseModelObject.h
//  Runtime对model的处理
//
//  Created by 赵大红 on 16/4/5.
//  Copyright © 2016年 赵大红. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModelObject : NSObject

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
