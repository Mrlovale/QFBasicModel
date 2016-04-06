//
//  BaseModelObject.m
//  Runtime对model的处理
//
//  Created by 赵大红 on 16/4/5.
//  Copyright © 2016年 赵大红. All rights reserved.
//

#import "BaseModelObject.h"
#import <objc/runtime.h>

@implementation BaseModelObject

static NSNumberFormatter *numberFormatter_;
+ (void)load
{
    numberFormatter_ = [[NSNumberFormatter alloc] init];
}

#pragma mark - init方法
+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([self propertyMapDic]) {
            [self assignPropertyWithMapDic:dic];
        } else {
            [self assignPropertyWithDic:dic];
        }
    }
    return self;
}

#pragma mark -- 把字典数据赋值给当前实体类的属性
- (void)assignPropertyWithDic:(NSDictionary *)dic
{
    if (!dic) return;
    
    // 1.取出字典中所有的key
    NSArray *keyArray = [dic allKeys];
    
    // 2.对实体模型进行赋值
    for (NSInteger i = 0; i < dic.count; i++) {
        
        // 2.1取出对应key对应的value
        NSString *key = keyArray[i];
        id value = dic[keyArray[i]];
        // 2.2将value转化成为property需要的数据并将value赋值给实体模型
        [self setPropertyValue:value withKey:key];
    
    }
    
}

#pragma 返回属性和字典key的映射关系
- (NSDictionary *)propertyMapDic
{
    return nil;
}

#pragma mark - 根据映射关系来给model属性赋值
- (void)assignPropertyWithMapDic:(NSDictionary *)dic
{
    // 1.获取字典和Model属性的映射关系
    NSDictionary *propertyDic = [self propertyMapDic];
    
    // 2.转化成key和property一样的字典，然后调用assginToPropertyWithDictionary方法
    NSArray *keyArray = [dic allKeys];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < dic.count; i++) {
        NSString *key = keyArray[i];
        // 如果propertyMapDic对应有值的话，则需要替换相应的key
        if (propertyDic[key]) {
            [tempDic setObject:dic[key] forKey:propertyDic[key]];
        } else {
            [tempDic setObject:dic[key] forKey:key];
        }
        
    }
    [self assignPropertyWithDic:tempDic];
    
}

#pragma mark - 将value转化成为property需要的数据并将value赋值给实体模型
- (void)setPropertyValue:(id)value withKey:(NSString *)key
{
    // 存储属性的个数
    unsigned int propertyCount = 0;
    
    // 通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    
    for (NSInteger i = 0; i < propertyCount; i++) {
        
        objc_property_t property = propertys[i];
        // 属性名称
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        // 如果属性名称与key相同
        if ([propertyName isEqualToString:key]) {
            // 属性应该的类型名  const char *propertyTypeName = getPropertyType(property);
            NSString *propertyTypeName = [NSString stringWithUTF8String:getPropertyType(property)];
            NSLog(@"%@",propertyTypeName);
            
            id newValue;
            // 如果是基本数据类型
            if ([self checkBasicType:propertyTypeName] || [propertyTypeName isEqualToString:@"NSNumber"]) {
                if ([value isKindOfClass:[NSString class]]) {
                    newValue = [numberFormatter_ numberFromString:(NSString *)value];
                    if (!newValue) {
                        newValue = @0;
                    }
                } else if ([value isKindOfClass:[NSNumber class]]) {
                    newValue = value;
                } else {
                    newValue = @0;
                    
                }
            } else if ([propertyTypeName isEqualToString:@"NSString"]) {
                if ([value isKindOfClass:[NSString class]]) {
                    newValue = value;
                } else {
                    newValue = [NSString stringWithFormat:@"%@",value];
                }
            } else {
                newValue = value;
            }
            
            [self setValue:newValue forKey:key];
        }
        
        
    }
    
    // 释放
    free(propertys);
}

// 这边只对基本数据类型NSInteger int double float BOOL进行处理
- (BOOL)checkBasicType:(NSString *)propertyTypeName
{
    NSString *p = propertyTypeName;
    if ([p isEqualToString:@"q"] || [p isEqualToString:@"i"] ||[p isEqualToString:@"d"] ||[p isEqualToString:@"f"] ||[p isEqualToString:@"B"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 解析Property的Attributed字符串，参考Stackoverflow
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        // 非对象类型
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // 利用NSData复制一份字符串
            return (const char *) [[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
            // 纯id类型
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return "id";
            // 对象类型
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            return (const char *) [[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}



@end
