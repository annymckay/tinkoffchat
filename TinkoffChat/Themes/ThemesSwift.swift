//
//  Themes.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 23.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import Foundation
struct Theme {
    var barTintColor : UIColor
    var tintColor : UIColor
    init(barTintColor : UIColor = UIColor.init(red: 255.0/255.0, green: 221.0/255.0, blue: 0.0/255.0, alpha: 1.0), tintColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1.0)) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
    }
}
class ThemesSwift{
    var theme1 : Theme?
    var theme2 : Theme?
    var theme3 : Theme?
    init() {
        self.theme1 = Theme(barTintColor: UIColor.init(red: 255.0/255.0, green: 221.0/255.0, blue: 0.0/255.0, alpha: 1.0),
                            tintColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 1.0))
        self.theme2 = Theme(barTintColor: UIColor.init(red: 1.0/255.0, green: 9.0/255.0, blue: 26.0/255.0, alpha: 1.0),
                            tintColor: UIColor.init(red: 255.0/255.0, green: 221.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        self.theme3 = Theme(barTintColor: UIColor.init(red: 252.0/255.0, green: 250.0/255.0, blue: 194.0/255.0, alpha: 1.0),
                       tintColor: UIColor.init(red: 1.0/255.0, green: 9.0/255.0, blue: 26.0/255.0, alpha: 1.0))
    }
}
