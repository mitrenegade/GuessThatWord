//
//  Card.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/30/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseObject.h"

@class Deck;

@interface Card : BaseObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Deck *deck;

@end
