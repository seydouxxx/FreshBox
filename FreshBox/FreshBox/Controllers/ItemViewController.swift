//
//  ItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/18.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    var realm = try! Realm()
    var selectedFridge: Fridge?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = selectedFridge!.name
        
        
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
