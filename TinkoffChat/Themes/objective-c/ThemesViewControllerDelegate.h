//
//  ThemesViewControllerDelegate.h
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

#ifndef ThemesViewControllerDelegate_h
#define ThemesViewControllerDelegate_h

#import <UIKit/UIKit.h>
@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>
-(void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

#endif /* ThemesViewControllerDelegate_h */
