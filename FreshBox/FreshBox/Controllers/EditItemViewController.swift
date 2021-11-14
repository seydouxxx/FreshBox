//
//  EditItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/11.
//

import UIKit
import RealmSwift

class EditItemViewController: UIViewController {
    
    var parentVC: ItemDetailViewController!
    var selectedItem: Item!
    let realm = try! Realm()
    var image: UIImage?
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var memoContainer: UIView!
    
    @IBOutlet weak var editItemImageButton: UIButton!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSegment: UISegmentedControl!
    
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var expireDatePicker: UIDatePicker!
    
    @IBOutlet weak var registerDateLabel: UILabel!
    @IBOutlet weak var registerDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "정보 수정"
//        itemTitleTextField.layer.borderColor = UIColor.clear.cgColor
        itemTitleTextField.borderStyle = .roundedRect
        itemTitleTextField.text = selectedItem.name
        
        itemImageView.image = ImageFileManager.shared.loadImage(name: selectedItem.itemImage)
        itemImageView.layer.borderColor = UIColor
            .clear.cgColor
        itemImageView.layer.borderWidth = 0.1
        itemImageView.layer.cornerRadius = 10
        itemImageView.layer.masksToBounds = true
        
        initImageEditButton()
        
        memoContainer.backgroundColor = .lightGray.withAlphaComponent(0.2)
        memoContainer.layer.cornerRadius = 10
        memoContainer.layer.masksToBounds = true
        memoTextField.text = selectedItem.memo
        memoTextField.borderStyle = .roundedRect
        memoTextField.delegate = self
        memoTextField.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.95)
        memoTextField.textColor = .darkGray
        
        quantityLabel.text = "수량"
        quantityLabel.textColor = .lightGray
        
        quantityTextField.text = "\(selectedItem.quantity)"
        quantityTextField.keyboardType = .numberPad
        quantityTextField.borderStyle = .roundedRect
        // textfield
        
        locationLabel.text = "보관장소"
        locationLabel.textColor = .lightGray
        locationSegment.setTitle("냉장", forSegmentAt: 0)
        locationSegment.setTitle("냉동", forSegmentAt: 1)
        locationSegment.setTitle("실온", forSegmentAt: 2)
        locationSegment.selectedSegmentTintColor = Constants.themeColor
        locationSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        locationSegment.selectedSegmentIndex = selectedItem.itemLocation
        
        // textfield
        
        expireDateLabel.text = "유통기한"
        expireDateLabel.textColor = .lightGray
        expireDatePicker.locale = Constants.locale
        expireDatePicker.calendar.locale = Constants.locale
        expireDatePicker.date = selectedItem.expireDate
        // textfield
        
        registerDateLabel.text = "구매일자"
        registerDateLabel.textColor = .lightGray
        registerDatePicker.locale = Constants.locale
        registerDatePicker.calendar.locale = Constants.locale
        registerDatePicker.date = selectedItem.createdDate
        // textfield
        
        // Do any additional setup after loading the view.
        setKeyboardDismiss()
    }
    func setKeyboardDismiss() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        touchGesture.isEnabled = true
        touchGesture.cancelsTouchesInView = false
        touchGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(touchGesture)
    }
    @objc func keyboardDismiss () {
        self.view.endEditing(true)
    }
    func initImageEditButton() {
        let takePhotoAction = UIAction(title: "사진 촬영", image: UIImage(systemName: "camera"), handler: presentCamera(_:))
        let cancelAction = UIAction(title: "취소", attributes: .destructive) { _ in
            print("cancel")
        }
        editItemImageButton.showsMenuAsPrimaryAction = true
        editItemImageButton.menu = UIMenu.init(
            title: "사진 변경",
            image: UIImage(systemName: "camera"),
            identifier: nil,
            options: .displayInline,
            children: [takePhotoAction, cancelAction]
        )
    }
    
    @IBAction func EditImageButtonPressed(_ sender: UIButton) {
        
        print("pressed")
        
        
    }
    @IBAction func submitButtonPressed(_ sender: UIBarButtonItem) {
        guard itemTitleTextField.text!.count != 0 else { return }
        do {
            if let targetItem = realm.objects(Item.self).filter("id == %@", selectedItem.id).first {
                try realm.write {
                    if let newImage = self.image {
                        ImageFileManager.shared.saveImage(image: newImage, name: selectedItem.itemImage) { _ in }
                        ImageFileManager.shared.saveImage(
                            image: ImageFileManager.shared.resizeImage(of: newImage, for: 70),
                            name: selectedItem.itemThumbnail) { _ in }
                    }
                    targetItem.name = itemTitleTextField.text ?? selectedItem.name
                    targetItem.memo = memoTextField.text ?? selectedItem.memo
                    targetItem.quantity = Int(quantityTextField.text!) ?? selectedItem.quantity
                    targetItem.itemLocation = locationSegment.selectedSegmentIndex
                    targetItem.expireDate = expireDatePicker.date
                    targetItem.boughtDate = registerDatePicker.date
                }
            }
        } catch {
            print("Error occured during updating item. \(error)")
        }
        parentVC.parentVC.loadData()
        parentVC.viewDidLoad()
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EditItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension EditItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentCamera(_ action: UIAction) {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.cameraCaptureMode = .photo
        camera.cameraDevice = .rear
        camera.allowsEditing = true
        camera.delegate = self
        
        present(camera, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.image = ImageFileManager.shared.resizeImage(of: image)
        }
        picker.dismiss(animated: true, completion: nil)
        itemImageView.image = self.image
    }
}
