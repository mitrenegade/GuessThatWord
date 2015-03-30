//
//  MenuViewController.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditDeckViewController.h"

@interface MenuViewController : UITableViewController
{
    NSFetchedResultsController *fetchController;
}

@property (weak, nonatomic) EditDeckViewController *editDeckController;

-(NSFetchedResultsController *)fetchController;
@end
