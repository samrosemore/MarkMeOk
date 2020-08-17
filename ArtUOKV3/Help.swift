//
//  Help.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import SwiftUI

struct Help: View
{
    var body: some View
    {
        ScrollView
        {
                VStack(alignment: .center, spacing: 20)
                {
                       
                    Text("Thank you for choosing Mark Me OK for ensuring your wellbeing").font(.system(size: 24, weight: .heavy, design: .default))
                        
                        Spacer().frame(height: 20)
                    
                        Text("To Start").font(.system(size: 20))
                    
                        Text("Create a 'check in group' by tapping the 'create group button' in the upper left hand corner of your groups screen. When the 'new group page' pops up, please create a name for your group and start adding participants to your group by thier email address (NOTE: This email address must be the email they used to sign up for thier MarkMeOK account. If the paticular email address is not assigned to an account, an option to invite the user will be presented to the user. Finally, make sure to enable check in services for each user you wish to require to check in through the toggle option.  ")
                        Text("Once you press submit, specify your desired requirments for checking in, in the settings page. After you once again press submit, invitations will be sent out to the specified users in the group")
                        Spacer().frame(height: 20)
                    
                    Text("Recieving Invitations").font(.system(size: 20))
                    Text("Once you log in, hit the left invitation icon on your menu (located at the bottom of the screen. All new invitations will appear there and have to be clicked on to accept the invitation")
                       
                }
        }.background(Color.init("Logo Color"))
        
        
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help()
    }
}
