//
//  ImageService.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ImageService {
    
    static func downloadImage(withURL url: URL, completion: @escaping (_ image:UIImage?)->()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            var downloadedImage: UIImage?
            if let data = data {
                if let image = UIImage(data: data) {
                    downloadedImage = image
                }
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
}
