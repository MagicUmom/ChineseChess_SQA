//
//  Cool.m
//  ChineseChess
//


#import "Cool.h"
#import "ChessBoard.h"
@implementation Cool

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        if(offensiveType == kBlack)
            _name=@"將";
        else
            _name=@"帥";
    }
    return self;
}

-(BOOL)canMoveTo:(Position)target chessboard:(ChessBoard *)chessboard{
    int stepX=abs(target.x-_position.x);
    int stepY=abs(target.y-_position.y);
    if(((stepX==1)&&(stepY==0))||((stepX==0)&&(stepY==1))){
        return YES;
    }
    else{
        NSLog(@"不能那樣走");
        return NO;
        
    }
}

@end
