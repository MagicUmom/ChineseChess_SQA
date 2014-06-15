//
//  loginPageViewController.m
//  ChineseChess
//
//  Created by WeiKang on 2014/5/28.
//  Copyright (c) 2014年 tanghuacheng.cn. All rights reserved.
//

#import "loginPageViewController.h"
#import "SingletonObject.h"
#import "ViewController.h"
@interface loginPageViewController ()

@end

@implementation loginPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    [[SingletonObject sharedSingletonObject]connectToServer ];
    oStream =[[SingletonObject sharedSingletonObject]getOutStream];
    iStream =[[SingletonObject sharedSingletonObject]getInStream];
    oStream.delegate=self;
    iStream.delegate=self;
    NSLog(@"is server alive? : %lu",[oStream streamStatus]);
    sleep(1);
    
    NSString *connectStr = [NSString stringWithFormat:@"{\"token\":\"%@\",\"gameID\":\"%@\"}\n",[[SingletonObject sharedSingletonObject] getToken],[[SingletonObject sharedSingletonObject] getGameID]];
    
    NSLog(@"%@",connectStr);
    NSData *jsonData = [connectStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *) [connectStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    [oStream write:nuit8Text maxLength:strlen((char*)nuit8Text)];

}

- (IBAction)btn_invite:(id)sender {
    NSString *Str = [NSString stringWithFormat:@"{\"invite\":\"%@\"}\n",[[SingletonObject sharedSingletonObject] getOpID ]];
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *) [Str cStringUsingEncoding:NSASCIIStringEncoding];
    
    [oStream write:nuit8Text maxLength:strlen((char*)nuit8Text)];

    
}

- (IBAction)btn_accept:(id)sender {
    NSString *Str = [NSString stringWithFormat:@"{\"accept\":\"true\"}\n"];
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *) [Str cStringUsingEncoding:NSASCIIStringEncoding];
    
    [oStream write:nuit8Text maxLength:strlen((char*)nuit8Text)];
    NSLog(@"=======發出同意=======");

}

- (IBAction)btn_start:(id)sender {
    
    [[SingletonObject sharedSingletonObject]editOnlineMode:YES ];
    ViewController *vcc=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vcc animated:YES];

}

- (IBAction)btn_close:(id)sender {
    [oStream close];
    [iStream close];
}

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
        NSLog(@"%@",str);

        //List 接收
        if( [str rangeOfString:@"list"].location != NSNotFound && [str rangeOfString:@"null"].location
           == NSNotFound)
        {
            //str=[str substringFromIndex:23];
            //str=[str substringToIndex:14];
            //JSON -> Dictionary
            
            //NSData *jsonData =[str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error=Nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error)
                NSLog(@"JSONObjectWithData error: %@", error);
            else{
                for (NSString *str in dic)
                {
                    NSLog(@"%@:%@",str,[dic objectForKey:str]);
                }
            }
            
            NSString* newstr = [dic valueForKeyPath:@"list.id"];
            NSLog(@"%@",newstr);

        }
        //
        
        //配對成功
        NSString* cmpStr = [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"resultID\"}",[SingletonObject sharedSingletonObject].getOpID];
        if([str rangeOfString:cmpStr].location != NSNotFound)
        {
            NSLog(@"配對成功");
        }
        //
        
        // 遊戲即將開始  決定誰先手
        cmpStr = [NSString stringWithFormat:@"\"whoFirst\""];
        if([str rangeOfString:cmpStr].location != NSNotFound)
        {
            if ([str rangeOfString:@"true"].location !=NSNotFound) {
                NSLog(@"先手");
                [[SingletonObject sharedSingletonObject]editFirst:YES];
            }
            else {
                [[SingletonObject sharedSingletonObject]editFirst:FALSE];
                NSLog(@"後手");
            }
        }

        //

    }
}
@end
