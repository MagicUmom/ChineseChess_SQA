//
//  Common.h
//  ObjC_Chess
//


#ifndef ObjC_Chess_Common_h
#define ObjC_Chess_Common_h

struct Position{
    int x;
    int y;
};

typedef struct Position Position;

typedef enum{
    kRed,
    kBlack
}OffensiveType;

static inline Position PositionMake(int x,int y);

static inline Position PositionMake(int x,int y){
    Position p;
    p.x=x;
    p.y=y;
    return p;
}

#endif
