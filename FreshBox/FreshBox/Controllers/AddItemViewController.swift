//
//  AddItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/19.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentFridge: Fridge?
    let sectionName: [String] = ["photo", "name", "storeDetail", "dateDetail"]
    let cellName: [[String]] = [["photo"], ["favorite", "name", "memo"], ["quantity", "location"], ["expire date", "boughtDate"]]
    var cells: [AddItemCell] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        print(currentFridge!.name)
        // Do any additional setup after loading the view.
        
    }
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtnPressed(_ sender: UIBarButtonItem) {
        // need to do form validation
        
        
        for cell in cells {
            switch cell {
            case is AddItemPhotoCell:
                print("Photo Data!")
            case is FavoriteFieldCell:
                print((cell as! FavoriteFieldCell).fSwitch.isOn)
            case is AddItemTextFieldCell:
                print((cell as! AddItemTextFieldCell).textField.text ?? "")
            case is AddItemStepperCell:
                print((cell as! AddItemStepperCell).valueLabel.text ?? "")
                
            default: break
            }
        }
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
extension AddItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        print(indexPath.row)
        
        switch indexPath.section {
        case 0:
            let photoCell = AddItemPhotoCell(cell, "사진 추가")
            cells.append(photoCell)
            cell = photoCell.cell
        case 1:
            if indexPath.row == 0 {
                let favoriteCell = FavoriteFieldCell(cell, "즐겨찾기")
                cells.append(favoriteCell)
                cell = favoriteCell.cell
                
            } else if indexPath.row == 1 {
                let nameCell = AddItemTextFieldCell(cell, "이름")
                cells.append(nameCell)
                cell = nameCell.cell
                
            } else if indexPath.row == 2 {
                let memoCell = AddItemTextFieldCell(cell, "메모")
                cells.append(memoCell)
                cell = memoCell.cell
            }
            
        case 2:
            if indexPath.row == 0 {
                let quantityCell = AddItemStepperCell(cell, "수량")
                cells.append(quantityCell)
                cell = quantityCell.cell
            } else if indexPath.row == 1 {
                
            }
        case 3:
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                
            }
        default: break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
}
