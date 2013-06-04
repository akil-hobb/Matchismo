//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kaushik vijayaraghavan on 03/06/13.
//  Copyright (c) 2013 AIS. All rights reserved.
//

#import "CardMatchingGame.h"


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
    if(!_actionElements) _actionElements=[[NSMutableArray alloc]initWithObjects:@"?",@"?",@"?", nil];
    return _actionElements;
}

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


-(Card *)cardAtIndex:(NSUInteger)index {
    return (index< self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(void) flipCardAtIndex:(NSUInteger)index {
    NSNumber *tempScore;
    Card *card = [self cardAtIndex:index];
    [self.actionElements replaceObjectAtIndex:0 withObject:card.contents];
    
    if(!card.isUnplayable) {
        if(!card.isFaceUp) {
             self.lastAction = @"Flip";
            for(Card *otherCard in self.cards)
            {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    
                    
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
                    [self.actionElements replaceObjectAtIndex:2 withObject:tempScore];
                    break;
                    
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
        
        
    }
    
}


@end
