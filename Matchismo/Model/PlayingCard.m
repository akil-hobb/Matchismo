//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kaushik vijayaraghavan on 03/06/13.
//  Copyright (c) 2013 AIS. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;


//method works for both 2 card matches and 3 card matches
-(int) match:(NSArray *)otherCards {
    int score=0;
    
    if(otherCards.count ==1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if([otherCard.suit isEqualToString:self.suit]){
            score=1;
        } else if(otherCard.rank == self.rank) {
            score=4;
        }
    }
    
    if(otherCards.count ==2) {
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard =[otherCards objectAtIndex:1];
        if([firstCard.suit isEqualToString:self.suit]) {
            if([secondCard.suit isEqualToString:self.suit]) {
                score = 2; //0.01294117647
            }
        }else if (firstCard.rank==self.rank)
        {
            if(secondCard.rank==self.rank)
            score = 5; //0.04166666666
        }
    }
    
    
    return score;
}


-(NSString*) contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}


+(NSArray *) validSuits {
    return @[@"♣",@"♦",@"♥",@"♠"];
}


-(void) setSuit:(NSString *)suit {
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
    
}

-(NSString *) suit {
    return _suit ? _suit : @"?";
}

+(NSArray*) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    
}

+(NSUInteger) maxRank {
    return [self rankStrings].count-1;
}


-(void) setRank:(NSUInteger)rank {
    
    if(rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
