//
//  UDGameScene.m
//  RRHeredox
//
//  Created by Rolandas Razma on 7/13/12.
//  Copyright UD7 2012. All rights reserved.
//

#import "RRGameScene.h"
#import "RRGameLayer.h"
#import "RRAIPlayer.h"
#import "RRPlayer.h"


@implementation RRGameScene


#pragma mark -
#pragma mark UDGameScene


+ (id)sceneWithGameMode:(RRGameMode)gameMode numberOfPlayers:(uint)numberOfPlayers firstPlayerColor:(RRPlayerColor)playerColor {
    return [[[self alloc] initWithGameMode:gameMode numberOfPlayers:numberOfPlayers playerColor:playerColor] autorelease];
}


- (id)initWithGameMode:(RRGameMode)gameMode numberOfPlayers:(uint)numberOfPlayers playerColor:(RRPlayerColor)playerColor {
    if( (self = [self init]) ){
        _numberOfPlayers = numberOfPlayers;
        RRGameLayer *gameLayer;
        
        if( [[UDGKManager sharedManager] isNetworkPlayActive] ){
            gameLayer = [RRGameLayer layerWithGameMode:gameMode firstPlayerColor:RRPlayerColorWhite];
            
            // Host is player1
            if( [[UDGKManager sharedManager] isHost] ){
                RRPlayer *player1 = [RRPlayer playerWithPlayerColor: playerColor];
                [gameLayer setPlayer1:player1];
                
                RRPlayer *player2 = [RRPlayer playerWithPlayerColor: ((playerColor == RRPlayerColorBlack)?RRPlayerColorWhite:RRPlayerColorBlack)];
                [gameLayer setPlayer2:player2];
            }else{
                RRPlayer *player1 = [RRPlayer playerWithPlayerColor: ((playerColor == RRPlayerColorBlack)?RRPlayerColorWhite:RRPlayerColorBlack)];
                [gameLayer setPlayer1:player1];
                
                RRPlayer *player2 = [RRPlayer playerWithPlayerColor: playerColor];
                [gameLayer setPlayer2:player2];
            }
            
            // Update ID's for player
            for( GKPlayer *player in [[[UDGKManager sharedManager] players] allValues] ){
                if( [player.playerID isEqualToString:[[UDGKManager sharedManager] hostPlayerID]] ){
                    [gameLayer.player1 setPlayerID: player.playerID];
                }else{
                    [gameLayer.player2 setPlayerID: player.playerID];
                }
            }
        }else if( NO ){ // AI vs AI
            gameLayer = [RRGameLayer layerWithGameMode:gameMode firstPlayerColor: RRPlayerColorWhite];
            [gameLayer setPlayer1: [RRPlayer playerWithPlayerColor:playerColor]];
            
            {
                RRAIPlayer *player = [RRAIPlayer playerWithPlayerColor: RRPlayerColorWhite];
                [player setDificultyLevel: [[NSUserDefaults standardUserDefaults] integerForKey:@"RRHeredoxAILevel"]];
                [gameLayer setPlayer1: player];
            }
            
            {
                RRAIPlayer *player = [RRAIPlayer playerWithPlayerColor: RRPlayerColorBlack];
                [player setDificultyLevel: [[NSUserDefaults standardUserDefaults] integerForKey:@"RRHeredoxAILevel"]];
                [gameLayer setPlayer2: player];
            }
        }else{
            gameLayer = [RRGameLayer layerWithGameMode:gameMode firstPlayerColor:(( _numberOfPlayers == 1 )?RRPlayerColorWhite:playerColor)];
            [gameLayer setPlayer1: [RRPlayer playerWithPlayerColor:playerColor]];
            
            if( numberOfPlayers == 1 ){
                RRAIPlayer *player = [RRAIPlayer playerWithPlayerColor: ((playerColor == RRPlayerColorBlack)?RRPlayerColorWhite:RRPlayerColorBlack)];
                [player setDificultyLevel: [[NSUserDefaults standardUserDefaults] integerForKey:@"RRHeredoxAILevel"]];
                [gameLayer setPlayer2: player];
            }
        }
        
        [self addChild: gameLayer];
    }
    return self;
}


#pragma mark -
#pragma mark CCNode


- (void)onExitTransitionDidStart {
    [super onExitTransitionDidStart];
    [[RRAudioEngine sharedEngine] stopEffect: [NSString stringWithFormat:@"RRGameSceneNumberOfPlayers%u.mp3", _numberOfPlayers]];
}


- (void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    [[RRAudioEngine sharedEngine] replayEffect: [NSString stringWithFormat:@"RRGameSceneNumberOfPlayers%u.mp3", _numberOfPlayers]];
}


@end
