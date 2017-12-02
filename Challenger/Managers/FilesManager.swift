//
//  ImageUploaderManager.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 27/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class FilesManager: NSObject {
    
    func uploadImage(_ image: UIImage, completionBlock: @escaping (_ url: URL?,_ imageID: String?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        //let imageName = "\().jpg"
        let autoID = Database.database().reference().childByAutoId().key
        let imagesReference = storageReference.child("UploadedImages").child(autoID)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            _ = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), autoID, nil)
                }else {
                    completionBlock(nil,nil, error?.localizedDescription)
                }
            })
            
        }else {
            completionBlock(nil,nil, "Image not converted to Data.")
        }
    }
    func uploadArchive(archive: Archive){
        
        let ref = Database.database().reference()
        let archiveReference = ref.child("archives")
        
        let key = ref.childByAutoId().key
        archive.archiveID = key
        
        let post = ["groupID" : archive.groupID,
                    "name" : archive.name, "date": archive.date,
                    "archive" : archive.archive, "type" : archive.type] as [String : Any]
        
        archiveReference.child(archive.groupID!).child(key).setValue(post)
    }
//    func receiveArchive(type : String) -> Archive?{
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let archiveRef = storageRef.child("UploadedImages/archive.png")
//        archiveRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
//            if let error = error {
//
//            }else {
//                if(type == "Archive"){
//                    let archive = UIImage(data : data!)
//                }else{
//                    let archive = UILabel(
//                }
//
//            }
//        }
//    }
}
