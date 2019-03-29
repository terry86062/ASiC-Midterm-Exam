//
//  AVPlayer - extension.swift
//  ASiC Midterm-Exam Terry
//
//  Created by 黃偉勛 Terry on 2019/3/29.
//  Copyright © 2019 Terry. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        
        return ((rate != 0) && (error == nil))
        
    }
    
}
