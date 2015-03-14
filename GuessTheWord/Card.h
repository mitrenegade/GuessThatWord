//
//  Card.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deck;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Deck *deck;

@end
