//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 29.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//
class OperationDataManager : DataManagerProtocol {
    var userName : String?
    var userDescription : String?
    var userPhoto : UIImage?
    var fileName = "UserProfileInfo.txt"
    var photoName = "UserProfilePhoto.jpeg"
    
    func saveData(completion: @escaping (Error?) -> ()) {
        //print("Operation save")
        let operationSave = SavingOperation(userName: self.userName, userDescription: self.userDescription, userPhoto: self.userPhoto, fileName: self.fileName, photoName: self.photoName)
        operationSave.qualityOfService = .userInitiated
        operationSave.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operationSave.error)
            }
        }
        let saveQueue = OperationQueue()
        saveQueue.addOperation(operationSave)
    }
    func loadData(completion: @escaping (Error?) -> ()) {
        //print("Operation load")
        let operationLoad = LoadingOperation(fileName: self.fileName, photoName: self.photoName)
        operationLoad.qualityOfService = .userInitiated
        operationLoad.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operationLoad.error)
            }
        }
        let saveQueue = OperationQueue()
        saveQueue.addOperation(operationLoad)
    }
}
class SavingOperation : AsyncOperation {
    var userName : String?
    var userDescription : String?
    var userPhoto : UIImage?
    var fileName : String
    var photoName : String
    var error : Error?
    
    init(userName: String?, userDescription : String?, userPhoto : UIImage?, fileName : String, photoName : String) {
        self.userName = userName
        self.userDescription = userDescription
        self.userPhoto = userPhoto
        self.fileName = fileName
        self.photoName = photoName
        super.init()
    }
    override func main() {
        self.error = nil
        do {
            //sleep(1)
            try DataManager.savePhoto(userPhoto: userPhoto, photoName: photoName)
            try DataManager.saveTextData(userName: userName, userDescription: userDescription, fileName: fileName)
        } catch let error {
            self.error = error
        }
        self.state = .finished
    }
}
class LoadingOperation : AsyncOperation {
    var userName : String?
    var userDescription : String?
    var userPhoto : UIImage?
    var fileName : String
    var photoName : String
    var error : Error?
    
    init(fileName : String, photoName : String) {
        self.fileName = fileName
        self.photoName = photoName
        super.init()
    }
    override func main() {
        self.error = nil
        do {
            //sleep(1)
            let userData = try DataManager.loadData(fileName: self.fileName, photoName: self.photoName)
            self.userName = userData.name
            self.userDescription = userData.description
            self.userPhoto = userData.image
        } catch let error {
            self.error = error
        }
        self.state = .finished
    }
}

