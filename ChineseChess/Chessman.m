//
//  Chessman.m
//  ObjC_Chess


#import "Chessman.h"
#import "ChessBoard.h"

@implementation Chessman

@synthesize offensiveType=_offensiveType;
@synthesize name=_name;
@synthesize position=_position;
@synthesize chessboard=_chessboard;

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if(self=[super init]){
        _offensiveType=offensiveType;
    }
    return self;
}

- (BOOL)canMoveTo:(Position)target  chessboard:(ChessBoard *)chessboard{
    return YES;
}

- (void)moveTo:(Position)target{
    _position = target;    
}

@end
