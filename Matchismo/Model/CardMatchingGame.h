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

//method for flipping cards with a parameter for gametype chosen
-(void) flipCardAtIndex: (NSUInteger) index withGameType:(int) type;

-(Card*) cardAtIndex: (NSUInteger) index;

//string to describe the last move by the user
@property (nonatomic, readonly) NSString *lastAction;

//Array to help output strings depending upon last move
@property (strong, nonatomic) NSMutableArray *actionElements;

@property (nonatomic, readonly) int score;

@end
