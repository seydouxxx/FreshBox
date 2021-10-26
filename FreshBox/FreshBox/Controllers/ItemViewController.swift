//
//  ItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/18.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    var items: Results<Item>?
    var selectedFridge: Fridge?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = selectedFridge!.name
        self.loadData()
    }
    
    func loadData() {
        items = realm.objects(Item.self)
        tableView.reloadData()
        print(items)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addItemVC = segue.destination as! AddItemViewController
        addItemVC.currentFridge = selectedFridge!
    }
}
extension ItemViewController: UITableViewDelegate {
    
}
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        return cell
    }
    
    
}
extension ItemViewController: UISearchBarDelegate {
}
