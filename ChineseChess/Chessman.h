//
//  Chessman.h
//  ObjC_Chess
//


#import <Foundation/Foundation.h>
#import "Common.h"
@class ChessBoard;

@interface Chessman : NSObject{
    NSString *_name;
    Position _position;
    OffensiveType _offensiveType;
    ChessBoard *_chessboard;
}
@property (readonly) OffensiveType offensiveType;
@property (readonly) NSString *name;
@property (nonatomic,assign) Position position;
@property (nonatomic,assign) ChessBoard *chessboard;

- (id) initWithOffensiveType:(OffensiveType) offensiveType;

- (BOOL) canMoveTo:(Position) target chessboard:(ChessBoard *)chessboard;
- (void) moveTo:(Position) target;

@end
