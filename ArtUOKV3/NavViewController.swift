//
//  NavigationController.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import FirebaseAuth

class NavViewController:UIViewController
{
    var menu:SideMenuNavigationController?
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: MenuViewListController())
        menu!.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        
        
        
        
        
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    @IBAction func didTapMenu()
    {
        present(menu!, animated: true)
    }
}

class MenuViewListController: UITableViewController
{
    var items = ["Sign Out", "New Group", "FAQ", "Tutorial", "About"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.highlightedTextColor = UIColor.init(named: "Grayish")
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do something really cool here
        
        
        let chosen = items[indexPath.row]
        
        if(chosen == "Sign Out")
        {
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let newVC =  storyboard.instantiateViewController(withIdentifier: "Login")
                newVC.modalPresentationStyle = .fullScreen
                newVC.isModalInPresentation = true
                self.present(newVC, animated: true, completion: nil)
                print("created new user")
                
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
        else if(chosen == "New Group")
        {
            let storyBoard = UIStoryboard(name: "GroupsListings", bundle: nil)
            let chosenVC = storyBoard.instantiateViewController(identifier: "NewGroup")
            self.present(chosenVC, animated: true)
        }
        else
        {
            let storyBoard = UIStoryboard(name: "GroupsListings", bundle: nil)
            let chosenVC = storyBoard.instantiateViewController(identifier: chosen)
            self.present(chosenVC, animated: true)
        }
        
        
    }
    
    
    
}
