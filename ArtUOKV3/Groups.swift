//
//  Groups.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/9/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct Groups: View
{
    @ObservedObject var userStorage = UserStorage()
    //@ObservedObject var converter = Converter(userStorage: userStorage)
    var vc:RevViewController?
    
    init()
    {
              
           UITableView.appearance().backgroundColor = UIColor.init(named: "Logo Color")
           UITableViewCell.appearance().backgroundColor = UIColor.init(named: "Logo Color")
           UITableView.appearance().tableFooterView = UIView()
           UITableView.appearance().separatorColor = .black
          }
   
    
    
    var body: some View
    {
        VStack {
            NavigationView
            {
                List() {
                    ForEach(userStorage.listDispaly, id: \.self)
                    {
                        group in
                        
                        HStack
                            {
                                Text(group)
                                Spacer()
                        }.contentShape(Rectangle()).onTapGesture
                            {
                            print("stuff just happened")
                            
                            
                            
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                
                            
                            let vc : RootTabController = (storyboard.instantiateViewController(withIdentifier: "HomeLanding") as? RootTabController)!
                            
                                
                            //saving the group id
                            let index = self.userStorage.listDispaly.firstIndex(of: group)
                            let groupId = self.userStorage.groupIDs[index!]
                            
                            vc.groupName = groupId
                                
                            self.vc!.present(vc, animated: true, completion: nil)
                            
                        }
                        
                        
                    }
                }.navigationBarTitle(Text("Groups"))
                    .navigationBarItems(trailing: Button(action:
                    {
                        let storyboard = UIStoryboard(name: "GroupsListings", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "NewGroup")
                        self.vc!.present(vc, animated: true, completion:nil)
                        
                    }, label: {
                        Text("Add New Group")
                    }))
                
                
            }
            
           
        }
        
    }
    func addNewGroup()
    {
        print("wow this worked")
    }
    func getData() ->(UserStorage)
    {
         return userStorage
    }
    mutating func setVC(vc:RevViewController)
    {
        self.vc = vc
    }
    
    
}

struct Groups_Previews: PreviewProvider {
    static var previews: some View {
        Groups()
    }
}

