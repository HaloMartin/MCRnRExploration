//
//  ViewController.m
//  MCRuntimeExploration
//
//  Created by M君 on 02/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import "ViewController.h"


#pragma mark - Person
@interface Person : NSObject
@end
@implementation Person

- (void)eat{
    NSLog(@"Eating");
}

@end


#pragma mark - ViewController
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *p = [[Person alloc] init];
    [p eat];
    [p performSelector:@selector(run)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
