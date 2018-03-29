//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 26.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

class GCDDataManager : DataManagerProtocol {
    
    var userName : String?
    var userDescription : String?
    var userPhoto : UIImage?
    var fileName = "UserProfileInfo.txt"
    var photoName = "UserProfilePhoto.jpeg"
    var theme : String?
    var themeFileName = "Theme.txt"
    
    func saveData(completion: @escaping (Error?) -> ()) {
        //print("GCD save")
        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            do {
                //sleep(1)
                try DataManager.savePhoto(userPhoto: self.userPhoto, photoName: self.photoName)
                try DataManager.saveTextData(userName: self.userName, userDescription: self.userDescription, fileName: self.fileName)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    func loadData(completion: @escaping (Error?) -> ()) {
        //print("GCD load")
        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            do {
                //sleep(1)
                let userData = try DataManager.loadData(fileName: self.fileName, photoName: self.photoName)
                self.userName = userData.name
                self.userDescription = userData.description
                self.userPhoto = userData.image
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    func saveTheme(completion: @escaping (Error?) -> ()) {
        let backGroundQueue = DispatchQueue.global(qos: .background)
        backGroundQueue.async {
            do {
                //sleep(1)
                if let theme = self.theme {
                    try DataManager.saveTheme(theme: theme, fileName: self.themeFileName)
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    func loadTheme(completion: @escaping (String?, Error?) -> ()) {
        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            do {
                //sleep(1)
                let themeText = try DataManager.loadTheme(fileName: self.themeFileName)
                DispatchQueue.main.async {
                    completion(themeText, nil)
                }
            } catch let error {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
}




