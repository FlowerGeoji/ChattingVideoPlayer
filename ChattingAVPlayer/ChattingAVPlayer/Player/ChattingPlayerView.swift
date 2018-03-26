//
//  ChattingPlayerView.swift
//  ChattingAVPlayer
//
//  Created by FlowerGeoji on 2018. 3. 26..
//  Copyright © 2018년 FlowerGeoji. All rights reserved.
//

import UIKit
import AVKit

class ChattingPlayerView: UIView {
  private let playerLayer: AVPlayerLayer = AVPlayerLayer()
  private let player: AVPlayer = AVPlayer.init()
  private var subtitlesParser: SubtitlesParser?
  private let tableViewChats: UITableView = UITableView()
  
  private var timeObserver: Any?
  private let queue: DispatchQueue = DispatchQueue.init(label: "AVCPV_QUEUE")
  public var chatsIntervalSecond: Double = 1.0
  
  private let keyOfCellChat = "CellChatIdentifier"
  private(set) var chats: [String] = [] { didSet { self.tableViewChats.reloadData() } }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }
  
  private func commonInit() {
    self.backgroundColor = .black
    
    // Set AVPlayer
    playerLayer.player = player
    self.layer.insertSublayer(playerLayer, at: 0)
    playerLayer.frame = self.bounds
    
    // Set Chat's tableView
    self.addSubview(tableViewChats)
    tableViewChats.translatesAutoresizingMaskIntoConstraints = false
    tableViewChats.delegate = self
    tableViewChats.dataSource = self
    tableViewChats.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
    tableViewChats.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    tableViewChats.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    tableViewChats.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    tableViewChats.separatorStyle = .none
    tableViewChats.backgroundColor = .clear
  }
  
  public func replaceVideo(videoUrl: URL, subtitleUrl: URL? = nil) {
    // replace chats
    chats = []
    
    // replace video source
    let video: AVPlayerItem = AVPlayerItem(url: videoUrl)
    player.replaceCurrentItem(with: video)
    
    // replace subtitles
    subtitlesParser = nil
    if let timeObserver = timeObserver {
      player.removeTimeObserver(timeObserver)
      self.timeObserver = nil
    }
    
    if let subtitleUrl = subtitleUrl {
      subtitlesParser = SubtitlesParser(file: subtitleUrl, encoding: .utf8)
      
      let interval = CMTime(seconds: self.chatsIntervalSecond, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: self.queue, using: { [weak self] (time) in
        guard let strongSelf = self else {
          return
        }
        strongSelf.handleSubtitles(seconds: time.seconds)
      })
    }
  }
  
  private func handleSubtitles(seconds: TimeInterval) {
    guard let subtitlesParser = self.subtitlesParser else {
      return
    }
    
    let subtitles = subtitlesParser.readNextSubtitles(to: seconds)
    
    DispatchQueue.main.sync {
      // Code for UI
      if subtitles.count > 0 {
        self.chats.append(contentsOf: subtitles)
      }
    }
  }
  
  public func play() {
    self.player.play()
  }
  
  public func pause() {
    self.player.pause()
  }
}

extension ChattingPlayerView: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.chats.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
}
