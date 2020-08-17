//
//  DataChannel.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 6/10/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI

class DataChannel: ObservableObject
{
    @Published var groupName:String = ""
    @Published var groupUserIDs:[String] = []
    @Published var groupID:String = ""
    @Published var hostName:String = ""
    
    @Published var adminPriv = false
    
    @Published var initialBootup = false;
    
    
    init()
    {
        
    }
    init(groupName: String)
    {
        self.groupName = groupName
    }
}
