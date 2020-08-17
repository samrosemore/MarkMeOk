//
//  LoadingView.swift
//  ArtUOKV3
//
//  Created by Josh Rosemore on 7/28/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct LoadingView:UIViewRepresentable
{
    @ObservedObject var loadingStatus:LoadingStatus
    
    func makeUIView(context: Context) -> UIActivityIndicatorView
    {
        let loadingIcon = UIActivityIndicatorView(style: .large)
        loadingIcon.color = UIColor.black
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context)
    {
        if(self.loadingStatus.isLoading)
        {
            uiView.startAnimating()
        }
        else
        {
            uiView.stopAnimating()
        }
        
    }
}
