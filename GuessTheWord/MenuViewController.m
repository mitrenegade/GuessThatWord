//
//  MenuViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "MenuViewController.h"
#import "Deck.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self reloadData];
    [self listenFor:@"decks:updated" action:@selector(updateDecks:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateDecks:(NSNotification *)n {
    [self reloadData];
}

-(void)reloadData {
    decks = [[Deck where:@{}] all];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return decks.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"Create a new deck";
    }
    else {
        if (row - 1 <= decks.count) {
            Deck *deck = decks[row-1];
            cell.textLabel.text = deck.title;
        }
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        NSLog(@"create a new deck");
        [self.editDeckController createNewDeck];
    }
    else if (indexPath.row-1 < decks.count) {
        Deck *deck = decks[indexPath.row-1];
        NSLog(@"editing deck %lu %@", indexPath.row-1, deck.title);
        [self.editDeckController editDeck:deck];
    }
}
@end
