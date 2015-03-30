//
//  Card+EasyMapping.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/30/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "Card.h"
#import "BaseObject+EasyMapping.h"

@interface Card (EasyMapping)

+(Card *)parseMembrightInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)moc;

@end
