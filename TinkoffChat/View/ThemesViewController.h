//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Анна Лихтарова on 17.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

@interface ThemesViewController : UIViewController

@property (retain) id<ThemesViewControllerDelegate> delegate;
@property (retain) Themes* model;
-(void)dealloc;

@end

