//
//  About.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI

struct About: View {
    var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            Spacer()
            
            HStack
            {
                Spacer()
                    Text("About").font(.system(size: 28)).fontWeight(.bold)
                Spacer()
            }
            Spacer().frame(height:20)
            
            
            Text("MarkMeOK was founded for one purpose... to provide a free yet reliable way for you to check in on your loved ones on a regular basis. Whether your away on a trip, or live acrose the country from your loved ones, enjoy piece of mind with MarkMeOK").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            Spacer().frame(height:10)
            
            Text("Sincerely,").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            Text("The MarkMeOK Team").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            
            Spacer()
        }.background(Color.init("Logo Color"))
        
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
