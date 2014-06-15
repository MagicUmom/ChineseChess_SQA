//
//  Horse.m
//  ObjC_Chess
//


#import "Horse.h"
#import "ChessBoard.h"
@implementation Horse

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        if(offensiveType ==kBlack)
            _name=@"馬";
        else
            _name=@"傌";
    }
    return self;
}

- (BOOL)canMoveTo:(Position)target chessboard:(ChessBoard *)chessboard{
    int stepX=abs(target.x-_position.x);
    int stepY=abs(target.y-_position.y);
    if ((stepX==1&&stepY==2)||(stepX==2&&stepY==1)) {
        return YES;
    }
    else{
        NSLog(@"不是日字型");
        return NO;
    }
}


@end
