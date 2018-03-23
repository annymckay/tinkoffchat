//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Анна Лихтарова on 17.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

#import "ThemesViewController.h"


@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (IBAction)hideButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[Themes alloc] setDefaultModel];
    self.view.backgroundColor = self.model.theme1;
}
- (IBAction)setThemeButtonPressed:(UIButton *)sender {
    NSString *themeName  = sender.titleLabel.text;
    UIColor *theme;
    if ([themeName isEqualToString: @"Тема 1"]) {
        theme = self.model.theme1;
    } else if ([themeName isEqualToString: @"Тема 2"]) {
        theme = self.model.theme2;
    } else if ([themeName isEqualToString: @"Тема 3"]){
        theme = self.model.theme3;
    } else {
        theme = UIColor.yellowColor;
    }
    [self.delegate themesViewController:self didSelectTheme: theme];
    self.view.backgroundColor = theme;
    
}

-(void)dealloc {
    [self.model release];
    [self.delegate release];
    [super dealloc];
}



@end
