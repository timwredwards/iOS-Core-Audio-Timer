//
//  ViewController.h
//  SuperTimerTest
//
//  Created by Timothy Edwards on 20/12/2014.
//  Copyright (c) 2014 Timothy Edwards. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SuperTimer.h"

@interface ViewController : UIViewController

// Supertimer must be used as retain... The instance needs to exist as long as the timer is running!
// You can manually release it later if you're finished using it.
@property (retain) SuperTimer *superTimer;
@property (retain) SuperTimer *superTimer2;
@property (retain) SuperTimer *superTimer3;

@end