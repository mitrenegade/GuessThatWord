//
//  RootSplitViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "RootSplitViewController.h"
#import "EditDeckViewController.h"
#import "MenuViewController.h"

@interface RootSplitViewController ()

@end

@implementation RootSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UINavigationController *nav = self.viewControllers[0];
    self.menuController = (MenuViewController *)nav.topViewController;
    self.editDeckController = self.viewControllers[1];

    self.menuController.editDeckController = self.editDeckController;

    [self listenFor:@"deck:play" action:@selector(playDeck:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)playDeck:(NSNotification *)n {
    NSDictionary *userInfo = n.userInfo;
    Deck *deck = userInfo[@"deck"];
    if (!deck) {
        return;
    }

    PlayViewController *controller = [_storyboard(@"Main") instantiateViewControllerWithIdentifier:@"PlayViewController"];
    controller.delegate = self;
    controller.deck = deck;

    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark PlayViewDelegate
-(void)stopPlaying {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
