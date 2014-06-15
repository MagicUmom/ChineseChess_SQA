//
//  ChessBoard.m
//  ObjC_Chess


#import "ChessBoard.h"
#import "Horse.h"
#import "Elephant.h"
#import "Car.h"
#import "Soldier.h"
#import "Cool.h"
#import "Gun.h"
#import "Arms.h"
#import "SingletonObject.h"
@implementation ChessBoard

@synthesize delegate=_delegate;
@synthesize selectedChessman=_selectedChessman;
@synthesize currentOffensive=_currentOffensive;

- (id)init{
    if (self=[super init]) {
        for (int y=0; y<10; y++) {
            for (int x=0; x<9; x++) {                
                _items[y][x]=nil;                      
            }
        }
    }
    return self;
}
- (void)dealloc{
    [super dealloc];
}

- (void)reset{
    for (int y=0; y<10; y++) {
        for (int x=0; x<9; x++) {
            if (_items[y][x]!=nil) {
                [_items[y][x] release];
                _items[y][x]=nil;
            }            
        }
    }
    BOOL isFirst =[[SingletonObject sharedSingletonObject]getFirst];
    _currentOffensive=isFirst?kRed:kBlack;
    _selectedChessman=nil;
    
    //Black
    _items[0][0]=[[Car alloc]initWithOffensiveType:kBlack];
    _items[0][8]=[[Car alloc]initWithOffensiveType:kBlack];

    _items[0][1]=[[Horse alloc] initWithOffensiveType:kBlack];
    _items[0][7]=[[Horse alloc] initWithOffensiveType:kBlack];
    _items[0][2]=[[Elephant alloc] initWithOffensiveType:kBlack];
    _items[0][6]=[[Elephant alloc] initWithOffensiveType:kBlack];
    _items[0][3]=[[Soldier alloc]initWithOffensiveType:kBlack];
    _items[0][5]=[[Soldier alloc]initWithOffensiveType:kBlack];
    _items[0][4]=[[Cool alloc]initWithOffensiveType:kBlack];
    _items[2][1]=[[Gun alloc]initWithOffensiveType:kBlack];
    _items[2][7]=[[Gun alloc]initWithOffensiveType:kBlack];
    _items[3][0]=[[Arms alloc]initWithOffensiveType:kBlack];
    _items[3][2]=[[Arms alloc]initWithOffensiveType:kBlack];
    _items[3][4]=[[Arms alloc]initWithOffensiveType:kBlack];
    _items[3][6]=[[Arms alloc]initWithOffensiveType:kBlack];
    _items[3][8]=[[Arms alloc]initWithOffensiveType:kBlack];

    //Red
    _items[9][0]=[[Car alloc]initWithOffensiveType:kRed];
    _items[9][8]=[[Car alloc]initWithOffensiveType:kRed];
    _items[9][1]=[[Horse alloc] initWithOffensiveType:kRed];
    _items[9][7]=[[Horse alloc] initWithOffensiveType:kRed];
    _items[9][2]=[[Elephant alloc] initWithOffensiveType:kRed];
    _items[9][6]=[[Elephant alloc] initWithOffensiveType:kRed];
    _items[9][3]=[[Soldier alloc]initWithOffensiveType:kRed];
    _items[9][5]=[[Soldier alloc]initWithOffensiveType:kRed];
    _items[9][4]=[[Cool alloc]initWithOffensiveType:kRed];
    _items[7][1]=[[Gun alloc]initWithOffensiveType:kRed];
    _items[7][7]=[[Gun alloc]initWithOffensiveType:kRed];
    _items[6][0]=[[Arms alloc]initWithOffensiveType:kRed];
    _items[6][2]=[[Arms alloc]initWithOffensiveType:kRed];
    _items[6][4]=[[Arms alloc]initWithOffensiveType:kRed];
    _items[6][6]=[[Arms alloc]initWithOffensiveType:kRed];
    _items[6][8]=[[Arms alloc]initWithOffensiveType:kRed];

    for (int y=0; y<10; y++) {
        for (int x=0; x<9; x++) {
            if (_items[y][x]!=nil) {
                _items[y][x].position=PositionMake(x, y);
                _items[y][x].chessboard=self;
            }
        }
    }
}

- (Chessman *)chessmanAtPosition:(Position)pos{
    return _items[pos.y][pos.x];
}

- (void)setSelectedChessmanAtPosition:(Position)pos{

    Chessman *chessman=[self chessmanAtPosition:pos];
    if (chessman!=nil) {
        if (chessman.offensiveType==_currentOffensive) {
            if (_selectedChessman!=chessman) {
                Chessman *temp=_selectedChessman;
                _selectedChessman=chessman;
                if (_delegate!=nil) {
                    [_delegate chessboard:self didSelectChessman:_selectedChessman deselectChessman:temp]; 
                }
            }
        }
    }
    //*****未寫入流程******
    if([[SingletonObject sharedSingletonObject]getOnlineMode]){
        [[SingletonObject sharedSingletonObject]editBeforePosition:pos];
    }
    //*****未寫入流程******

}

- (void)removeAndReplaceItem:(Position)from :(Position)target{
    _items[from.y][from.x]=nil;
    _items[target.y][target.x]=[self chessmanAtPosition:target];
}

- (void)moveSelectedChessmanTo:(Position)target{
    if (_selectedChessman!=nil) {
        if ([_selectedChessman canMoveTo:target chessboard:self]) {
            Chessman *killedChessman=[self chessmanAtPosition:target];
            Position from=_selectedChessman.position;
            [_selectedChessman moveTo:target];
            _items[from.y][from.x]=nil;
            _items[target.y][target.x]=_selectedChessman;
            if (_delegate!=nil) {
                [_delegate chessboard:self moveChessman:_selectedChessman from:from to:target killedChessman:killedChessman];
                //*****未寫入流程******

                //判斷被吃的是否為將/帥
                NSLog(@"被吃了:%@",killedChessman.name);
                
                if( [killedChessman.name isEqualToString:[NSString stringWithUTF8String:"帥"]] || [killedChessman.name isEqualToString:[NSString stringWithUTF8String:"將"]])
                {
                   if( [killedChessman.name isEqualToString:[NSString stringWithUTF8String:"帥"]])
                   {
                       [[SingletonObject sharedSingletonObject]editGameOver:YES :YES];
                   }
                    else
                    {
                        [[SingletonObject sharedSingletonObject]editGameOver:YES :NO];
                    }
                }
                //*****未寫入流程******

            }
            _selectedChessman=nil;
            if (killedChessman!=nil) {
                [killedChessman release];
            }
            //
        //*****未寫入流程******

            if (![[SingletonObject sharedSingletonObject]getOnlineMode]) {
                _currentOffensive=_currentOffensive==kRed?kBlack:kRed;
            }
            else
            {
                [[SingletonObject sharedSingletonObject]editMoveTarget:YES];
            }
        }
        else if ([[SingletonObject sharedSingletonObject]getOnlineMode]) {
                [[SingletonObject sharedSingletonObject]editMoveTarget:NO];
            }
        //*****未寫入流程******

    }
}
-(Chessman *)_items:(int)x y:(int)y{
    
    return _items[y][x];
}

@end
