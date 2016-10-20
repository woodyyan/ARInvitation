//
//  PlayerView.swift
//  ARInvitation
//
//  Created by Songbai Yan on 20/10/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerView: UIView {
    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
    }
}
