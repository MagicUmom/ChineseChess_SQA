//
//  SingletonObject.m
//  ChineseChess
//
//  Created by WeiKang on 2014/6/5.
//  Copyright (c) 2014年 tanghuacheng.cn. All rights reserved.
//

#import "SingletonObject.h"

@implementation SingletonObject


//宣告一個靜態的SingletonObject物件
static SingletonObject *_singletonObject = nil;

- (id)init {
    self = [super init];
    if (self) {
        
        S_token =@"";
        S_GameID=@"";
        First =YES;
        OnlineMode = FALSE;
        moveTaget = FALSE;
        winner = nil;
        gameOver = FALSE;
    }
    
    return self;
}

//執行時會判斷是否_singletonObject已經完成記憶體配置
+ (SingletonObject *)sharedSingletonObject {
    
    @synchronized([SingletonObject class]) {
        
        //判斷_singletonObject是否完成記憶體配置
        if (!_singletonObject)
            [[self alloc] init];
        
        return _singletonObject;
    }
    
    return nil;
}

+ (id)alloc {
    @synchronized([SingletonObject class]) {
        
        //避免 [SingletonObject alloc] 方法被濫用
        NSAssert(_singletonObject == nil, @"_singletonObject 已經做過記憶體配置");
        _singletonObject = [super alloc];
        
        return _singletonObject;
    }
    
    return nil;
}


- (void)editToken:(NSString *)str{
    S_token = str;
}

- (void)editGameID:(NSString *)str{
    S_GameID = str;
}

- (void)editOpID:(NSString *)str{
    S_opID = str;
}
- (void)editFirst:(BOOL)value{
    First = value;
}
- (BOOL)getFirst{
    return First;
}

- (NSString*)getToken{
    return S_token;
}
- (NSString*)getGameID{
    return S_GameID;
}
- (NSString*)getOpID;
{
    return S_opID;
}

- (void) setConnect:(NSInputStream *)iStream :(NSOutputStream *)oStream{
    
    S_iStream = iStream;
    S_oStream = oStream;
    
}

- (NSOutputStream *)getOutStream
{
    return S_oStream;
}

-(NSInputStream *)getInStream
{
    return S_iStream;
}
-(void)editAfterPosition:(Position)P
{
    after_Position =P;
}
-(void)editBeforePosition:(Position)P
{
    before_Position = P;
}
-(Position)getAfterPosition
{
    return after_Position;
}

- (Position)getBeforePosition
{
    return before_Position;
}

- (void)editOnlineMode:(BOOL)Flag
{
    OnlineMode =Flag;
}

- (BOOL)getOnlineMode
{
    return OnlineMode;
}

- (void)editMoveTarget:(BOOL)Flag
{
    moveTaget = Flag;
}

- (BOOL)getMoveTarget
{
    return moveTaget;
}

- (void)editGameOver :(BOOL) ifOver :(BOOL) redIsYes_blackIsNo
{
    gameOver = ifOver;
    winner = redIsYes_blackIsNo;
}
- (BOOL)getGameOver
{
    return gameOver;
}
- (BOOL)getWinner
{
    return winner;
}

-(void)connectToServer
{

    NSString *ip = @"140.134.208.82";
    //  NSString *ip = @"127.0.0.1";
    
    NSInteger port = 5566;
    
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)ip, port, &readStream, &writeStream);
    if (readStream && writeStream) {
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        S_iStream = (__bridge NSInputStream *)readStream;
        
        [S_iStream setDelegate:self];
        [S_iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [S_iStream open];
        
        S_oStream = (__bridge NSOutputStream *)writeStream;
        [S_oStream setDelegate:self];
        [S_oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [S_oStream open];
    }

}

@end
