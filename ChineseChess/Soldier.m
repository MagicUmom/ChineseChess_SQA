//
//  Soldier.m
//  ChineseChess
//


#import "Soldier.h"
#import "ChessBoard.h"
@implementation Soldier

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        if(offensiveType == kBlack)
            _name =@"士";
        else
            _name=@"仕";
    }
    return self;
}

-(BOOL)canMoveTo:(Position)target chessboard:(ChessBoard *)chessboard{
    int stepX=abs(target.x-_position.x);
    int stepY=abs(target.y-_position.y);
    if((stepX==1)&&(stepY==1)){
        if (target.x>2&&target.x<6&&(target.y<3||target.y>6)) {
        return YES;
    }
    else{
        NSLog(@"不能那樣走");
        return NO;
    }
}
    else{
        NSLog(@"不能那樣走");
        return NO;
    }
}
@end
