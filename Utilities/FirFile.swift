//
//  FirFile.swift
//  coRetail
//
//  Created by Abdalrahim Abdullah on 04/08/2019.
//  Copyright © 2019 Abdalrahim Abdullah. All rights reserved.
//

import UIKit
import Firebase

class FirFile: NSObject {
    
    /// Singleton instance
    static let shared: FirFile = FirFile()
    
    /// Current uploading task
    var currentUploadTask: StorageUploadTask?
    
    func upload(data: Data,
                atPath path:StorageReference,
                block: @escaping (_ url: String?) -> Void) {
        
        // Upload the file to the path
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.currentUploadTask = path.putData(data, metadata: metadata) { (metaData, error) in
            
            // Metadata contains file metadata such as size, content-type.
            // let size = metadata.size
            // You can also access to download URL after upload.
            path.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    block(nil)
                    return
                }
                block(downloadURL.absoluteString)
            }
        }
    }
    
    func cancel() {
        self.currentUploadTask?.cancel()
    }
}
