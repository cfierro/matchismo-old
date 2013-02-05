//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Carlos Fierro on 1/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "Deck.h"
#import "CardMatchingGame.h"
#import <QuartzCore/QuartzCore.h>

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        _game.matchMode = 2;
        _game.flipCost = 1;
        _game.mismatchPenalty = 2;
        _game.matchBonus = 4;
    }
    return _game;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.jpg"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.layer.cornerRadius = 6;
            cardButton.clipsToBounds = YES;
        } else
            [cardButton setImage:nil forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.5 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.descriptionLabel.text = [self lastTurn];    
}

- (NSString *)lastTurn
{
    NSString *descriptionText;
    if ([self.game.lastCards count] == 0)
        return @"";
    if (self.game.flipped) {
        Card *flippedCard = self.game.lastCards[0];
        descriptionText = [NSString stringWithFormat:@"Flipped up %@", flippedCard.contents];
    } else if (self.game.matched) {
        Card *cardOne = self.game.lastCards[0];
        Card *cardTwo = self.game.lastCards[1];
        descriptionText = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!", cardOne.contents, cardTwo.contents, self.game.scoreChange];
    } else {
        Card *cardOne = self.game.lastCards[0];
        Card *cardTwo = self.game.lastCards[1];
        descriptionText = [NSString stringWithFormat:@"%@ and %@ don't match!\n%d point penalty!", cardOne.contents, cardTwo.contents, self.game.scoreChange];
    }
    return descriptionText;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)reDeal:(UIButton *)sender
{
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
    self.descriptionLabel.text = @"Flip card to play!";
}

@end
