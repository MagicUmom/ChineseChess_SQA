//
//  ViewController.h
//  ChineseChess
//


#import <UIKit/UIKit.h>
#import "ChessboardView.h"
#import "ChessBoard.h"
#import "SingletonObject.h"


@interface ViewController : UIViewController<ChessboardViewDelegate,ChessboardDelegate,NSStreamDelegate>{
    ChessboardView *_chessboardView;
    ChessBoard *_chessboard;
    
    NSOutputStream *oStream;
    NSInputStream *iStream;
    Position optBefore;
    Position optAfter;
    BOOL myTurn;
    BOOL OnlineMode;
}

@end
