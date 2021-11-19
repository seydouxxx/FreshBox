//
//  ItemDetailViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/08.
//

import UIKit
import RealmSwift

class ItemDetailViewController: UIViewController {

    var parentVC: ItemViewController!
    var selectedItem: Item!
    let realm = try! Realm()
    var deleteStatus = false
//    var isDataModified = false
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var memoContent: UILabel!
    @IBOutlet weak var memoContainer: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityContent: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationContent: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var expireDateContent: UILabel!
    @IBOutlet weak var registerDateLabel: UILabel!
    @IBOutlet weak var registerDateContent: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedItem = realm.objects(Item.self).filter("id == %@", selectedItem.id).first
        
        title = selectedItem.name
        
        itemImageView.image = ImageFileManager.shared.loadImage(name: selectedItem.itemImage)
        itemImageView.layer.borderColor = UIColor.clear.cgColor
        itemImageView.layer.borderWidth = 0.1
        itemImageView.layer.cornerRadius = 10
        itemImageView.layer.masksToBounds = true
        
        memoContainer.backgroundColor = .lightGray.withAlphaComponent(0.2)
        memoContainer.layer.cornerRadius = 10
        memoContainer.layer.masksToBounds = true
        memoContent.text = selectedItem.memo
        memoContent.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.95)
        memoContent.textColor = .darkGray
        
        quantityLabel.text = "수량"
        quantityLabel.textColor = .lightGray
        quantityContent.text = "\(selectedItem.quantity)"
        quantityContent.textColor = .darkGray
        
        locationLabel.text = "보관장소"
        locationLabel.textColor = .lightGray
        locationContent.text = selectedItem.itemLocation == 0 ? "냉장" : selectedItem.itemLocation == 1 ? "냉동" : "실온"
        locationContent.textColor = .darkGray
        
        expireDateLabel.text = "유통기한"
        expireDateLabel.textColor = .lightGray
        expireDateContent.text = "\(dateFormatter(of: selectedItem.expireDate))"
        expireDateContent.textColor = .darkGray
        
        registerDateLabel.text = "구매일자"
        registerDateLabel.textColor = .lightGray
        registerDateContent.text = "\(dateFormatter(of: selectedItem.boughtDate))"
        registerDateContent.textColor = .darkGray
    }
    
    @IBAction func editItemImagePressed(_ sender: UIButton) {
        print("pressed editImage")
    }
    @IBAction func editItemButton(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func deleteItemPressed(_ sender: UIButton) {
        if deleteStatus {
            do {
                try realm.write {
                    realm.delete(realm.objects(Item.self).filter("id == %@", selectedItem.id))
                }
            } catch {
                print("Error occured during deleteing item. \(error)")
            }
            parentVC.loadData()
            self.navigationController?.popViewController(animated: true)
        } else {
            sender.setTitle("확인", for: .normal)
//            sender.tintColor = UIColor.systemRed
            sender.backgroundColor = UIColor.systemRed
            
            sender.layer.masksToBounds = true
            sender.setTitleColor(UIColor.white, for: .normal)
            
            deleteStatus = !deleteStatus
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItemSegue" {
            let editItemVC = segue.destination as! EditItemViewController
            editItemVC.parentVC = self
            editItemVC.selectedItem = selectedItem as Item
        }
    }
}
