//
//  ViewController2.m
//  ChineseChess


#import "ViewController2.h"
#import "ViewController.h"
#import "loginPageViewController.h"
#import "SingletonObject.h"

@interface ViewController2 ()

@end

@implementation ViewController2

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
    // Do any additional setup after loading the view from its nib.
    self.title=@"主選單";
    //UIImage *img=[UIImage imageNamed:@"bg-chessman.png"];
    //imgview=[[UIImageView alloc]initWithImage:img];
}
- (IBAction)loginButton:(id)sender {

    // HTTP POST and request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    NSURL *connect = [[NSURL alloc] initWithString:@"https://fgc.heapthings.com/api/getToken"];
//    NSString *username = @"test1@fcu.edu.tw";
//    NSString *password = @"test1";
//    [[SingletonObject sharedSingletonObject]editOpID:@"MagicUmom"];
    
    NSString *username = @"ken51006b@hotmail.com";
    NSString *password = @"654321";
    [[SingletonObject sharedSingletonObject]editOpID:@"test1"];

    NSString *gameID = @"chineseChess";
    NSString *httpBodyString=[NSString stringWithFormat:@"username=%@&password=%@&gameID=%@", username,password, gameID];
    
    //寫入gameID到S_gameID
    [[SingletonObject sharedSingletonObject]editGameID:gameID];
    
    [request setURL:connect];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    //JSON -> Dictionary
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
    //check result
    int check = [[dic objectForKey:@"result"]intValue];
    if(check)
    {
        NSLog(@"result success");
        
        //寫入token至S_token
        NSString *token = [dic objectForKey:@"token"];

        [[SingletonObject sharedSingletonObject]editToken:token];
        
        // XIB-> Storyboard
           UIStoryboard *myViewController =[[UIStoryboard storyboardWithName:@"Storyboard" bundle:NULL]instantiateViewControllerWithIdentifier:@"loginPageViewController"];
            [self.navigationController pushViewController:myViewController animated:YES];

    }
    else
    {
        NSLog(@"result fail");
    }
    

 

}

-(void)clickbutton:(id)sender{
    [[SingletonObject sharedSingletonObject]editOnlineMode:FALSE];
    ViewController *vcc=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vcc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
