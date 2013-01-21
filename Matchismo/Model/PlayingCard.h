//
//  PlayingCard.h
//  Matchismo
//
//  Created by Carlos Fierro on 1/14/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
