//
//  AddItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/19.
//
//  데이트피커 선택 시 레이블 변경
//  데이트피커 선택 시 셀 삭제
import UIKit
import RealmSwift

class AddItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    var currentFridge: Fridge?
    var parentVC: ItemViewController!
    let realm = try! Realm()
    let sectionName: [String] = ["photo", "name", "storeDetail", "dateDetail"]
    let cellName: [[String]] = [["photo"], ["favorite", "name", "memo"], ["quantity", "location"], ["expire date", "boughtDate"]]
    var isExpanded: [Bool] = [false, false]
    var isImage = false
    var image: UIImage?
    var imageName: String = "\(ProcessInfo.processInfo.globallyUniqueString)"
    struct CellStruct {
        var photoCell: AddItemPhotoCell?
        var favoriteCell: FavoriteFieldCell?
        var titleCell: AddItemTextFieldCell?
        var memoCell: AddItemTextFieldCell?
        var countCell: AddItemStepperCell?
        var positionCell: AddItemSegmentCell?
        var expDateCell: AddItemDateCell?
        var expPickerCell: AddItemDatePickerCell?
        var buyDateCell: AddItemDateCell?
        var buyPickerCell: AddItemDatePickerCell?
    }
    var cells: CellStruct!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        
        navBar.shadowImage = UIImage()
//        navBar.setNeedsLayout()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cells = CellStruct()
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
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtnPressed(_ sender: UIBarButtonItem) {
        // need to do form validation
        var originalImageName = ""
        var thumbnailImageName = ""
        guard let name = cells.titleCell?.textField.text, name.count != 0 else { return }
        
        if isImage, let image = self.image {
            
            originalImageName = imageName + ".jpeg"
            thumbnailImageName = imageName + "_thumb.jpeg"
            
            ImageFileManager.shared.saveImage(image: image, name: originalImageName) { _ in }
            ImageFileManager.shared.saveImage(image: ImageFileManager.shared.resizeImage(of: image, for: 70), name: thumbnailImageName) { _ in }
        } else {
            originalImageName = imageName + ".jpeg"
            thumbnailImageName = imageName + "_thumb.jpeg"
            
            image = ImageFileManager.shared.generateImage(color: UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 0.5))
            ImageFileManager.shared.saveImage(image: image!, name: originalImageName) { _ in }
            ImageFileManager.shared.saveImage(image: ImageFileManager.shared.resizeImage(of: image!, for: 70), name: thumbnailImageName) { _ in }
        }
        
        do {
            try self.realm.write {
                let newItem = Item()
                newItem.id = (self.realm.objects(Item.self).max(ofProperty: "id") ?? 0) + 1
                newItem.name = name
                newItem.itemImage = originalImageName
                newItem.itemThumbnail = thumbnailImageName
                newItem.memo = cells.memoCell?.textField.text ?? ""
                newItem.favorite = cells.favoriteCell?.fSwitch.isOn ?? false
                newItem.quantity = Int((cells.countCell?.valueLabel.text)!) ?? 0
                newItem.expireDate = cells.expDateCell?.date ?? Date()
                newItem.boughtDate = cells.buyDateCell?.date ?? Date()
                newItem.itemLocation = cells.positionCell?.segment.selectedSegmentIndex ?? 0
                currentFridge?.items.append(newItem)
                
                self.realm.add(newItem)
            }
        } catch {
            print("Error occured in Writing Item. \(error)")
        }
        parentVC.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, isImage {
            return cellName[section].count + 1
        }
        if section == 3 {
            if isExpanded[0], isExpanded[1] {
                return cellName[section].count + 2
            } else if isExpanded[0] || isExpanded[1] {
                return cellName[section].count + 1
            } else {
                return cellName[section].count
            }
        }
        return cellName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cell = UITableViewCell()
        cell.isUserInteractionEnabled = true
//        print(indexPath.row)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let photoCell = AddItemPhotoCell(cell, "사진 추가")
                
                let takePhotoAction = UIAction(title: "사진 촬영", image: UIImage(systemName: "camera"), handler: presentCamera(_:))
                let cancelAction = UIAction(title: "취소", attributes: .destructive) { _ in
                    print("cancel")
                }
                photoCell.button!.showsMenuAsPrimaryAction = true
                photoCell.button!.menu = UIMenu.init(
                    title: "사진 추가",
                    image: UIImage(systemName: "camera"),
                    identifier: nil,
                    options: .displayInline,
                    children: [takePhotoAction, cancelAction]
                )
                
                cells.photoCell = photoCell
                cell = photoCell.cell
            } else if indexPath.row == 1 {
                let imageCell = AddItemImageCell(cell, self.image!)
                cell = imageCell.cell
            }
        case 1:
            if indexPath.row == 0 {
                let favoriteCell = FavoriteFieldCell(cell, "유통기한 알림")
                cells.favoriteCell = favoriteCell
                cell = favoriteCell.cell
                
            } else if indexPath.row == 1 {
                let nameCell = AddItemTextFieldCell(cell, "이름")
                cells.titleCell = nameCell
                cell = nameCell.cell
                
            } else if indexPath.row == 2 {
                let memoCell = AddItemTextFieldCell(cell, "메모")
                cells.memoCell = memoCell
                cell = memoCell.cell
            }
        case 2:
            if indexPath.row == 0 {
                let quantityCell = AddItemStepperCell(cell, "수량")
                cells.countCell = quantityCell
                cell = quantityCell.cell
            } else if indexPath.row == 1 {
                // TODO: 보관 장소 선택
                let segmentCell = AddItemSegmentCell(cell, currentFridge!.name)
                cells.positionCell = segmentCell
                cell = segmentCell.cell
            }
        case 3:
            if indexPath.row == 0 {
                
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                let expireDateCell = AddItemDateCell(cell, "유통기한")
                cells.expDateCell = expireDateCell
                cell = expireDateCell.cell
                
            } else if indexPath.row == 1 {
                if isExpanded[0] {
                    
                    let expireDatePickerCell = AddItemDatePickerCell(cell)
                    expireDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                    
                    expireDatePickerCell.datePicker.date = cells.expDateCell!.date
                    
                    cells.expPickerCell = expireDatePickerCell
                    cell = expireDatePickerCell.cell
                    
                } else {
                    
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                    let boughtDateCell = AddItemDateCell(cell, "구매일자")
                    cells.buyDateCell = boughtDateCell
                    cell = boughtDateCell.cell
                    
                }
                
            } else if indexPath.row == 2 {
                if isExpanded[0] {
                    
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                    let boughtDateCell = AddItemDateCell(cell, "구매일자")
                    cells.buyDateCell = boughtDateCell
                    cell = boughtDateCell.cell
                } else {
                    
                    let boughtDatePickerCell = AddItemDatePickerCell(cell)
                    boughtDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                    
                    boughtDatePickerCell.datePicker.date = cells.buyDateCell!.date
                    
                    cells.buyPickerCell = boughtDatePickerCell
                    cell = boughtDatePickerCell.cell
                    
                }
            } else if indexPath.row == 3 {
                
                let boughtDatePickerCell = AddItemDatePickerCell(cell)
                boughtDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
                
                boughtDatePickerCell.datePicker.date = cells.buyDateCell!.date
                
                cells.buyPickerCell = boughtDatePickerCell
                cell = boughtDatePickerCell.cell
                
            }
        default: break
        }
        
//        cell.backgroundColor = .blue.withAlphaComponent(0.2)
        cell.selectionStyle = .none
        return cell
    }
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        
        if let expPicker = cells.expPickerCell, let expDate = cells.expDateCell {
            expDate.date = expPicker.datePicker.date
            expDate.setDateLabel()
        }
        if let buyPicker = cells.buyPickerCell, let buyDate = cells.buyDateCell {
            buyDate.date = buyPicker.datePicker.date
            buyDate.setDateLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var row2 = 2
        if isImage, indexPath.section == 0, indexPath.row == 1 {
            if let height = self.image?.size.height {
                return height + 10
            } else {
                return 310
            }
        }
        if isExpanded[0] {
            row2 += 1
            if indexPath.section == 3, indexPath.row == 1 {
                return 250
            }
        }
        if isExpanded[1] {
            if indexPath.section == 3, indexPath.row == row2 {
                return 250
            }
        }
        return tableView.rowHeight
    }
    
    // 날짜 셀 클릭시 expand
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var row2 = 1
        
        if isExpanded[0] {
            row2 += 1
        }
        if indexPath.section == 3, indexPath.row == 0 {
            isExpanded[0] = !isExpanded[0]
            if isExpanded[0] {
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 1, section: 3)], with: .fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: 1, section: 3)], with: .fade)
                tableView.endUpdates()
            }
        } else if indexPath.section == 3, indexPath.row == row2 {
            isExpanded[1] = !isExpanded[1]
            if isExpanded[1] {
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: row2+1, section: 3)], with: .fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: row2+1, section: 3)], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
}
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentCamera(_ action: UIAction) {
        
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.cameraCaptureMode = .photo
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.delegate = self
        
        present(camera, animated: true, completion: nil)
    }
    
    //  이미지피커(사진촬영)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            isImage = true
            self.image = ImageFileManager.shared.resizeImage(of: image)
//            self.imageName = "\(ProcessInfo.processInfo.globallyUniqueString)"
//            cells.photoCell?.imageName = "\(ProcessInfo.processInfo.globallyUniqueString)"
//            print(cells.photoCell?.imageName)
        }
        picker.dismiss(animated: true)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
}

