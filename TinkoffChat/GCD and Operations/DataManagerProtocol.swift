//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 29.03.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

class DataManager {
    static func savePhoto(userPhoto : UIImage?, photoName : String) throws {
        
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(photoName)
        
        if let image = userPhoto, let imageData = UIImageJPEGRepresentation(image, 1.0) {
            let imageNSData : NSData = imageData as NSData
            try imageNSData.write(toFile: path, options: [])
        }
    }
    static func saveTextData(userName : String?, userDescription : String?, fileName : String) throws {
        
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        var fileText : String
        if (!fileManager.fileExists(atPath: path)) {
            fileText = userName ?? "Имя"
            fileText.append("\n")
            fileText.append(userDescription ?? "О себе")
        } else {
            fileText = try String(contentsOfFile: path, encoding: .utf8)
            var fileLines = fileText.components(separatedBy: .newlines)
            if let userName = userName {
                fileLines[0] = userName
            }
            if let userDescription = userDescription {
                fileLines[1] = userDescription
            }
            fileText = fileLines.joined(separator: "\n")
        }
        try fileText.write(toFile: path, atomically: true, encoding: .utf8)
    }
    static func loadData(fileName : String, photoName : String) throws -> (name: String?, description: String?, image: UIImage?) {
        let tempDir = NSTemporaryDirectory()
        var path = (tempDir as NSString).appendingPathComponent(photoName)
        let fileManager = FileManager.default
        let userPhoto = UIImage(contentsOfFile: path)
        path = (tempDir as NSString).appendingPathComponent(fileName)
        if (!fileManager.fileExists(atPath: path)) {
            return (name: nil, description: nil, image: userPhoto)
        }
        let fileText = try String(contentsOfFile: path, encoding: .utf8)
        var fileLines = fileText.components(separatedBy: .newlines)
        return (name: fileLines[0], description: fileLines[1], image: userPhoto)
    }
    static func saveTheme(theme : String, fileName : String) throws {
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        try theme.write(toFile: path, atomically: true, encoding: .utf8)
    }
    static func loadTheme(fileName : String) throws -> String {
        let tempDir = NSTemporaryDirectory()
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        let fileText = try String(contentsOfFile: path, encoding: .utf8)
        return fileText
    }

}
protocol DataManagerProtocol {
    var userName : String? {get set}
    var userDescription : String? {get set}
    var userPhoto : UIImage? {get set}
    var fileName : String {get set}
    var photoName : String {get set}
    func saveData(completion: @escaping (Error?) -> ())
    func loadData(completion: @escaping (Error?) -> ())
    
}

