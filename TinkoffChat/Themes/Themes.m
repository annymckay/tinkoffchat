//
//  Themes.m
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

#import "Themes.h"

@implementation Themes
-(instancetype) setDefaultModel {
    self = [super init];
    if(self) {
        _theme1 = [[UIColor alloc] initWithRed:255.0f/255.0f green:221.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        _theme2 = [[UIColor alloc] initWithRed:195.0f/255.0f green:234.0f/255.0f blue:250.0f/255.0f alpha:1.0];
        _theme3 = [[UIColor alloc] initWithRed:192.0f/255.0f green:252.0f/255.0f blue:196.0f/255.0f alpha:1.0];
    }
    
    return self;
}
-(void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    
    [super dealloc];
}
@end
