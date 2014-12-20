//
//  ViewController.m
//  SuperTimerTest
//
//  Created by Timothy Edwards on 20/12/2014.
//  Copyright (c) 2014 Timothy Edwards. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _superTimer = [[SuperTimer alloc] initWithInterval:44032 :^{
        NSLog(@"TICK");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end