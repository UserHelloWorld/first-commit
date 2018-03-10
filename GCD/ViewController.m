//
//  ViewController.m
//  GCD
//
//  Created by apple on 07/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ViewController1.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *identifier = @"cell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self globalQueue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ggg:) name:@"ddd" object:nil];
}
- (void)ggg:(NSNotification *)noti {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    self.lab.text = noti.object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"dssd");
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController1 *vc = [[ViewController1 alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
// 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}


- (void)globalQueue {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"aa  = %@",[NSThread currentThread]);
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"bb  = %@",[NSThread currentThread]);
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 5; i ++) {
            NSLog(@"cc  = %@",[NSThread currentThread]);
        }
    });
}

- (void)syncMainSerial {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (int i = 0; i < 10 ; i++) {
            NSLog(@"%d",i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10 ; i++) {
            NSLog(@"%d",i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10 ; i++) {
            NSLog(@"%d",i);
        }
    });
}

// 同步并发
- (void)concurrentSync {
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("dslkl", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"aa %d %@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"bb %d %@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"cc %d %@",i,[NSThread currentThread]);
        }
    });
    
    
}

// 同步串行
- (void)serialSync {
    
    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"begin");
    dispatch_queue_t queue = dispatch_queue_create("dslk", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i = 0; i< 10; i++) {
            NSLog(@"i=%d aa=%@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 10; i++) {
            NSLog(@"i=%d bb=%@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 10; i++) {
            NSLog(@"i=%d cc=%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"end");
}
// 异步串行
- (void)serialAsync {
    dispatch_queue_t queue = dispatch_queue_create("dslk", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"aa %d = %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"bb %d = %@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"cc %d = %@",i,[NSThread currentThread]);
        }
        [self hhhhh];
    });
    NSLog(@"end %@",[NSThread currentThread]);
}

- (void)hhhhh{
    NSLog(@"hhhhh %@",[NSThread currentThread]);
}

// 异步并发
- (void)concurrentAsync {
    dispatch_queue_t queue = dispatch_queue_create("dadsd", DISPATCH_QUEUE_CONCURRENT);
   
    NSLog(@"begin");
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"aa--%d %@",i,[NSThread currentThread]);

        }
      
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"bb--%d %@",i,[NSThread currentThread]);
        }
        
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"cc--%d %@",i,[NSThread currentThread]);
        }
       

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"aaa");
            
            for (int b = 0; b < 3; b++) {
                NSLog(@"aaa=%d",b);
            }
        });
        
        NSLog(@"=======");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"bbb");
            for (int b = 0; b < 100; b++) {
                NSLog(@"bbb=%d",b);
            }
        });
        
        NSLog(@"=======");

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"ccc");
            for (int b = 0; b < 3; b++) {
                NSLog(@"ccc=%d",b);
            }
        });
        NSLog(@"========");
        for (int i = 0; i < 100; i++) {
            NSLog(@"fff %d",i);
        }
    });
    NSLog(@"end");
    
}


@end
