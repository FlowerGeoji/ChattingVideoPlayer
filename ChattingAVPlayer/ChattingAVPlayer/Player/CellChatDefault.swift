//
//  CellChatDefaultTableViewCell.swift
//  ChattingAVPlayer
//
//  Created by FlowerGeoji on 2018. 3. 26..
//  Copyright © 2018년 FlowerGeoji. All rights reserved.
//

import UIKit

class CellChatDefault: UITableViewCell {
  private let viewWrapper: UIView = UIView()
  private let labelName: UILabel = UILabel()
  private let labelChat: UILabel = UILabel()
  
  var chat: String? {
    didSet {
      self.didSetChat()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.commonInit()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.commonInit()
  }
  
  private func commonInit() {
    self.contentView.addSubview(viewWrapper)
    viewWrapper.translatesAutoresizingMaskIntoConstraints = false
    viewWrapper.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
    viewWrapper.layer.cornerRadius = 5
    viewWrapper.clipsToBounds = true
    viewWrapper.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2).isActive = true
    viewWrapper.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
    viewWrapper.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
    viewWrapper.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2).isActive = true
    
    viewWrapper.addSubview(labelName)
    labelName.translatesAutoresizingMaskIntoConstraints = false
    labelName.textAlignment = .left
    labelName.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    labelName.textColor = UIColor(red: 157.0 / 255.0, green: 45.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    labelName.topAnchor.constraint(equalTo: viewWrapper.topAnchor, constant: 4).isActive = true
    labelName.leadingAnchor.constraint(equalTo: viewWrapper.leadingAnchor, constant: 8).isActive = true
    labelName.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
    labelName.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
    
    viewWrapper.addSubview(labelChat)
    labelChat.translatesAutoresizingMaskIntoConstraints = false
    labelChat.textAlignment = .left
    labelChat.numberOfLines = 0
    labelChat.textColor = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    labelChat.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    labelChat.topAnchor.constraint(equalTo: viewWrapper.topAnchor, constant: 4).isActive = true
    labelChat.leadingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: 5).isActive = true
    labelChat.trailingAnchor.constraint(equalTo: viewWrapper.trailingAnchor, constant: -8).isActive = true
    labelChat.bottomAnchor.constraint(equalTo: viewWrapper.bottomAnchor, constant: -4).isActive = true
    labelChat.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
    labelChat.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    self.contentView.backgroundColor = .clear
    self.layer.backgroundColor = UIColor.clear.cgColor
  }
  
  private func didSetChat() {
    guard let chat = self.chat else {
      return
    }
    
    guard let data = chat.data(using: .utf8) else {
      return
    }
    
    guard let chatJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any?] else {
      return
    }
    
    self.labelName.text = chatJson["user_name"] as? String
    self.labelChat.text = chatJson["message"] as? String
  }
}
