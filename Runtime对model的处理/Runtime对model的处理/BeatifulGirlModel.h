//
//  BeatifulGirlModel.h
//  Runtime对model的处理
//
//  Created by 赵大红 on 16/4/5.
//  Copyright © 2016年 赵大红. All rights reserved.
//

#import "BaseModelObject.h"

@interface BeatifulGirlModel : BaseModelObject

@property(nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSNumber *age;
@property (nonatomic, strong)NSNumber *height;
@property (nonatomic, assign)NSInteger aaa;
@property (nonatomic, assign)int bbbb;
@property (nonatomic, assign)double ccc;
@property (nonatomic, assign)float ddd;
@property (nonatomic, assign)BOOL eee;
@property (nonatomic, strong)NSArray *imagesArray;

@end
