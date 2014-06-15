//
//  Elephant.m
//  ObjC_Chess
//


#import "Elephant.h"
#import "ChessBoard.h"
@implementation Elephant

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        if (offensiveType==kBlack) {
            _name=@"象";
        }
        else
            _name=@"相";
    }
    return self;
}
-(BOOL)canMoveTo:(Position)target chessboard:(ChessBoard *)chessboard{
    int stepX=abs(target.x-_position.x);
    int stepY=abs(target.y-_position.y);
    /*if ((([[chessboard _items:_position.y y:_position.x]offensiveType]==kRed&&target.y>4))||(([[chessboard  _items:target.y y:_position.y] offensiveType]==kBlack&&target.y<5))){*/
        if ((stepX==2&&stepY==2)||(stepX==2&&stepY==2)) {
            /*if([chessboard _items:(target.x+_position.x)/2 y:(target.y+_position.y)/2]==nil) {*/
                return YES;
            }
        else{
            NSLog(@"不是田字型");
            return NO;
        }
}

@end
