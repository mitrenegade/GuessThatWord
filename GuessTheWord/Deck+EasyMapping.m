//
//  Deck+EasyMapping.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "Deck+EasyMapping.h"

@implementation Deck (EasyMapping)

+(NSMutableDictionary *)mappedProperties {
    return @{@"name":@"title"};
}
@end
