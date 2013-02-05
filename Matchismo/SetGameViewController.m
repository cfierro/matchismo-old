//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Carlos Fierro on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "Deck.h"
#import "CardMatchingGame.h"
#import <QuartzCore/QuartzCore.h>

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@end

@implementation SetGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SetCardDeck alloc] init]];
        _game.matchMode = 3;
        _game.flipCost = 0;
        _game.mismatchPenalty = 3;
        _game.matchBonus = 6;
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
    UIImage *selectedImage = [UIImage imageNamed:@"lightgray.png"];
    UIImage *normalImage = [UIImage imageNamed:@"white.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (!card.isFaceUp && !card.isUnplayable) {
            [cardButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
            cardButton.layer.cornerRadius = 6;
            cardButton.clipsToBounds = YES;
        } else {
            [cardButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        [cardButton setAttributedTitle:card.contents forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;

    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.descriptionLabel.attributedText = [self lastTurn];
}

- (NSMutableAttributedString *)lastTurn
{
    NSMutableAttributedString *descriptionText = [[NSMutableAttributedString alloc] initWithString:@""];
    if ([self.game.lastCards count] == 0)
        return descriptionText;
    
    if (self.game.flipped) {
        return descriptionText;
        Card *flippedCard = self.game.lastCards[0];
        NSMutableAttributedString *flipped = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
        [descriptionText appendAttributedString:flipped];
        [descriptionText appendAttributedString:flippedCard.contents];
    }
    if (self.game.matched) {
        Card *cardOne = self.game.lastCards[0];
        Card *cardTwo = self.game.lastCards[1];
        Card *cardThree = self.game.lastCards[2];
        descriptionText = [descriptionText initWithString:[NSString stringWithFormat:@"Matched & & for %d points!", self.game.scoreChange]];
        int indexOne = [@"Matched & &" length];
        int indexTwo = [@"Matched &" length];
        int indexThree = [@"Matched" length];
        [descriptionText insertAttributedString:cardOne.contents atIndex:indexOne];
        [descriptionText insertAttributedString:cardTwo.contents atIndex:indexTwo];
        [descriptionText insertAttributedString:cardThree.contents atIndex:indexThree];
    } else {
        Card *cardOne = self.game.lastCards[0];
        Card *cardTwo = self.game.lastCards[1];
        Card *cardThree = self.game.lastCards[2];
        descriptionText = [descriptionText initWithString:[NSString stringWithFormat:@"& & don't match (-%d penalty)!", self.game.scoreChange]];
        int indexOne = [@"& &" length];
        int indexTwo = [@"&" length];
        int indexThree = [@"" length];
        [descriptionText insertAttributedString:cardOne.contents atIndex:indexOne];
        [descriptionText insertAttributedString:cardTwo.contents atIndex:indexTwo];
        [descriptionText insertAttributedString:cardThree.contents atIndex:indexThree];
    }
    return descriptionText;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)reDeal:(UIButton *)sender {
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
    self.descriptionLabel.text = @"Flip card to play";
}

@end
