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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeControl;
@property (strong, nonatomic) NSMutableArray* movesList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISlider *reviewSlider;
@end

@implementation CardGameViewController

//Lazy instantiation of our model
-(CardMatchingGame*) game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

//Initial set up of cards on screen
-(void) setCardButtons:(NSArray *)cardButtons {
    
    _cardButtons = cardButtons;
    [self updateUI];
}

-(NSMutableArray*)movesList {
    if(!_movesList) _movesList = [[NSMutableArray alloc]initWithObjects:@"New Game Started!", nil];
    return _movesList;
}


- (IBAction)sliderChanged:(UISlider *)sender {
    NSNumber* a= [NSNumber numberWithFloat:sender.value];
    if([a integerValue]!=self.movesList.count)
    self.lastFlipLabel.text = [self.movesList objectAtIndex:[a integerValue]];
    
}



//UI updated according to the game logic
-(void) updateUI {
        
        self.reviewSlider.maximumValue = self.movesList.count;
        self.reviewSlider.value = self.movesList.count;
    
        for(UIButton *cardButton in self.cardButtons) {
            
            Card* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
            [cardButton setTitle:card.contents forState:UIControlStateSelected];
            [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
            UIImage* cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
            
            cardButton.selected = card.isFaceUp;
            cardButton.enabled = !card.isUnplayable;
            if(cardButton.selected)
            {[cardButton setImage:nil forState:UIControlStateNormal];
            }else {
                [cardButton setImage:cardBackImage forState:UIControlStateNormal];
                UIEdgeInsets titleInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
                [cardButton setImageEdgeInsets:titleInsets];
            }
            cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
       
            }
    
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
          
        NSString* temp;
    
        if([self.game.lastAction isEqualToString:@"Match"]) {
            
            if(self.gameTypeControl.selectedSegmentIndex==0)
            {
                temp = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[[self.game.actionElements objectAtIndex:3] intValue]];
            }
            else {
                temp = [NSString stringWithFormat:@"Matched %@-%@-%@ for %d points!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[self.game.actionElements objectAtIndex:2],[[self.game.actionElements objectAtIndex:3] intValue]];
            }
            
            [self.movesList addObject:temp];
            self.lastFlipLabel.text = temp;
        
        
            }
                else if([self.game.lastAction isEqualToString:@"Flip"]) {
                    temp = [NSString stringWithFormat:@"Flipped %@",[self.game.actionElements objectAtIndex:0]];
                    [self.movesList addObject:temp];
                    self.lastFlipLabel.text = temp;
                }
                    else if ([self.game.lastAction isEqualToString:@"Mismatch"]) {
                        
                        if(self.gameTypeControl.selectedSegmentIndex==0)
                        {
                         temp = [NSString stringWithFormat:@"%@ and %@ dont match! %d point penalty!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[[self.game.actionElements objectAtIndex:3] intValue]];
                        }
                        else {
                             temp = [NSString stringWithFormat:@"%@-%@-%@ dont match! %d point penalty!",[self.game.actionElements objectAtIndex:0],[self.game.actionElements objectAtIndex:1],[self.game.actionElements objectAtIndex:2],[[self.game.actionElements objectAtIndex:3] intValue]];
                        }
                        [self.movesList addObject:temp];
                        self.lastFlipLabel.text = temp;
                    }
    
}

//Resetting the game parameters
- (IBAction)dealNewGame:(UIButton *)sender {
    self.movesList = [[NSMutableArray alloc]initWithObjects:@"New Game Started!", nil];
    
    self.gameTypeControl.enabled = YES;
    self.flipCount = 0;
    self.scoreLabel.text =@"Score: 0";
    self.flipsLabel.text =@"Flips : 0";
    self.lastFlipLabel.text=@"";
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    
    [self updateUI];
    self.lastFlipLabel.text = @"New Game Started!";
}

//Flipcount label updates here
-(void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

//Actions on every flip
- (IBAction)flipCard:(UIButton *)sender {
    
    if(self.gameTypeControl.isEnabled) self.gameTypeControl.enabled = NO;
   
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] withGameType:self.gameTypeControl.selectedSegmentIndex ];
    
  
    
    self.flipCount++;
   
    [self updateUI];
    
    
}

@end
