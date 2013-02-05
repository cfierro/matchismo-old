//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Carlos Fierro on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (int number = 1; number <= MAX_NUMBER; number++) {
            for (int shape = 1; shape <= [SetCard numShapes]; shape++) {
                for (int shading = 0; shading < TOTAL_SHADINGS; shading++) {
                    for (int color = 0; color < TOTAL_COLORS; color++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shading = shading;
                        card.shape = shape;
                        card.number = number;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
