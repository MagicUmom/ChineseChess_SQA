//
//  SingletonObject.h
//  ChineseChess
//
//  Created by WeiKang on 2014/6/5.
//  Copyright (c) 2014年 tanghuacheng.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@interface SingletonObject : NSObject<NSStreamDelegate>{
@private
    int count;
    NSString *S_token;
    NSString *S_GameID;
    NSString *S_opID;
    BOOL First;
    BOOL OnlineMode;
    BOOL moveTaget;
    BOOL gameOver;
    BOOL winner; // YES = red ,  NO = black
    
    Position before_Position;
    Position after_Position;
    
    
    NSInputStream *S_iStream;
    NSOutputStream *S_oStream;
}

//統一透過此函式來調用SingletonObject的方法
+ (SingletonObject *)sharedSingletonObject;


//
- (void)editToken:(NSString *)str;
- (NSString*)getToken;

- (void)editGameID:(NSString *)str;
- (NSString*)getGameID;

- (void)editOpID:(NSString *)str;
- (NSString*)getOpID;

- (void)editFirst:(BOOL)value;
- (BOOL)getFirst;
- (void)editBeforePosition:(Position)P;
- (void)editAfterPosition:(Position)P;
- (Position)getBeforePosition;
- (Position)getAfterPosition;
- (void)editOnlineMode :(BOOL) Flag;
- (BOOL)getOnlineMode ;
- (void)editMoveTarget :(BOOL) Flag;
- (BOOL)getMoveTarget;
- (void)editGameOver :(BOOL) ifOver :(BOOL) redIsYes_blackIsNo;
- (BOOL)getGameOver;
- (BOOL)getWinner;

-(void)setConnect:(NSInputStream *)iStream :(NSOutputStream *)oStream;

-(NSOutputStream *) getOutStream;
-(NSInputStream *) getInStream;
-(void)connectToServer;
@end
