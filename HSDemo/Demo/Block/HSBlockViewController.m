//
//  HSBlockViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//
/*
 1、什么是Block?
 Block是将函数及其执行上下文封装起来的对象；
 源码分析结构体中有isa指针，Block是对象的标志；
 在block括号中所定义的执行体最终就会产生一个函数，然后block通过一个函数指针来指向对应的函数实现；
 
 struct __block_impl{
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr; //函数指针
 }
 
 2、什么是Block调用？
 Block的调用即是函数的调用；
 
 3、截获变量
    基本数据类型（局部变量）：截获其值
    对象类型局部变量或成员变量：连同所有权修饰符（属性关键字）一起截获
    静态局部变量：以指针形式进行截获
    全局变量：不截获
    静态全局变量：不截获
 
 4、__block修饰符
 一般情况下，对被截获变量进行赋值操作需添加__block修饰符
 赋值并不等于使用
 
 5、对变量进行赋值时,
    需要__block修饰符
        局部变量
            基本数据类型
            对象类型
    不需要__block修饰符
        静态局部变量
        全局变量
        静态全局变量
 6、Block的内存管理
    类型：
        _NSConcreteGlobalBlock;
        _NSConcreteStackBlock;
        _NSConcreteMallocBlock;
 
    Block的copy操作
        Block类别                     源                copy结果
        _NSConcreteStackBlock        栈                堆
        _NSConcreteGlobalBlock       数据区（已初始化）   什么也不做
        _NSConcreteMallocBlock       堆                增加引用计数
 
 7、Block的循环引用
     当前Block对当前对像的某一个成员变量进行截获的话，此时Block会对当前变量有一个强引用。
     当前对象对Block又有一个强引用；
 
 */

#import "HSBlockViewController.h"
#import "HSBlock.h"

typedef int(^MyBlock)(int num);
typedef NSString*(^StrBlock)(NSString *num);

@interface HSBlockViewController ()

@property(nonatomic, copy)MyBlock myBlock;
@property(nonatomic, copy)StrBlock strBlk;
@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, assign)int var;

@end

@implementation HSBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self circularReference];
}

#pragma mark - 循环引用
- (void)circularReference{
    {
        /*
         分析：
         当前对象通过copy属性关键字对Block进行修饰，对Block有个强引用；
         在Block表达式中使用到了当前对象的array成员变量；
         
         self对象 -> 强引用Block -> 持有self
         
         解决方案：
            创建一个 __weak 修饰的变量或者说指针来指向原对象的array成员变量；
            对象类型的局部变量，连其所有权一起截获，内部也是__weak修饰，弱引用
         */
        _array = [NSMutableArray arrayWithObject:@"block"];
        __weak NSArray *weakArray = _array;
        _strBlk = ^NSString*(NSString *num){
            return [NSString stringWithFormat:@"hello_%@", weakArray[0]];
        };
        _strBlk(@"hello");
    }
    
    {
        /*
         在MRC下，不会产生循环引用；
         在ARC下，会产生循环引用，引起内存泄露；
         self -> 持有Block -> 持有__block变量 -> 持有self（强引用）
         */
        _var = 10;
        __block HSBlockViewController *blockSelf = self;
        _myBlock = ^int(int num){
            //return num * blockSelf.var;
            //ARC下，修改方案
            int result = num * blockSelf.var;
            blockSelf = nil; //断环，此种方法有弊端，长时间不调用Block的话，循环引用会一直存在。
            return result;
        };
        _myBlock(3);
    }
    
    
    
    
    
}

#pragma mark - 截获变量
- (void)interceptVariable{
    //笔试题的坑
    {
        NSMutableArray *array = [NSMutableArray array];
        void(^Block)(void) = ^{
            [array addObject:@"123"]; //使用并不是赋值
        };
        Block();
    }
    
    {
        __block NSMutableArray *array = nil;
        void(^Block)(void) = ^{
            array = [NSMutableArray array]; //赋值 使用__block修饰
        };
        Block();
    }
    
    {
        /*
         1、__block 修饰的变量最终变成了对象
         
         2、__block int multiplier 最终变成了以下结构体
            {
                struct _Block_byref_multiplier_0{
                    void *__isa; //对象才有 isa 指针
                    __Block_byref_multiplier_0*__forwarding; //指向同类型的指针
                    int__flags;
                    int__size;
                    int multiplier; //成员变量，函数中所定义的局部变量
                }
            }
         
         3、multiplier = 4; 经过编译器编译后实际操作如下：
            (multiplier._forwarding->multiplier) = 4;
            分析：
            通过multiplier对象中的__forwarding指针找到对应的一个对象，对其成员变量multiplier进行赋值；
            Block在栈上时：__forwarding指针实际指向的就是__block变量自己；
            Block在堆上时：__forwarding指针实际指向其它地方；
         
         4、__forwarding 指针式用来干什么的？
            不论在任何内存位置，都可以顺利的通过__forwarding指针访问同一个__block变量。
         
         
         
         */
        __block int multiplier = 6;
        int(^Block)(int) = ^int(int num){
            return num * multiplier;
        };
        multiplier = 4;
        NSLog(@"result is %d", Block(2));
    }
    
    {
        __block int multiplier = 10;
        _myBlock = ^int(int num){
            return num * multiplier;
        };
        multiplier = 6;
        [self executeBlock];
    }
    
    
    
}

- (void)executeBlock{
    int result = _myBlock(4);
    NSLog(@"%s result is %d", __func__, result);
    
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
