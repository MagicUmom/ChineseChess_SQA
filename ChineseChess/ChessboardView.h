//
//  BoardView.h
//  ChineseChess


#import <UIKit/UIKit.h>
#import "Common.h"
@class ChessmanView;
@class FlagView;
@protocol ChessboardViewDelegate;

@interface ChessboardView : UIView{
    id<ChessboardViewDelegate> _delegate;
    ChessmanView *_items[10][9];
    CGSize _gridSize;//棋盘格子的尺寸
    CGSize _offset;//棋盘{0,0}坐标的偏移尺寸
    CGSize _flagSize;//棋子标志线的尺寸
    float _flagPadding;//棋子标志线与棋盘线的填充尺寸
    UIColor *_lineColor;//棋盘线的颜色
    float _lineWidth;//棋盘线的宽度
    
    FlagView *_flagView;
}

@property (nonatomic,assign) id<ChessboardViewDelegate> delegate;
@property (nonatomic,retain) UIColor *lineColor;
@property (readonly) CGSize gridSize;

- (void) loadData;

- (void) selectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated;
- (void) deselectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated;
- (void) moveChessmanViewAtPosition:(Position) from to:(Position) target animated:(BOOL)animated;

@end

@protocol ChessboardViewDelegate <NSObject>
@required
- (ChessmanView *) chessboardView:(ChessboardView *) chessboardView chessmanViewAtPosition:(Position) pos;
- (void) chessboardView:(ChessboardView *) chessboardView touchAtPosition:(Position) pos;
@end
