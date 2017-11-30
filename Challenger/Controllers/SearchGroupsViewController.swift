import UIKit
import Firebase
import FirebaseDatabase
import HandyJSON

let dictionary = [String: String]()

class SearchGroupsViewController: UIViewController, UISearchBarDelegate {

    var groups : [Group] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else { return }
        if let controller = nav.topViewController  as? CalendarController {
            guard let index = sender as? Int else { return }
            controller.group = groups[index]
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !groups.isEmpty {
            self.groups.remove(at: 0)
            self.tableView.reloadData()
        }
        guard let text = searchBar.text else {
            return
        }
        let ref = Database.database().reference()
        ref.child("group").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            
            let keys = snapshots.map { $0.key }
            
            var groups = (snapshots.flatMap { Group.deserialize(from: $0.value as? NSDictionary) })
                .enumerated()
                .flatMap { index, group -> Group in
                    group.key = keys[index]
                    return group
            }
            let group = groups.filter { $0.name! == text }.first
            if let group = group {
                self.groups.append(group)
                self.tableView.reloadData()
            }
        })
    }
}

extension SearchGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CellGroups
        cell.nameGroup.text = groups[indexPath.row].name
        let url = URL(string: groups[indexPath.row].image! )
        cell.imageGroup.sd_setImage(with: url, completed: nil)
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.size.width / 2
        cell.imageGroup.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupSelected", sender: indexPath.row)
    }
    
}
