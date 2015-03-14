//
//  PlayViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self resetDeck];
}

-(void)resetDeck {
    self.labelTime.text = @"0";
    self.labelWord.text = @"";
    self.labelMessage.text = @"Ready to start";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickButton:(id)sender {
    if (sender == self.buttonQuit) {
        if ([self.delegate respondsToSelector:@selector(stopPlaying)]) {
            [self.delegate stopPlaying];
        }
    }
}
@end
