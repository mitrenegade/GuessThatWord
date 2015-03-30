//
//  MenuViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "MenuViewController.h"
#import "Util.h"
#import "BaseObject+EasyMapping.h"
#import "Card+EasyMapping.h"

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
    [self.fetchController performFetch:nil];

    NSLog(@"Reloading decks: %d decks", [self.fetchController.fetchedObjects count]);
    [self.tableView reloadData];
}

#pragma mark NSFetchedResultsController 

-(NSFetchedResultsController *)fetchController {
    if (fetchController) {
        return fetchController;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Deck"];
    NSSortDescriptor *sortBySource = [[NSSortDescriptor alloc] initWithKey:@"source" ascending:YES];
    NSSortDescriptor *sortByID = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[sortBySource, sortByID];
    fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_appDelegate.managedObjectContext sectionNameKeyPath:@"source" cacheName:nil];
    [fetchController performFetch:nil];

    return fetchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.fetchController.sections count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[section-1];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        cell.textLabel.text = @"Create a new deck";
    }
    else {
        if (section - 1 <= self.fetchController.sections.count) {
            id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchController.sections[section-1];
            if (row < [sectionInfo numberOfObjects]) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
                Deck *deck = [self.fetchController objectAtIndexPath:newIndexPath];
                cell.textLabel.text = deck.title;
                if (!deck.title) {
                    cell.textLabel.text = @"Untitled deck";
                }
            }
        }
    }
    // Configure the cell...
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }

    NSArray *titles = @[@"", @"HeadsUp decks", @"Membright decks"];
    return titles[section];
}


#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        NSLog(@"create a new deck");
        [self.editDeckController createNewDeck];
    }
    else if (indexPath.section-1 < self.fetchController.sections.count) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        NSLog(@"viewing deck %@", newIndexPath);
        Deck *deck = [self.fetchController objectAtIndexPath:newIndexPath];
        [self.editDeckController editDeck:deck];
    }
}
@end
