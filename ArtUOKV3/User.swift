//
//  User.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class User: ObservableObject, Hashable
{
    
    @ObservedObject var checkInStatus:CheckInStatus = CheckInStatus(status: false)
    @Published var ID:String
    @Published var displayName:String
    @Published var pending:Bool
    
    static func == (lhs: User, rhs: User) -> Bool
    {
        return true
    }
    
    init(ID: String, displayName: String, pending: Bool)
    {
        self.ID = ID
        self.displayName = displayName
        self.pending = pending
    }
    
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.ID)
    }
    
    
    
}


