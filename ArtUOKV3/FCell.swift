//
//  FCell.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/23/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class FCell:ObservableObject, Hashable
{
    static func == (lhs: FCell, rhs: FCell) -> Bool {
        return true
    }
    
    @Published var question:String?
    @Published var answer:String?
    @ObservedObject var visibilityStatus = VisibilityStatus()
    
    init(question:String, answer:String)
    {
        self.question = question
        self.answer = answer
        
        
        
    }
    func show()
    {
        visibilityStatus.showCell = true
    }
    func hide()
    {
        visibilityStatus.showCell = false
    }
    
    func hash(into hasher: inout Hasher)
       {
          hasher.combine(self.question!)
       }
    
}


