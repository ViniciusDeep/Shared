import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class AddGroup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var didCreateGroup : DidAddGroup? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        nameOutlet.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Send Media
    func sendMedia(image: Data) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/image.png")
        imageRef.putData(image, metadata: nil) {(metadata, error) in
            guard let err = error else{
                return
            }
    }
    }
    
    //End Send Media
    
    //Receive media
    func receiveMedia() -> UIImage?{
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/image.png")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
     
                let image = UIImage(data: data!)
                self.imageView.image = image
                
            }
        }
        return nil
    }
    
    //Buttons
    @IBAction func save(_ sender: UIBarButtonItem) {
        let database = Database.database().reference()
//        let storageRef = database.reference()
        guard let name = nameOutlet.text else {
            return
        }
        let key = database.childByAutoId().key
        database.child("group").child(key).updateChildValues(["name": name])
        guard let image = imageView else {
            return
        }
   //     sendMedia(image: UIImagePNGRepresentation(image.image!)!)
        self.dismiss(animated: true, completion: {self.didCreateGroup?.didAdd(name, image)})
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.layer.masksToBounds = true
    }
    @IBAction func cameraButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}
//End buttons

extension AddGroup: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: {self.imageView.image = image})
    }
}
