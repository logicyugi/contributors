//
//  ViewController.swift
//  Contributeurs
//
//  Created by Antoine El Samra on 28/09/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var profiles = [Profile]()
     var currentPage = 1
     let perPage = 50
     var isLoading = false
     
    @IBOutlet weak var repo: UITextField!
    
    @IBOutlet weak var owner: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         tableView.dataSource = self
         getAllProfiles()
     }
    
    //CoreData
    func getAllProfiles() {
        do {
            profiles = try context?.fetch(Profile.fetchRequest()) ?? [Profile]()
            
            DispatchQueue.main.async {
                if self.profiles.count >= 0 {
                    self.loadMoreData()
                }
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
    }
    
    func createProfiles(profile: [JSONProfile]) {
        guard (context != nil) else {return}
        for newProfile in profile {
            let newCDProfile = Profile(context: context!)
            newCDProfile.login = newProfile.login
            newCDProfile.avatarURL = newProfile.avatarURL
            if newProfile.organizations_url != nil {
                let tmpIndex = newProfile.organizations_url!.absoluteString.lastIndex(of: "/") ??
                newProfile.organizations_url!.absoluteString.startIndex
                newCDProfile.organizations = String(newProfile.organizations_url!.absoluteString.suffix(from: tmpIndex).dropFirst())
            }
            newCDProfile.url = newProfile.url
            do {
                try context?.save()
            }
            catch {
                //error
            }
        }
    }
    
    
    //Data
     func loadMoreData() {
         isLoading = true
         loadingIndicator.startAnimating()
         loadingIndicator.isHidden = false
         
         APIManager().loadProfiles(page: currentPage, perPage: perPage, owner: owner.text ?? "", repo: repo.text ?? "", completion: { [weak self] newProfiles in
             self?.createProfiles(profile: newProfiles)
             self?.isLoading = false
             
             DispatchQueue.main.async {
                 self?.loadingIndicator.stopAnimating()
                 self?.loadingIndicator.isHidden = true
                 self?.tableView.reloadData()
             }
         })
     }
     
    
    //TableView
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return profiles.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
         
         let profile = profiles[indexPath.row]
         cell.title.text = profile.login
         cell.subtitle.text = profile.organizations
         cell.avatar?.downloaded(from: profile.avatarURL)
         return cell
     }
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         
         if offsetY > contentHeight - scrollView.frame.height {
             if !isLoading {
                 currentPage += 1
                 loadMoreData()
             }
         }
     }
}

