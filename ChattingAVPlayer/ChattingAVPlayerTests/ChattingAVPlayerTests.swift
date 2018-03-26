//
//  ChattingAVPlayerTests.swift
//  ChattingAVPlayerTests
//
//  Created by FlowerGeoji on 2018. 2. 13..
//  Copyright © 2018년 FlowerGeoji. All rights reserved.
//

import XCTest
@testable import ChattingAVPlayer

class ChattingAVPlayerTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testSubtitlesParser() {
    // Test Initialization of SubtitlesParser
    
    // == Initialize SubtitlesParser ===============================================================================================
    let filePathString = "https://asset.pufflive.me/subtitles/11313/1514970441/subtitles_ec58-2018-01-03/1514966117_M4w28A.vtt"
    guard let fileUrl: URL = URL.init(string: filePathString) else {
      return
    }
    let subtitlesString: String = """
WEBVTT

00:00:16.1114 --> 1440:00:00.0000
{"user_name":"tester1", "category":"0", "message":"tester1님이 입장하셨습니다."}

00:00:20.8035 --> 1440:00:00.0000
{"user_name":"tester2", "category":"2", "message":"tester2님이 입장하셨습니다."}

00:01:47.2557 --> 1440:00:00.0000
{"user_name":"tester2", "category":"0", "message":"하이~"}

00:01:56.2256 --> 1440:00:00.0000
{"user_name":"tester3", "category":"1", "message":"tester3님이 입장하셨습니다."}

00:02:00.2557 --> 1440:00:00.0000
{"user_name":"tester4", "category":"1", "message":tester5님이 입장하셨습니다.}

00:21:04.8966 --> 1440:00:00.0000
{"user_name":"tester3", "category":"1", "message":"헐"}

00:26:56.0710 --> 1440:00:00.0000
{"user_name":"tester1", "category":"0", "message":"뭐지 뭐하는거지"}

00:26:58.7346 --> 1440:00:00.0000
{"user_name":"tester5", "category":"1", "message":"tester5님이 입장하셨습니다."}

00:31:20.5360 --> 1440:00:00.0000
{"user_name":"tester1", "category":"1", "message":"췟췟췟 췟퀴라웃"}

00:31:20.7072 --> 1440:00:00.0000
{"user_name":"tester6", "category":"1", "message":"tester6님이 입장하셨습니다."}

00:51:28.4336 --> 1440:00:00.0000
{"user_name":"tester6", "category":"1", "message":"?"}

00:51:28.6535 --> 1440:00:00.0000
{"user_name":"tester6", "category":"1", "message":"오 이쁘다"}

01:11:58.8218 --> 1440:00:00.0000
{"user_name":"tester7", "category":"1", "message":"tester7님이 입장하셨습니다."}

01:12:02.8818 --> 1440:00:00.0000
{"user_name":"tester8", "category":"1", "message":"tester8님이 입장하셨습니다."}
"""
    
    let parser1: SubtitlesParser = SubtitlesParser(file: fileUrl)
    let parser2: SubtitlesParser = SubtitlesParser(file: fileUrl, encoding: .utf8)
    let parser3: SubtitlesParser = SubtitlesParser(subtitles: subtitlesString)
    
    XCTAssertNotNil(parser1.savedString, "SubtitlesParser should be can read VTT file")
    XCTAssertGreaterThan((parser1.savedString?.count)!, 0, "Count of string from the vtt-file should be greater than 0")
    XCTAssertGreaterThan((parser1.parsedPayload?.count)!, 0, "Count of subtitles shoud be greater than 0")
    
    XCTAssertNotNil(parser2.savedString, "SubtitlesParser should be can read VTT file")
    XCTAssertGreaterThan((parser2.savedString?.count)!, 0, "Count of string from the vtt-file should be greater than 0")
    XCTAssertGreaterThan((parser2.parsedPayload?.count)!, 0, "Count of subtitles shoud be greater than 0")
    
    XCTAssertNotNil(parser3.savedString, "SubtitlesParser should be can get String Input")
    XCTAssertGreaterThan((parser3.savedString?.count)!, 0, "Count of string should be greater than 0")
    XCTAssertEqual((parser3.parsedPayload?.count)!, 12, "Count of node should be equal to 12")
    
    // == Searching Subtitles ====================================================================================================
    XCTAssertEqual(parser3.searchSubtitles(at: 0.0).count, 0, "")
    XCTAssertEqual(parser3.searchSubtitles(at: 120.0).count, 4, "")
    XCTAssertEqual(parser3.searchSubtitles(at: 3600.0).count, 12, "")
    
    // == Reading Subtitles ======================================================================================================
    XCTAssertEqual(parser3.readNextSubtitles(to: 5.0).count, 0)         // Read subtitles from 0 seconds to 5 seconds
    XCTAssertEqual(parser3.readNextSubtitles(to: 10.0*60.0).count, 5)   // Read subtitles from 5 seconds to 10 minutes
    XCTAssertEqual(parser3.readNextSubtitles(to: 20.0*60.0).count, 0)   // Read subtitles from 10 minutes to 20 minutes
    XCTAssertEqual(parser3.readNextSubtitles(to: 30.0*60.0).count, 3)   // Read subtitles from 20 minutes to 30 minutes
    XCTAssertEqual(parser3.readNextSubtitles(to: 50.0*60.0).count, 2)   // Read subtitles from 30 minutes to 50 minutes
    XCTAssertEqual(parser3.readNextSubtitles(to: 60.0*60.0).count, 2)   // Read subtitles from 50 minutes to 60 minutes
    XCTAssertEqual(parser3.readNextSubtitles(to: 80.0*60.0).count, 2)   // Read subtitles from 60 minutes to 80 minutes
  }

  func testPerformanceExample() {
    self.measure {
      // Put the code you want to measure the time of here.
      
      // Measure preformance of SubtitlesParser Initialization
      let filePathString = "https://asset.pufflive.me/subtitles/11313/1514970441/subtitles_ec58-2018-01-03/1514966117_M4w28A.vtt"
      guard let fileUrl: URL = URL.init(string: filePathString) else {
        return
      }
      let _: SubtitlesParser = SubtitlesParser(file: fileUrl, encoding: .utf8)
    }
  }

}
