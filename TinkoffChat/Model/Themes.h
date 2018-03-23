//
//  Themes.h
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//
#ifndef Themes_h
#define Themes_h

#import <UIKit/UIKit.h>

@interface Themes : NSObject

@property (retain) UIColor* theme1;
@property (retain) UIColor* theme2;
@property (retain) UIColor* theme3;

-(instancetype) setDefaultModel;
-(void)dealloc;
@end

#endif /* Themes_h */
