//
//  ViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/10.
//

import UIKit
import RealmSwift

class FridgeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let realm = try! Realm()
    var fridges: Results<Fridge>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "FridgeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FridgeCell")
        collectionView.register(UINib(nibName: "FridgeAddCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddFridgeCell")
        
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
            print(f.count + 1)
            return f.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //  show fridge cells
        if let fridges = fridges {
//            print(fridges)
//            print(indexPath.row)
//            print(fridges.count)
            if indexPath.item != fridges.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FridgeCell", for: indexPath) as! FridgeCollectionViewCell
                let fridge = fridges[indexPath.item]
                let image = textOnImage(text: fridge.name, image: UIImage(named: fridge.fridgeImage)!, position: CGPoint.init(x: 10, y: 10))
                
                cell.fridgeImage.image = image
                
                return cell
            } else {
                //  show fridge add button
                print("dd")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFridgeCell", for: indexPath) as! FridgeAddCollectionViewCell
                print(cell)
                
                return cell
            }
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "AddFridgeCell", for: indexPath) as! FridgeAddCollectionViewCell
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
