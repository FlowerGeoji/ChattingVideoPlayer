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
  private let tableViewChats: UITableView = UITableView()
  private let slider: UISlider = UISlider()
  
  private var subtitlesParser: SubtitlesParser?
  private var timeObserver: Any?
  public var chatsIntervalSecond: Double = 1.0
  
  private let keyOfDefaultCellChat = "DEFAULT_CAHT_CELL"
  private let keyOfCustomCellChat = "CUSTOM_CAHT_CELL"
  private(set) var chats: [String] = [] { didSet(oldVal) { self.didSetChats(oldVal: oldVal) } }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
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
    tableViewChats.separatorStyle = .none
    tableViewChats.register(CellChatDefault.self, forCellReuseIdentifier: keyOfDefaultCellChat)
    tableViewChats.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
    tableViewChats.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    tableViewChats.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    tableViewChats.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    
    self.addSubview(slider)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.isContinuous = false
    slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
    slider.heightAnchor.constraint(equalToConstant: 10).isActive = true
    slider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    slider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    slider.bottomAnchor.constraint(equalTo: tableViewChats.topAnchor).isActive = true
  }
  
  public func replaceVideo(videoUrl: URL, subtitleUrl: URL? = nil) {
    // replace chats
    chats.removeAll()
    
    // replace video source
    let video: AVPlayerItem = AVPlayerItem(url: videoUrl)
    player.replaceCurrentItem(with: video)
    slider.maximumValue = Float.init(CMTimeGetSeconds(video.asset.duration))
    
    // replace subtitles
    subtitlesParser = nil
    if let timeObserver = timeObserver {
      player.removeTimeObserver(timeObserver)
      self.timeObserver = nil
    }
    
    if let subtitleUrl = subtitleUrl {
      subtitlesParser = SubtitlesParser(file: subtitleUrl, encoding: .utf8)
      
      let interval = CMTime(seconds: self.chatsIntervalSecond, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.init(label: "PlayerTimerQueue"), using: { [weak self] (time) in
        guard let strongSelf = self else {
          return
        }
        
        guard let subtitlesParser = strongSelf.subtitlesParser else {
          return
        }
        
        if strongSelf.chats.count > 50 {
          DispatchQueue.main.sync {
            // Code for UI
            strongSelf.chats.removeFirst(25)
          }
        }
        let subtitles = subtitlesParser.readNextSubtitles(to: time.seconds)
        
        DispatchQueue.main.sync {
          // Code for UI
          strongSelf.chats.append(contentsOf: subtitles)
        }
      })
    }
  }
  
  private func didSetChats(oldVal: [String]) {
    if self.chats.count <= 0 {
      self.tableViewChats.reloadData()
      return
    }
    
    if oldVal.count < self.chats.count {
      // added
      var insertPaths: [IndexPath] = []
      for i in oldVal.count ..< self.chats.count {
        insertPaths.append(IndexPath.init(row: i, section: 0))
      }
      self.tableViewChats.insertRows(at: insertPaths, with: .fade)
      self.tableViewChats.scrollToRow(at: IndexPath.init(row: self.chats.count-1, section: 0), at: .bottom, animated: true)
    }
    
    if oldVal.count > self.chats.count {
      // deleted
      var deletePaths: [IndexPath] = []
      for i in 0 ..< (oldVal.count - self.chats.count) {
        deletePaths.append(IndexPath.init(row: i, section: 0))
      }
      self.tableViewChats.deleteRows(at: deletePaths, with: .none)
    }
  }
  
  public func play() {
    self.player.play()
  }
  
  public func pause() {
    self.player.pause()
  }
  
  @objc private func didChangeSliderValue(slider: UISlider) {
    let time: TimeInterval = TimeInterval.init(slider.value)
    self.subtitlesParser?.resetTime(to: time)
    self.chats.removeAll()
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: keyOfDefaultCellChat) as? CellChatDefault else {
      return UITableViewCell()
    }
    
    cell.chat = self.chats[indexPath.row]
    
    return cell
  }
}
