//
//  Query.h
//  GymPact
//
//  Created by Bobby Ren on 10/17/13.
//  Copyright (c) 2013 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Query : NSObject
{
    NSArray *predicates;
    NSArray *sortDescriptors;
}

-(id)initWithPredicates:(NSArray *)otherPredicates;

@property (nonatomic, strong) NSString *entityDescription;

-(Query *)where:(NSDictionary *)attributes;
-(Query *)lte:(NSDictionary *)attributes;
-(Query *)gte:(NSDictionary *)attributes;
-(Query *)not:(NSDictionary *)attributes;
-(Query *)null:(NSArray *)attributes;
-(NSArray *)all;
-(NSArray *)allObjectsInMOC:(NSManagedObjectContext *)moc;
-(Query *)ascending:(id)attribute;
-(Query *)descending:(id)attribute;
@end
