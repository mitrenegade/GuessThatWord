//
//  Deck+EasyMapping.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "Deck.h"
#import <EasyMapping.h>
#import "BaseObject+EasyMapping.h"

@interface Deck (EasyMapping)
+(Deck *)parseMembrightInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)moc;

@end
