//
//  ViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/10.
//

import UIKit
import RealmSwift

class FridgeViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let realm = try! Realm()
    var fridges: Results<Fridge>?
    var selectedItem: Fridge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "FridgeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FridgeCell")
        collectionView.register(AddFridgeCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddButtonFooter")
//        collectionView.register(UINib(nibName: "FridgeAddCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddFridgeCell")
        
        // Do any additional setup after loading the view.
        self.loadData()
    }
    
    func loadData() {
        fridges = realm.objects(Fridge.self).sorted(byKeyPath: "createdDate", ascending: true)
        collectionView.reloadData()
    }
}

extension FridgeViewController: UICollectionViewDelegate {
    
}

extension FridgeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let f = fridges {
            return f.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //  show fridge cells
        if let fridges = fridges {
            if indexPath.item != fridges.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FridgeCell", for: indexPath) as! FridgeCollectionViewCell
                let fridge = fridges[indexPath.item]
                let image = textOnImage(text: fridge.name, image: UIImage(named: fridge.fridgeImage)!, position: CGPoint.init(x: 10, y: 10))
                
                cell.fridgeImage.image = image
                cell.isUserInteractionEnabled = true
                
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    //MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = fridges![indexPath.item]
        performSegue(withIdentifier: "FridgeSelection", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemViewController
        destination.selectedFridge = selectedItem
    }
    
    //MARK: - Long press context menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            var menus: [UIMenuElement] = []
            let editBtn = UIAction(title: "수정(미구현)", image: UIImage(systemName: "pencil")) { action in
                print("Edit")
            }
            let deleteBtn = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                do {
                    try self.realm.write({
                        self.realm.delete(self.fridges![indexPath.item])
                    })
                } catch {
                    print("Error occured during deletion. \(error)")
                }
                collectionView.reloadData()
            }
            menus.append(editBtn)
            menus.append(deleteBtn)
            return UIMenu(title: self.fridges![indexPath.item].name, options: .displayInline, children: menus)
        }
    }
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_:[UIMenuElement]) -> UIMenu? in
//            var menus: [UIMenuElement] = []
//            let editBtn = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { action in
//                print("Edit")
//            }
//            let deleteBtn = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
////                do {
////                    try self.realm.write({
////                        self.realm.delete()
////                    })
////                } catch {
////                    print("Error occured during deletetion. \(error)")
////                }
//            }
//            menus.append(editBtn)
//            menus.append(deleteBtn)
//            return UIMenu(title: "", options: .displayInline, children: menus)
//        }
//    }
    //MARK: - Add button as footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddButtonFooter", for: indexPath) as! AddFridgeCollectionReusableView
        
        footerView.AddFridgebutton.addTarget(self, action: #selector(addFridge), for: .touchUpInside)
        
        return footerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    @objc func addFridge() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "냉장고 추가하기", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        let confirm = UIAlertAction(title: "완료", style: .default) { confirm in
            do {
                try self.realm.write({
                    let newFridge = Fridge()
                    newFridge.name = textField.text!
                    newFridge.createdDate = Date()
                    newFridge.fridgeImage = "fridge1"
                    self.realm.add(newFridge)
                })
            } catch {
                print("Error occured in writing. \(error)")
            }
            self.collectionView.reloadData()
        }
        
        alert.addTextField { field in
            field.placeholder = "냉장고 이름을 입력하세요."
            textField = field
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Method to print text on image
    func textOnImage(text: String, image: UIImage, position: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 30)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key: Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: position, size: image.size)
        
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
