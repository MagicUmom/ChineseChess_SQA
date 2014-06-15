//
//  loginPageViewController.h
//  ChineseChess
//
//  Created by WeiKang on 2014/5/28.
//  Copyright (c) 2014年 tanghuacheng.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginPageViewController : UIViewController <NSStreamDelegate>
{
    NSInputStream *iStream;
    NSOutputStream *oStream;

}
- (IBAction)connect:(id)sender;
- (IBAction)btn_invite:(id)sender;
- (IBAction)btn_accept:(id)sender;
- (IBAction)btn_start:(id)sender;
- (IBAction)btn_close:(id)sender;

@end
