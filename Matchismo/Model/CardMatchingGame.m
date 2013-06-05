//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kaushik vijayaraghavan on 03/06/13.
//  Copyright (c) 2013 AIS. All rights reserved.
//

#import "CardMatchingGame.h"

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) NSString *lastAction;
@end

@implementation CardMatchingGame


-(NSMutableArray*) cards {
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

-(NSMutableArray*) actionElements {
    if(!_actionElements) _actionElements=[[NSMutableArray alloc]initWithObjects:@"?",@"?",@"?",@"?", nil];
    return _actionElements;
}

//Designated init method
-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    if(self)    {
        
        for(int i=0;i<cardCount;i++)
        {
            Card *card = [deck drawRandomCard];
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        
    }
    
    return  self;
}

//Fetches the card at the index specified
-(Card *)cardAtIndex:(NSUInteger)index {
    return (index< self.cards.count) ? self.cards[index] : nil;
}

//Flipping card at index with gametype 0 (two cards) or gametype 1 (three cards)
-(void) flipCardAtIndex:(NSUInteger)index withGameType:(int)type {
    
    
    Card *firstCard;
    
    Card *card = [self cardAtIndex:index];
    [self.actionElements replaceObjectAtIndex:0 withObject:card.contents];
    
    if(!card.isUnplayable) {
        if(!card.isFaceUp) {
             self.lastAction = @"Flip";
            for(Card *otherCard in self.cards)
            {
                NSNumber *tempScore;
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    if(type==0)   //TWO CARD GAME
                    {
                    
                    [self.actionElements replaceObjectAtIndex:1 withObject:otherCard.contents];

                    int matchScore = [card match:@[otherCard]];
                    if(matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        tempScore=  [NSNumber numberWithInt:matchScore * MATCH_BONUS];
                        self.score += [tempScore intValue];
                        self.lastAction = @"Match";
                        
                        }   else {
                                otherCard.faceUp = NO;
                                tempScore=  [NSNumber numberWithInt:MISMATCH_PENALTY];
                                self.score -= MISMATCH_PENALTY;
                                self.lastAction = @"Mismatch";
                            }
                    [self.actionElements replaceObjectAtIndex:3 withObject:tempScore];
                    break;
                    }
                    else if(type==1)  //THREE CARD GAME
                    {
                        if(!firstCard)
                        {
                            firstCard = otherCard;
                            [self.actionElements replaceObjectAtIndex:1 withObject:firstCard.contents];
                        }
                        else
                        {
                            [self.actionElements replaceObjectAtIndex:2 withObject:otherCard.contents];
                            int matchscore=[card match:@[firstCard,otherCard]];
                            
                            if(matchscore)
                            {   firstCard.unplayable = YES;
                                otherCard.unplayable = YES;
                                card.unplayable = YES;
                                 tempScore=  [NSNumber numberWithInt:matchscore * MATCH_BONUS];
                                self.score +=  [tempScore intValue];
                                self.lastAction = @"Match";
                            }
                            else {
                                otherCard.faceUp = NO;
                                firstCard.faceUp = NO;
                                
                                 tempScore=  [NSNumber numberWithInt:MISMATCH_PENALTY];
                                self.score -= MISMATCH_PENALTY;
                               
                                self.lastAction = @"Mismatch";
                            }
                            [self.actionElements replaceObjectAtIndex:3 withObject:tempScore];
                            break;
                        }
                    }
                    
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
        if(!card.isFaceUp)
        {
            self.lastAction = @"";
        }
        
    }
    
}


@end
