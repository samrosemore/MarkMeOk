//
//  Group.swift
//  ArtUOKV3
//
//  Created by Josh Rosemore on 8/13/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class Group:ObservableObject, Hashable
{
    static func == (lhs: Group, rhs: Group) -> Bool {
        return true
    }
    
    @Published var pendingUsers:[User] = []
    @Published var checkedInOn:[User] = []
    @Published var users:[User] = []
    @Published var groupName:String = "Hello"
    @Published var groupID:String = ""
    @ObservedObject var defaultStatus:DefualtGroupStatus = DefualtGroupStatus()
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.groupID)
    }
    
    init(id:String)
    {
        self.groupID = id
        
        
    }
    
}
class DefualtGroupStatus: ObservableObject
{
    @Published var isDefualtGroup:Bool = false
}
