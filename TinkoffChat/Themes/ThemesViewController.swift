//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    typealias SelectTheme = (UIColor) -> ()
    var model : ThemesSwift = ThemesSwift()
    var closure : SelectTheme?
    @IBAction func hideButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func setThemeButtonPressed(_ sender: UIButton) {
        var theme : UIColor?
        if let themeName = sender.titleLabel?.text {
            switch themeName {
            case "Тема 1":
                theme = self.model.theme1
                self.closure?(theme!)
            case "Тема 2":
                theme = self.model.theme2
                self.closure?(theme!)
            case "Тема 3":
                theme = self.model.theme3
                self.closure?(theme!)
            default:
                theme = UIColor.yellow
                self.closure?(theme!)
            }
        }
        self.view.backgroundColor = theme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
