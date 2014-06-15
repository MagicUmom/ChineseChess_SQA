//
//  ChessmanView.h
//  ChineseChess


#import <UIKit/UIKit.h>

@interface ChessmanView : UIView{
    UIImage *_backgroundImage;    
    NSString *_text;
    UIFont *_textFont;
    UIColor *_textColor;
    CGRect _textFrame;
    BOOL _highlighted;    
}

@property (nonatomic,retain) UIImage *backgroundImage;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,retain) UIFont *textFont;;
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,assign,getter=isHighlighted) BOOL highlighted;

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
@end
