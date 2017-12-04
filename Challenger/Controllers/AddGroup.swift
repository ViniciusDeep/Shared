import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class AddGroup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var didCreateGroup : DidAddGroup? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOutlet.delegate = self
        saveButton.isEnabled = false
    }
    
    func allSelected(){
        if( nameOutlet != nil && imageView != nil){
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
    func sendMedia(image: Data, imageKey: String, completion: @escaping (_ url: URL) -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images/profileImageGroups")
        let imageRef = storageRef.child(imageKey)
        imageRef.putData(image, metadata: nil) {(metadata, error) in
            if error == nil {
                imageRef.downloadURL(completion: { (url, err) in
                    if err == nil {
                        if let url = url {
                            completion(url)
                        }
                    }
                })
            }else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }

        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        saveButton.isEnabled = false
        cancelButton.isEnabled = false
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
        if nameOutlet.text == "" {
            saveButton.isEnabled = true
            cancelButton.isEnabled = true
            return
        }
        guard let image = imageView.image else {
            saveButton.isEnabled = true
            cancelButton.isEnabled = true
            return
        }
        guard let name = nameOutlet.text else {
            return
        }
        
        verifyIfExists(name) { result in
            if !result {
                self.addGroupToFirebase(name, image, completion: {(isConnected) in
                    if isConnected == false {
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                        return
                    }
                })
            } else {
                let alert = UIAlertController(title: "Error", message: "This name is already in use.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.saveButton.isEnabled = true
                self.cancelButton.isEnabled = true
                return
            }
        }
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
        allSelected()
    }
    
    func verifyIfExists(_ name: String, completion: @escaping (_ result: Bool) -> Void)  {
        let ref = Database.database().reference()
        var result : Bool = false
        ref.child("group").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? NSDictionary{
                let names = (dict.allKeys.flatMap{ dict.value(forKey: String(describing: $0)) } as? [NSDictionary])?.flatMap{ $0.value(forKey: "name") } as? [String]
                if snapshot.exists() {
                    let filtered = names?.filter({ (value) -> Bool in
                        value == name
                    })
                    if (filtered?.isEmpty)! {
                        //Doesn`t exists on Firebase
                        result = false
                    }else {
                        //Exists on Firebase
                        result = true
                    }
                } else {
                    result = false
                }
            }
                completion(result)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func addGroupToFirebase(_ name: String,_ image:  UIImage, completion: @escaping(_ isConnected: Bool) -> Void) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            var isConnected : Bool = true
            if !(snapshot.value as? Bool ?? false) {
                //not connected
                let alert = UIAlertController(title: "Error", message: "No internet connection.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                isConnected = false
            }
            completion(isConnected)
        })
        let database = Database.database().reference()
        let key = database.childByAutoId().key
        let uid = Firebase.Auth.auth().currentUser!.uid
        let email = Firebase.Auth.auth().currentUser!.email
       // let user = User(email: email!, image: key, id: uid)
        if let imageData = UIImagePNGRepresentation(image) {
            sendMedia(image: imageData , imageKey: key, completion: {(url) in
                database.child("group").child(key).updateChildValues(["name": name, "image": url.absoluteString, "admin": [uid], "users": [uid], "key" : key])
                self.dismiss(animated: true, completion: {
                self.didCreateGroup?.didAdd(name, key, [uid], [uid], url.absoluteString)
                })
            })
            addGroupToUser(key)
        }else {
            let alert = UIAlertController(title: "Error", message: "Cannot read that image.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    func addGroupToUser(_ key: String) {
        var array  : [String] = []
        let database = Database.database().reference()
        let user = Firebase.Auth.auth().currentUser
        let userRef = database.child("users").child(user!.uid)
        userRef.child("groups").observeSingleEvent(of: .value) { (snapshot) in
            if  let id = snapshot.value as? [String] {
                    array = id
                    array.append(key)
                    userRef.updateChildValues(["groups" : array as NSArray])
                    return
            }
            if let idS = snapshot.value as? String {
                if(snapshot.exists()) {
                    array = [idS]
                    array.append(key)
                    userRef.updateChildValues(["groups" : array as NSArray])
                }
            } else {
                userRef.updateChildValues(["groups":  key])
            }
        }
    }
}

extension AddGroup: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: {self.imageView.image = image})
        
    }
}
