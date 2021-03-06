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
            let editBtn = UIAction(title: "??????", image: UIImage(systemName: "pencil")) { action in
                
                var textField = UITextField()
                
                let alert = UIAlertController(title: "????????? ?????? ??????", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "??????", style: .cancel) { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                let confirm = UIAlertAction(title: "??????", style: .default) { confirm in
                    do {
                        try self.realm.write({
                            if let selectedFridge = self.realm.objects(Fridge.self).filter("id == %@", self.fridges![indexPath.item].id).first {
                                selectedFridge.name = textField.text!
                            }
                        })
                    } catch {
                        print("Error occured in writing. \(error)")
                    }
                    self.collectionView.reloadData()
                }
                
                alert.addTextField { field in
                    field.placeholder = "????????? ????????? ????????? ???????????????."
                    field.text = self.fridges![indexPath.item].name
                    textField = field
                }
                alert.addAction(cancel)
                alert.addAction(confirm)
                
                self.present(alert, animated: true, completion: nil)
            }
            let deleteBtn = UIAction(title: "??????", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
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
        
        let alert = UIAlertController(title: "????????? ????????????", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "??????", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        let confirm = UIAlertAction(title: "??????", style: .default) { confirm in
            do {
                try self.realm.write({
                    let newFridge = Fridge()
                    newFridge.id = (self.realm.objects(Fridge.self).max(ofProperty: "id") ?? 0) + 1
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
            field.placeholder = "????????? ????????? ???????????????."
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
