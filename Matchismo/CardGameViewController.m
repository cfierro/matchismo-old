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

/*  The UI actually needs a label, but the text for this label is generated in CardMatchingGame.
    CardMatchingGame keeps a history of the game and this is definitely part of the model. The label
    is just a means to display the game history.
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *matchMode;
@property (strong, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.jpeg"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.layer.cornerRadius = 6;
            cardButton.clipsToBounds = YES;
        }
        else
            [cardButton setImage:nil forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.5 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.descriptionLabel.text = [self.game.gameHistory lastObject];
    self.descriptionLabel.alpha = 1.0;
    self.historySlider.value = 1.0;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.game.matchMode = self.matchMode.selectedSegmentIndex + 2;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.matchMode.enabled = NO;
    [self updateUI];
}

- (IBAction)reDeal:(UIButton *)sender
{
    self.flipCount = 0;
    self.game = nil;
    self.matchMode.selectedSegmentIndex = 0;
    self.matchMode.enabled = YES;
    for (UIButton *cardButton in self.cardButtons) {
        cardButton.selected = NO;
        cardButton.enabled = YES;
        cardButton.alpha = 1.0;
    }
    [self updateUI];
    self.descriptionLabel.text = @"Flip card to play!";
}

- (IBAction)viewHistory:(UISlider *)sender
{
    if ([self.game.gameHistory count]) {
        int index = sender.value * ([self.game.gameHistory count] - 1);
        self.descriptionLabel.text = [self.game.gameHistory objectAtIndex:index];
        self.descriptionLabel.alpha = 0.5;
        self.historySlider.value = sender.value;
    }
}

@end
