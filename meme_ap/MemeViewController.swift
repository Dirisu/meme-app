//
//  ViewController.swift
//  meme_ap
//
//  Created by Marvellous Dirisu on 12/05/2022.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {    
  
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageViewBox: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareImageToolbar: UIToolbar!

    @IBOutlet weak var shareButtonLabel: UIBarButtonItem!
    
    // MARK: VARIABLES/CONSTANTS
    
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
       
    let appTextProperty : [NSAttributedString.Key:Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.5
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        shareButtonLabel.isEnabled = false
        
        prepareTextField(textfield: topTextField, defaultText: "TOP")
        prepareTextField(textfield: bottomTextField, defaultText: "BOTTOM")
        
        // Assign appropriate delegates to each text field
        self.topTextField.delegate = self
        self.bottomTextField.delegate = bottomTextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
   
    func prepareTextField(textfield:UITextField, defaultText:String){
        textfield.text = defaultText
        textfield.defaultTextAttributes = appTextProperty
        textfield.textAlignment = .center
    }
    
    func pickImage(sourceType:UIImagePickerController.SourceType){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        present(controller, animated: true, completion: nil)
    }
    
   
    
   
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height
    }
    
 
    @objc func keyboardWillShow(_ notification:Notification){
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
  
    func generateMemedImage() -> UIImage {
       
        self.toolBar.isHidden = true
        self.shareImageToolbar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
       
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolBar.isHidden = false
        self.shareImageToolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

        return memedImage
    }
     
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageViewBox.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageViewBox.image = image
        }
        shareButtonLabel.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "TOP"{
            textField.text = ""
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText.replacingCharacters(in: range, with: string)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            textField.text = "TOP"
        }
        return true
    }
    
    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
   
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = {(activityType:UIActivity.ActivityType?, completed:Bool, arrayReturnedItems:[Any]?, error:Error?) in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMemeEditor(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
