//
//  ViewController.m
//  ChineseChess

#define isIphone5 [[UIScreen mainScreen]bounds].size.height >500
#import "ViewController.h"
#import "ChessmanView.h"
#import "Chessman.h"
#import "ViewController2.h"
@interface ViewController (){
    UIBarButtonItem *donebuttonItem;
}
-(void)clickdonebutton:(id)sender;

@end

@implementation ViewController

-(void)clickdonebutton:(id)sender{
    ViewController2 *vc2=[[ViewController2 alloc]initWithNibName:@"ViewController2" bundle:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    //init connect socket
    OnlineMode =[[SingletonObject sharedSingletonObject]getOnlineMode];
    if(OnlineMode){
    myTurn = [[SingletonObject sharedSingletonObject]getFirst];

    iStream = [[SingletonObject sharedSingletonObject] getInStream];
    oStream = [[SingletonObject sharedSingletonObject] getOutStream];
    iStream.delegate=self;
    oStream.delegate=self;
    }
    //
    self.title=@"中國象棋";
    _chessboard=[[ChessBoard alloc] init];
    _chessboard.delegate=self;
    [_chessboard reset];    
    if (isIphone5) {
        _chessboardView=[[ChessboardView alloc]initWithFrame:CGRectMake(7.0f, 69.0f, 306.0f, 340.f)];
    }
    else{
    _chessboardView=[[ChessboardView alloc] initWithFrame:CGRectMake(7.0f, 25.0f, 306.0f, 340.0f)];
    }
    _chessboardView.backgroundColor=[UIColor clearColor];
    _chessboardView.delegate=self;
    [_chessboardView loadData];
    [self.view addSubview:_chessboardView];
    
    donebuttonItem=[[UIBarButtonItem alloc]initWithTitle:@"對戰結束" style:UIBarButtonItemStyleBordered target:self action:@selector(clickdonebutton:)];
    self.navigationItem.rightBarButtonItem=donebuttonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChessboardViewDelegate

- (ChessmanView *)chessboardView:(ChessboardView *)chessboardView chessmanViewAtPosition:(Position)pos{
    Chessman *chessman=[_chessboard chessmanAtPosition:pos];
    if (chessman!=nil) {
        CGSize s = chessboardView.gridSize;
        CGRect rect=CGRectMake(pos.x*s.width, pos.y*s.height, s.width, s.height);
        ChessmanView *vw=[[ChessmanView alloc] initWithFrame:rect];
        vw.backgroundImage=[UIImage imageNamed:@"bg-chessman.png"];
        vw.text=chessman.name;        
        vw.textColor=chessman.offensiveType==kRed?[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        return [vw autorelease];
    }
    return nil;
}

- (void)chessboardView:(ChessboardView *)chessboardView touchAtPosition:(Position)pos{

    if (OnlineMode)
    {
        if(!myTurn)
            return;
    }
    if (_chessboard.selectedChessman==nil) {
        [_chessboard setSelectedChessmanAtPosition:pos];
        return;        
    }
    
    Chessman *chessman=[_chessboard chessmanAtPosition:pos];
    if (chessman !=nil && chessman.offensiveType==_chessboard.currentOffensive) {
        [_chessboard setSelectedChessmanAtPosition:pos];

        return;
    }  
    
    [_chessboard moveSelectedChessmanTo:pos];
    //
    
    //*****未寫入流程******
    if(OnlineMode){
        [[SingletonObject sharedSingletonObject]editAfterPosition:pos];
        if ([[SingletonObject sharedSingletonObject]getMoveTarget]) {
            [self moveTarget];
            [[SingletonObject sharedSingletonObject]editMoveTarget:FALSE];
        }

    }
    NSLog(@"Move to %d,%d",pos.x,pos.y);
    //*****未寫入流程******


}

#pragma mark - ChessboardDelegate

- (void)chessboard:(ChessBoard *)chessboard didSelectChessman:(Chessman *)selectedChessman deselectChessman:(Chessman *)deselectedChessman{
    if (selectedChessman!=nil) {
        [_chessboardView selectChessmanViewAtPosition:selectedChessman.position animated:YES];
    }
    if(deselectedChessman!=nil){
        [_chessboardView deselectChessmanViewAtPosition:deselectedChessman.position animated:YES];
    }
}

- (void)chessboard:(ChessBoard *)chessboard moveChessman:(Chessman *)chessman from:(Position)from to:(Position)target killedChessman:(Chessman *)killedChessman{
    [_chessboardView moveChessmanViewAtPosition:from to:target animated:YES];
}

#pragma - Connect Socket
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    //當訊息從主機由iStream端進入時
    if (eventCode == NSStreamEventHasBytesAvailable) {
        NSMutableData *data = [[NSMutableData alloc] init];
        
        NSLog(@"========Something msg incoming ========");
        
        //定義接收串流的大小
        uint8_t buf[1024];
        unsigned int len = 0;
        len = [(NSInputStream *)stream read:buf maxLength:1024];
        [data appendBytes:(const void *)buf length:len];
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",str);
    
        
        //接收自定字串
        if([str rangeOfString:@"data"].location != NSNotFound )
        {
            
            NSError *error=Nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error)
                NSLog(@"JSONObjectWithData error: %@", error);
        /*    
            else{
                for (NSString *str in dic )
                {
                    NSLog(@"%@:%@",str,[dic  objectForKey:str]);
                }
            }
        */
            NSString* newStr = [dic objectForKey:@"data"];
        //    NSLog(@"%@",newStr);
        
            /*
            NSLog(@"bx=%@" ,[newStr substringWithRange:NSMakeRange(0, 1)]);
            NSLog(@"by=%@" ,[newStr substringWithRange:NSMakeRange(2, 1)]);
            NSLog(@"ax=%@" ,[newStr substringWithRange:NSMakeRange(4, 1)]);
            NSLog(@"ay=%@" ,[newStr substringWithRange:NSMakeRange(6, 1)]);
            */
            
            optBefore.x = [[newStr substringWithRange:NSMakeRange(0, 1)] intValue];
            optBefore.y = [[newStr substringWithRange:NSMakeRange(2, 1)] intValue];
            optAfter.x = [[newStr substringWithRange:NSMakeRange(4, 1)] intValue];
            optAfter.y = [[newStr substringWithRange:NSMakeRange(6, 1)] intValue];
            
            [self moveOpt];
        }
        
    
    }
}

- (void) moveTarget
{
    
    myTurn = FALSE;
    NSLog(@"myturn %u",myTurn);

    Position P = [[SingletonObject sharedSingletonObject]getBeforePosition];
    
    NSString *connectStr = [NSString stringWithFormat:@"%d,%d",P.x,P.y];
    P = [[SingletonObject sharedSingletonObject]getAfterPosition];
    
    connectStr = [NSString stringWithFormat:@"%@,%d,%d",connectStr,P.x,P.y];
    
    connectStr = [NSString stringWithFormat:@"{\"data\":\"%@\",\"PutItThere\":\"true\"}\n",connectStr];
    
    NSLog(@"connectStr : %@",connectStr);
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *) [connectStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    [oStream write:nuit8Text maxLength:strlen((char*)nuit8Text)];
    [self isGameOver];
}

-(void) moveOpt
{
    
    [_chessboardView selectChessmanViewAtPosition:optBefore animated:YES];
    [_chessboard removeAndReplaceItem:optBefore :optAfter];
    [_chessboardView moveChessmanViewAtPosition:optBefore to:optAfter animated:YES];
    
//    [_chessboard setSelectedChessmanAtPosition:optBefore];
//    [_chessboard moveSelectedChessmanTo:optAfter];
    myTurn = YES;
    NSLog(@"myturn %u",myTurn);
    [self isGameOver];
}

-(void) isGameOver
{
    if(![[SingletonObject sharedSingletonObject]getGameOver])
    {
        return;
    }
    else
    {
        NSLog(@"Winner is : %u",[[SingletonObject sharedSingletonObject]getWinner]);
        /*
        NSString *connectStr = [NSString stringWithFormat:@"{\"winner\":\"%@\"}\n",];
        
        NSLog(@"connectStr : %@",connectStr);
        const uint8_t *nuit8Text;
        nuit8Text = (uint8_t *) [connectStr cStringUsingEncoding:NSASCIIStringEncoding];
        
        [oStream write:nuit8Text maxLength:strlen((char*)nuit8Text)];
         */
    }
    
}
@end
