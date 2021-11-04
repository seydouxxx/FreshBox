//
//  FileManager.swift
//  FreshBox
//
//  Created by Seydoux on 2021/11/03.
//

import Foundation
import UIKit

class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    
    func saveImage(image: UIImage, name: String, onSuccess: @escaping ((Bool) -> Void)) {
        guard let data: Data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        
        if let directory: NSURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL {
            do {
                try data.write(to: directory.appendingPathComponent(name)!)
                onSuccess(true)
            } catch {
                print("Error occured in writing image to local storage. \(error)")
                onSuccess(false)
            }
        }
    }
    
    func loadImage(name: String) -> UIImage? {
        if let dir: URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let path: String = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path
            
            let image: UIImage? = UIImage(contentsOfFile: path)
            
            return image
        }
        return nil
    }
}
