//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kaushik vijayaraghavan on 03/06/13.
//  Copyright (c) 2013 AIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(id) initWithCardCount :(NSUInteger) cardCount usingDeck:(Deck*) deck;
-(void) flipCardAtIndex: (NSUInteger) index;
-(Card*) cardAtIndex: (NSUInteger) index;
@property (nonatomic, readonly) NSString *lastAction;
@property (strong, nonatomic) NSMutableArray *actionElements;
@property (nonatomic, readonly) int score;

@end
