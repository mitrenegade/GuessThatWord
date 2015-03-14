//
//  RootSplitViewController.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;
@class EditDeckViewController;
@interface RootSplitViewController : UISplitViewController

@property (weak, nonatomic) MenuViewController *menuController;
@property (weak, nonatomic) EditDeckViewController *editDeckController;
@end
