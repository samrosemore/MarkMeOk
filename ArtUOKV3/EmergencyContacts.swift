//
//  EmergencyContacts.swift
//  ArtUOKV2
//
//  Created by Sam Rosemore on 5/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI
import Firebase

struct EmergencyContacts: View
{
    
    @ObservedObject var userStorage = UserStorage()
    @ObservedObject var error = CustomError()
    
    

    //Solution is this method!
    init(){
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View
    {
        
        ZStack()
        {
            
            //user already set up
            Color.init("Logo Color")
                
            
           
            ScrollView(.vertical)
            {
                VStack(alignment: .center, spacing: 15)
                {
                        
                        Text("Partipants").fontWeight(.bold).font(.system(size: 28))
                                   
                        Spacer().frame(height: 15)
                          
                   
                    
                    if(!userStorage.groupUsers.isEmpty)
                    {
                        Text("Current Users")
                        List()
                                {
                                      ForEach(userStorage.listDispaly, id: \.self)
                                      {
                                          currentUser in
                        
                                                Text(currentUser).foregroundColor(Color.black)
                                            
                                          
                                      }
                                }.frame(height:100)
                                  
                    }
                    
                    
                    
                    if(!userStorage.checkedInOn.isEmpty)
                    {
                        Text("Users Checked In On")
                               List()
                                   {
                                       ForEach(userStorage.altListDisplay, id: \.self)
                                       {
                                           checkedInOn in
                                           
                                        Text(checkedInOn).foregroundColor(Color.black)
                                       }
                               }.frame(height:100)
                    }
                            
                          
                        
                    
                
                    if(!userStorage.pendingUsers.isEmpty)
                    {
                        
                        
                        Text("Pending Users")
                              List()
                                  {
                                      ForEach(userStorage.altListDisplay2, id: \.self)
                                      {
                                          pendingUser in
                                          
                                        Text(pendingUser).foregroundColor(Color.black)
                                      }
                              }.frame(height:100)
                    }
                
                   Spacer().frame(height:20)
                   Text(self.error.message).font(.system(size: 16)).foregroundColor(Color.red)
                   
                    
                    }
            }
            
                                    
                            
        }
           
                
                
            
        
        
    }

    
    func getData() ->(UserStorage)
    {
        return userStorage
    }
}

struct EmergencyContacts_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContacts()
    }
}
