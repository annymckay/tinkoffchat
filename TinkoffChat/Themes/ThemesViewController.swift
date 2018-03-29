//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    typealias SelectTheme = (Theme) -> ()
    var model : ThemesSwift = ThemesSwift()
    var closure : SelectTheme?
    var theme : Theme?
    @IBAction func hideButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func setThemeButtonPressed(_ sender: UIButton) {
        var theme : Theme
        let buttonTag = sender.tag
        switch buttonTag {
        case 0:
            theme = self.model.theme1!
            self.closure?(theme)
        case 1:
            theme = self.model.theme2!
            self.closure?(theme)
        case 2:
            theme = self.model.theme3!
            self.closure?(theme)
        default:
            theme = Theme(barTintColor: UIColor.yellow, tintColor: UIColor.blue)
            self.closure?(theme)
        }
        let gcdDataManager = GCDDataManager()
        gcdDataManager.theme = String(buttonTag)
        gcdDataManager.saveTheme {_ in }
        self.theme = theme
        setTheme()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTheme()
        setTheme()
        
    }
    func setTheme(){
        if let theme = self.theme {
            self.view.backgroundColor = theme.barTintColor
            navigationController?.navigationBar.barTintColor = theme.barTintColor
            navigationController?.navigationBar.tintColor = theme.tintColor
        }
    }
    func loadTheme() {
        let themes = ThemesSwift()
        let gcdDataManager = GCDDataManager()
        gcdDataManager.loadTheme { tag, _ in
            if let tag = tag {
                self.theme = themes.getThemeByTag(tag: tag)
                self.setTheme()
            }
        }
    }
}
