//
//  Car.m
//  ChineseChess
//


#import "Car.h"
#import "ChessBoard.h"
@implementation Car


- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        if(offensiveType ==kBlack)
            _name=@"車";
        else
            _name=@"俥";
    }
    return self;
}

-(BOOL)canMoveTo:(Position)target chessboard:(ChessBoard *)chessboard{
    int stepX=abs(target.x-_position.x);
    int stepY=abs(target.y-_position.y);
    if (((stepX==0)&&(stepY!=0))||((stepY==0)&&(stepX!=0))){
        return YES;
    }
    else{
        NSLog(@"不是按直線走");
        return NO;

    }
}
@end
