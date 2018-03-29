//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 26.02.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var userChangedInfo : (name: Bool, description: Bool, photo: Bool) = (false, false, false)
    var theme : Theme?
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    var dataManager : DataManagerProtocol?
    @IBAction func hideProfileButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var setProfilePhotoButton: UIButton!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var profilePhotoImage: UIImageView!
    
    @IBOutlet var savingDataActivityIndicator: UIActivityIndicatorView!
    @IBAction func setProfilePhotoButtonAction(_ sender: UIButton) {
        print("Выбери изображение профиля")
        checkPermission()
        showSetProfilePhotoAlert()
    }

    @IBAction func saveWithGCD(_ sender: UIButton) {
        self.view.endEditing(true)
        dataManager = GCDDataManager()
        saveUserData()
    }

    @IBAction func saveWithOperation(_ sender: UIButton) {
        self.view.endEditing(true)
        dataManager = OperationDataManager()
        saveUserData()
    }
    func saveUserData() {
        savingDataActivityIndicator.startAnimating()
        buttonsEnabled(are: false)
        setProfilePhotoButton.isEnabled = false
        
        if (userChangedInfo.name) {
            dataManager!.userName = nameTextField.text
        }
        if (userChangedInfo.description) {
            dataManager!.userDescription = descriptionTextView.text
        }
        if (userChangedInfo.photo) {
            dataManager!.userPhoto = profilePhotoImage.image
        }
        dataManager!.saveData {
            error in
            self.savingDataActivityIndicator.stopAnimating()
            if (error != nil) {
                self.showDataWasNotSavedAlert()
            }
            else {
                self.showDataSavedAlert()
            }
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        userChangedInfo.name = true
        buttonsEnabled(are: true)
    }
    func textViewDidChange(_ textView: UITextView) {
        userChangedInfo.description = true
        buttonsEnabled(are: true)
    }
    func loadUserData() {
        savingDataActivityIndicator.startAnimating()
        if (dataManager == nil) {
            dataManager = GCDDataManager()
        }
        dataManager!.loadData { error in
            if (error == nil) {
                if let name = self.dataManager!.userName {
                    self.nameTextField.text = name
                }
                if let description = self.dataManager!.userDescription {
                    self.descriptionTextView.text = description
                }
                if let photo = self.dataManager!.userPhoto {
                    self.profilePhotoImage.image = photo
                }
            }
            self.savingDataActivityIndicator.stopAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsHidden(are: true)
        loadUserData()
        self.savingDataActivityIndicator.hidesWhenStopped = true
        imagePicker?.delegate = self
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setDesign()
        
    }
    func showDataSavedAlert() {
        let dataSavedAlert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadUserData()
        }
        dataSavedAlert.addAction(okAction)
        self.present(dataSavedAlert, animated: true, completion: nil)
    }
    func showDataWasNotSavedAlert() {
        let dataWasNotSavedAlert = UIAlertController(title: "Не удалось сохранить данные", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadUserData()
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.saveUserData()
        }
        dataWasNotSavedAlert.addAction(okAction)
        dataWasNotSavedAlert.addAction(repeatAction)
        self.present(dataWasNotSavedAlert, animated: true, completion: nil)
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
        putViewIntoEditingMode()
    }
    func setTheme(){
        if let theme = self.theme {
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
    func putViewIntoEditingMode(){
        userChangedInfo = (false, false, false)
        editButton.isHidden = true
        buttonsHidden(are: false)
        buttonsEnabled(are: false)
        setProfilePhotoButton.isEnabled = true
        
        
        descriptionTextView.isEditable = true
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.textContainerInset = .init(top: 3, left: 5, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.init(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor
        
        nameTextField.isEnabled = true
        nameTextField.borderStyle = .roundedRect
    }
    func putViewIntoNotEditingMode(){
        self.view.endEditing(true)
        editButton.isHidden = false
        buttonsHidden(are: true)
        
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .init(top: 3, left: 0, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 0
        descriptionTextView.layer.borderColor = UIColor.clear.cgColor
        descriptionTextView.isEditable = false

        nameTextField.borderStyle = .none
        nameTextField.isEnabled = false
    }
    func setDesign(){
        loadTheme()
        setTheme()
        putViewIntoNotEditingMode()
        
        let radius = setProfilePhotoButton.frame.size.height / 2
        
        setProfilePhotoButton.backgroundColor = UIColor.init(red: 63.0/255, green: 120.0/255, blue: 240.0/255, alpha: 1)
        setProfilePhotoButton.layer.cornerRadius = radius
        setProfilePhotoButton.imageView?.contentMode = .scaleAspectFit
        let imageShift = setProfilePhotoButton.frame.size.height / 5
        setProfilePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(imageShift, imageShift, imageShift, imageShift)
        
        profilePhotoImage.layer.cornerRadius = radius
        profilePhotoImage.clipsToBounds = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        
        gcdButton.layer.cornerRadius = 15
        gcdButton.layer.borderWidth = 1
        gcdButton.layer.borderColor = UIColor.black.cgColor
        
        operationButton.layer.cornerRadius = 15
        operationButton.layer.borderWidth = 1
        operationButton.layer.borderColor = UIColor.black.cgColor
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y -= keyboardSize.height
                }, completion: nil)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y >= 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y += keyboardSize.height
                }, completion: nil)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profilePhotoImage.contentMode = .scaleAspectFill
        profilePhotoImage.image = image
        dismiss(animated: true, completion: nil)
        userChangedInfo.photo = true
        buttonsEnabled(are: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (photoAuthorizationStatus == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({_ in })
        }
    }
    func buttonsEnabled(are isEnabled: Bool) {
            gcdButton.isEnabled = isEnabled
            operationButton.isEnabled = isEnabled
    }
    func buttonsHidden(are isHidden: Bool) {
        gcdButton.isHidden = isHidden
        operationButton.isHidden = isHidden
        setProfilePhotoButton.isHidden = isHidden
    }
    
}




