//
//  ViewController.swift
//  ChattingAVPlayer
//
//  Created by FlowerGeoji on 2018. 2. 13..
//  Copyright © 2018년 FlowerGeoji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var chattingPlayer: ChattingPlayerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let videoUrl = URL.init(string: "https://view.pufflive.me/live/06ed-2018-05-02/1525230403_Yfq0tw.mp4"), let subtitlesUrl = URL.init(string: "https://asset.pufflive.me/subtitles/28995/1525231821/subtitles_06ed-2018-05-02/1525230403_Yfq0tw.vtt") {
      chattingPlayer.replaceVideo(videoUrl: videoUrl, subtitleUrl: subtitlesUrl)
      chattingPlayer.play()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

