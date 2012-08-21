//
//  UDPickColorScene.h
//  RRHeredox
//
//  Created by Rolandas Razma on 7/14/12.
//  Copyright (c) 2012 UD7. All rights reserved.
//

#import "CCScene.h"


@interface RRPickColorScene : CCScene

+ (id)sceneWithNumberOfPlayers:(uint)numberOfPlayers;
- (id)initWithNumberOfPlayers:(uint)numberOfPlayers;
    
@end
