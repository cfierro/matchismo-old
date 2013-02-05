//
//  SetCard.h
//  Matchismo
//
//  Created by Carlos Fierro on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

#define MAX_NUMBER 3
enum shadings {filled, shaded, empty, TOTAL_SHADINGS};
enum colors {blue, green, red, TOTAL_COLORS};

@interface SetCard : Card

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger number;

+ (NSUInteger)numShapes;

@end
