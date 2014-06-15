//
//  ChessBoard.h
//  ObjC_Chess
//


#import <Foundation/Foundation.h>
#import "Common.h"
@class Chessman;
@protocol ChessboardDelegate;

@interface ChessBoard : NSObject{
    id<ChessboardDelegate> _delegate;
    Chessman *_items[10][9];
    OffensiveType _currentOffensive;
    Chessman *_selectedChessman;
}

@property (nonatomic,assign) id<ChessboardDelegate> delegate;
@property (readonly) Chessman *selectedChessman;
@property (readonly) OffensiveType currentOffensive;

- (void) reset;
- (Chessman *)_items:(int)x y:(int)y;
- (Chessman *) chessmanAtPosition:(Position) pos;

- (void) setSelectedChessmanAtPosition:(Position) pos;
- (void) moveSelectedChessmanTo:(Position) target;
- (void)removeAndReplaceItem:(Position)from :(Position) target;
@end

@protocol ChessboardDelegate <NSObject>

- (void) chessboard:(ChessBoard *)chessboard didSelectChessman:(Chessman *) selectedChessman deselectChessman:(Chessman *) deselectedChessman;
- (void) chessboard:(ChessBoard *)chessboard moveChessman:(Chessman *)chessman from:(Position) from to:(Position) target killedChessman:(Chessman *)killedChessman;

@end
