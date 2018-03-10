//
//  ViewController1.m
//  GCD
//
//  Created by apple on 10/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ddddddd%@",[NSThread currentThread]);
    });
    
    dispatch_queue_t queue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"aa%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"%d",[NSThread threadPriority]);
        }
    });
    for (int i = 0; i < 5; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"end");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    NSLog(@"%s %d",__func__,__LINE__);

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
