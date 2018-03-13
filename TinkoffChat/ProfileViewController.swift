//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 26.02.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit
import Photos

class ProfileViewController: UIViewController {
    
    @IBAction func hideProfileButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var setProfilePhotoButton: UIButton!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var profilePhotoImage: UIImageView!
    
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    
    @IBAction func setProfilePhotoButtonAction(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showSetProfilePhotoAlert()
    }
    
    func showSetProfilePhotoAlert(){
        let setProfilePhotoAlert = UIAlertController(title: "Выберите изображение профиля", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        let chooseProfilePhotoAction = UIAlertAction(title: "Установить из галереи", style: .default) { action in
            if let picker = self.imagePicker {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }
        
        let takeProfilePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            if let picker = self.imagePicker {
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                    picker.allowsEditing = false
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                    picker.cameraCaptureMode = .photo
                    self.present(picker, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Камера не найдена", message: "На этом устройстве не поддерживается камера", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        setProfilePhotoAlert.addAction(cancelAction)
        setProfilePhotoAlert.addAction(chooseProfilePhotoAction)
        setProfilePhotoAlert.addAction(takeProfilePhotoAction)
        
        self.present(setProfilePhotoAlert, animated: true, completion: nil)
    }

    @IBAction func editAction(_ sender: Any) {
        descriptionLabel.text = "Привет! Учусь разрабатывать мобильные приложения под ios"
    }
    
    func setDesign(){
        nameLabel.text = "Аня Лихтарова"
        
        setProfilePhotoButton.backgroundColor = UIColor.init(red: 63.0/255, green: 120.0/255, blue: 240.0/255, alpha: 1)
        let radius = setProfilePhotoButton.frame.size.height / 2
        setProfilePhotoButton.layer.cornerRadius = radius
        profilePhotoImage.layer.cornerRadius = radius
        profilePhotoImage.clipsToBounds = true
        setProfilePhotoButton.imageView?.contentMode = .scaleAspectFit
        let imageShift = setProfilePhotoButton.frame.size.height / 5
        setProfilePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(imageShift, imageShift, imageShift, imageShift)
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker?.delegate = self
        setDesign()
        checkPermission()
        
        //print("<viewDidLoad()> \(editButton.frame)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // print("<viewDidAppear> \(editButton.frame)")
        //Отличается потому что в методе viewDidLoad отображаются данные, только что полученные из storyboard'а - то есть данные для айфона выбранного в storyboard, в данном случае iphone SE. В методе viewDidAppear, который вызывается после того как view появился на экране, размеры уже рассчитаны для выбранного в симуляторе устройства -  iphone X в данном случае.
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Проблема в том, что editButton инициализируется в методе loadView(), который вызывается после init, поэтому в момент вызова init кнопки еще не существует и frame'а у нее соответвенно нет. Попытка обратиться к editButton в методе init приводит к ошибке "Unexpectedly found nil while unwrapping an Optional value"
        
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profilePhotoImage.contentMode = .scaleAspectFill
        profilePhotoImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access to photos is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("Acces to photos status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("Access to photos has just granted by user")
                }
            })
            print("Access to photos is not determined until now")
        case .restricted:
            print("User do not have access to photos.")
        case .denied:
            print("User has denied the permission for access to photos")
        }
    }
}

