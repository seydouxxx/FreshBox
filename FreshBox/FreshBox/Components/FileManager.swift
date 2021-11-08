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
    
    //  이미지 리사이징(디폴트: width == 300)
    func resizeImage(of image: UIImage, for newWidth: CGFloat = 300) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func generateImage(color: UIColor, size: CGFloat = 300) -> UIImage {
        let square = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        color.setFill()
        UIRectFill(square)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
