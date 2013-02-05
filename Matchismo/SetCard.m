//
//  SetCard.m
//  Matchismo
//
//  Created by Carlos Fierro on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([self validNumbers:otherCards] && [self validShapes:otherCards] &&
        [self validShadings:otherCards] && [self validColors:otherCards])
        score = 4;
    return score;
}

- (bool)validNumbers:(NSArray *)otherCards
{
    NSMutableArray *numbersArray = [[NSMutableArray alloc] init];
    for (SetCard *card in otherCards)
        [numbersArray addObject:[NSNumber numberWithInteger:card.number]];
    [numbersArray addObject:[NSNumber numberWithInteger:self.number]];
    if ([SetCard allNumbersSame:numbersArray] ||
        [SetCard allNumbersDifferent:numbersArray])
        return YES;
    return NO;
}

- (bool)validShapes:(NSArray *)otherCards
{
    NSMutableArray *numbersArray = [[NSMutableArray alloc] init];
    for (SetCard *card in otherCards)
        [numbersArray addObject:[NSNumber numberWithInteger:card.shape]];
    [numbersArray addObject:[NSNumber numberWithInteger:self.shape]];
    if ([SetCard allNumbersSame:numbersArray] ||
        [SetCard allNumbersDifferent:numbersArray])
        return YES;
    return NO;
}

- (bool)validShadings:(NSArray *)otherCards
{
    NSMutableArray *numbersArray = [[NSMutableArray alloc] init];
    for (SetCard *card in otherCards)
        [numbersArray addObject:[NSNumber numberWithInteger:card.shading]];
    [numbersArray addObject:[NSNumber numberWithInteger:self.shading]];
    if ([SetCard allNumbersSame:numbersArray] ||
        [SetCard allNumbersDifferent:numbersArray])
        return YES;
    return NO;
}

- (bool)validColors:(NSArray *)otherCards
{
    NSMutableArray *numbersArray = [[NSMutableArray alloc] init];
    for (SetCard *card in otherCards)
        [numbersArray addObject:[NSNumber numberWithInteger:card.color]];
    [numbersArray addObject:[NSNumber numberWithInteger:self.color]];
    if ([SetCard allNumbersSame:numbersArray] ||
        [SetCard allNumbersDifferent:numbersArray])
        return YES;
    return NO;
}

+ (bool)allNumbersSame:(NSMutableArray *)numbersArray
{
    for (int i = 1; i < [numbersArray count]; i++) {
        if ([numbersArray[0] intValue] != [numbersArray[i] intValue])
            return NO;
    }
    return YES;
}

+ (bool)allNumbersDifferent:(NSMutableArray *)numbersArray
{
    for (int i = 0; i < [numbersArray count]; i++) {
        for (int j = i + 1; j < [numbersArray count]; j++) {
            if ([numbersArray[i] intValue] == [numbersArray[j] intValue])
                return NO;
        }
    }
    return YES;
}

- (NSAttributedString *)contents
{
    NSString *str = @"";
    NSArray *shapeStrings = [SetCard shapeStrings];
    for (int i = 1; i <= self.number; i++)
        str = [str stringByAppendingString:shapeStrings[self.shape]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, [attrStr length]);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    UIColor *color;
    if (self.color == blue) color = [UIColor blueColor];
    else if (self.color == green) color = [UIColor greenColor];
    else color = [UIColor redColor];
    if (self.shading == filled) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    } else if (self.shading == empty) {
        [attrStr addAttribute:NSStrokeWidthAttributeName value:@4 range:range];
        [attrStr addAttribute:NSStrokeColorAttributeName value:color range:range];
    } else {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:0.2] range:range];
        [attrStr addAttribute:NSStrokeWidthAttributeName value:@-4 range:range];
        [attrStr addAttribute:NSStrokeColorAttributeName value:color range:range];
    }
    return attrStr;
}

+ (NSArray *)shapeStrings
{
    return @[@"?",@"●",@"▲",@"■"];
}

+ (NSUInteger)numShapes { return [self shapeStrings].count-1; }

@end
