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
//    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var realm = try! Realm()
    var items: Results<Item>?
    var searchedItems: Results<Item>?
    var selectedFridge: Fridge?
    //0: 이름순, 1: 유통기한 임박순, 2: 등록일순
    var currentSort = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 50.0
        
        title = selectedFridge!.name
        self.loadData()
        
        setKeyboardDismiss()
        self.tableView.keyboardDismissMode = .onDrag
        
        // 서치바 스코프
//        searchController.definesPresentationContext = true
//        searchController.automaticallyShowsScopeBar = true
//        tableView.tableHeaderView = searchController.searchBar
        searchBar.delegate = self
//        segmentViewInit()
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
    
    //MARK: - Load Data From Realm
    func loadData(_ searched: Bool = false, _ queryString: String = "") {
        if searched {
            items = selectedFridge?.items.filter("name CONTAINS[cd] %@", queryString).sorted(byKeyPath: "createdDate")
        } else {
            items = selectedFridge?.items.sorted(byKeyPath: "createdDate")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addItemVC = segue.destination as! AddItemViewController
        addItemVC.currentFridge = selectedFridge!
        addItemVC.parentVC = self
    }
}
extension ItemViewController: UITableViewDelegate {
    
}
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        guard let item = items?[indexPath.row] else { return UITableViewCell() }
        
        cell.titleLabel.text = item.name
        cell.detailLabel.text = item.memo
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let filterView = UIStackView()
            filterView.axis = .vertical
            filterView.alignment = .trailing
            filterView.distribution = .fillEqually
            
            let segmentControl = UISegmentedControl(items: ["모두", "냉장", "냉동", "기타"])
            
            let filterBtn = UIButton()
            filterBtn.setTitle("이름순↓", for: .normal)
            filterBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.9)
            filterBtn.setTitleColor(.systemBlue, for: .normal)
            
            filterView.addArrangedSubview(segmentControl)
            filterView.addArrangedSubview(filterBtn)
            
            segmentControl.translatesAutoresizingMaskIntoConstraints = false
            segmentControl.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 20.0).isActive = true
            segmentControl.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -20.0).isActive = true
            
            filterBtn.translatesAutoresizingMaskIntoConstraints = false
            filterBtn.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -20.0).isActive = true
            return filterView
        }
        return UIView()
    }
    
}

// 검색창 델리게이트
extension ItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            loadData(true, searchText)
        } else if searchBar.text?.count == 0 {
            loadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selected scope is \(selectedScope)")
    }
    func segmentViewInit() {
        let segmentView = UIView()
        let segmentControl = UISegmentedControl(items: ["모두", "냉장", "냉동", "기타"])
        
        segmentView.addSubview(segmentControl)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerYAnchor.constraint(equalTo: segmentView.centerYAnchor).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: segmentView.centerXAnchor).isActive = true
        
        tableView.tableHeaderView = segmentView
    }
}
