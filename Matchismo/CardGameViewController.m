//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kaushik vijayaraghavan on 03/06/13.
//  Copyright (c) 2013 AIS. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController



-(CardMatchingGame*) game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


-(void) setCardButtons:(NSArray *)cardButtons {
    
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void) updateUI {
    
    for(UIButton *cardButton in self.cardButtons) {
        Card* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
       
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
          
        
     if([self.game.lastAction isEqualToString:@"Match"]) {
       
        NSString* temp = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[[self.game.actionElements objectAtIndex:2] intValue]];
        self.lastFlipLabel.text = temp;
        
        
        }
            else if([self.game.lastAction isEqualToString:@"Flip"]) {
                NSString *temp3 = [@"Flipped " stringByAppendingString:[self.game.actionElements objectAtIndex:0]];
                self.lastFlipLabel.text = temp3;
            }
            else if ([self.game.lastAction isEqualToString:@"Mismatch"]) {
                NSString* temp = [NSString stringWithFormat:@"%@ and %@ dont match! %d point penalty!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[[self.game.actionElements objectAtIndex:2] intValue]];
                self.lastFlipLabel.text = temp;
            }
    
}




-(void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    
   
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
  
    
    self.flipCount++;
   
    [self updateUI];
    
    
}


@end
