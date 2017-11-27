import UIKit
import Firebase
import FirebaseDatabase

class SearchGroupsViewController: UIViewController, UISearchBarDelegate {

    let groups : [Groups] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        let ref = Database.database().reference()
        ref.child("group").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value as? NSDictionary != nil{
                let dict = snapshot.value as! NSDictionary
                let names = (dict.allKeys.flatMap{ dict.value(forKey: String(describing: $0)) } as? [NSDictionary])?.flatMap{ $0.value(forKey: "name") } as? [String]
                if (names?.contains(text))! {
                    
                }else {
                    return
                }
            }
        
    })
}
}

extension SearchGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CellGroups
        cell.nameGroup.text = groups[indexPath.row].name
        cell.imageGroup.sd_setImage(with: groups[indexPath.row].imageURL, completed: nil)
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.size.width / 2
        cell.imageGroup.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
}
