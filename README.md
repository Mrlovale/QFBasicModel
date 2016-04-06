# 字典转模型
简单的字典转模型工具

##简单用法
你的模型需要继承`BaseModelObject`，并且在最外面调用`[YourModel modelWithDic: dictionary]`方法即可
>1 如果字典跟模型字段对应，则直接调用。

>2 如果你的模型字段有跟字典不一样的，需要覆盖方法`- (NSDictionary *)propertyMapDic`并且需要将你不一样的地方传给返回值，具体请看demo

