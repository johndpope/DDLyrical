//
//  DDWebServer.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/2.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import Foundation
import GCDWebServer.GCDWebUploader

class DDWebServer: NSObject {
    
    static let shared = DDWebServer()
    
    private var _webUploader: GCDWebUploader?
    
    private override init() {
        //
    }
    
    func initWebUploader() {
        if _webUploader == nil {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            _webUploader = GCDWebUploader(uploadDirectory: path)
        }
        _webUploader!.start()
        print("Visit \(_webUploader!.serverURL) in your web browser");
    }
    
    func stop() {
        _webUploader?.stop()
    }
}
