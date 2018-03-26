//
//  SubtitlesParser.swift
//  ChattingAVPlayer
//
//  Created by FlowerGeoji on 2018. 3. 26..
//  Copyright © 2018년 FlowerGeoji. All rights reserved.
//

import Foundation

public class SubtitlesParser {
  private(set) var savedString: String?
  private(set) var parsedPayload: [String: [[String: Any]]]?
  private var previousReadTimeInterval: TimeInterval = 0.0
  
  public init(subtitles string: String) {
    self.savedString = string
  }
  
  public init(file filePath: URL, encoding: String.Encoding = String.Encoding.utf8) {
    if let string = try? String(contentsOf: filePath, encoding: encoding) {
      self.savedString = string
    }
  }
  
  private func parseSubtitlesString(_ subtitles: String) -> [String: [[String: Any]]]? {
    do {
      
      // Prepare making payload
      var subtitles = subtitles.replacingOccurrences(of: "\n\r\n", with: "\n\n")
      subtitles = subtitles.replacingOccurrences(of: "\n\n\n", with: "\n\n")
      subtitles = subtitles.replacingOccurrences(of: "\r\n", with: "\n")
      
      // Result, Parsed dictionary
      var parsed: [String: [[String: Any]]] = [:]
      
      // Split each subtitles by regex
      //      (\\d+:\\d+:\\d+.\\d+)\\s*-->\\s*(\\d+:\\d+:\\d+.\\d+)\\s*(\\{.*?\\})c
      let regexStr = "(\\d+:\\d+:\\d+.\\d+)\\s*-->\\s*(\\d+:\\d+:\\d+.\\d+)\\s*(\\{.*?\\})"
      let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
      let matches = regex.matches(in: subtitles, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, subtitles.count))
      for match in matches {
        var chatDictionary: [String: Any] = [:]
        let lastRangeIndex = match.numberOfRanges - 1
        if lastRangeIndex == 3 {
          // 1 : start time
          var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0
          let stringStart = (subtitles as NSString).substring(with: match.range(at: 1))
          
          let scannerStart = Scanner(string: stringStart)
          scannerStart.scanDouble(&h)
          scannerStart.scanString(":", into: nil)
          scannerStart.scanDouble(&m)
          scannerStart.scanString(":", into: nil)
          scannerStart.scanDouble(&s)
          
          let start = (h * 3600.0) + (m * 60.0) + s
          chatDictionary["start"] = start
          
          // 2 : end time
          h = 0.0; m = 0.0; s = 0.0
          let stringEnd = (subtitles as NSString).substring(with: match.range(at: 2))
          
          let scannerEnd = Scanner(string: stringEnd)
          scannerEnd.scanDouble(&h)
          scannerEnd.scanString(":", into: nil)
          scannerEnd.scanDouble(&m)
          scannerEnd.scanString(":", into: nil)
          scannerEnd.scanDouble(&s)
          
          let end = (h * 3600.0) + (m * 60.0) + s
          chatDictionary["end"] = end
          
          // 3 : chat json
          chatDictionary["chat"] = (subtitles as NSString).substring(with: match.range(at: 3))
          
          // add to result
          let startSecond = Int(start).description
          if parsed[startSecond] == nil {
            parsed[startSecond] = []
          }
          parsed[startSecond]?.append(chatDictionary)
        }
      }
      
      return parsed
    }
    catch {
      return nil
    }
  }
}
