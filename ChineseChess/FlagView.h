//
//  FlagView.h
//  ChineseChess


#import <UIKit/UIKit.h>
#import "Common.h"

@interface FlagView : UIView{
    OffensiveType _offensiveType;
    UIImage *_image;    
}

@property (assign) OffensiveType offensiveType;

@end
