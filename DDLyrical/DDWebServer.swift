//
//  DDWebServer.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/2.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import Foundation
import GCDWebServer

class DDWebServer: NSObject {
    
    static let shared = DDWebServer()
    
    private override init() {
        //
    }
    
    func initWebServer() {
        
        let webServer = GCDWebServer()
        
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
            return GCDWebServerDataResponse(html:"<html><body><p>Hello World</p></body></html>")
            
        })
        
        webServer.start(withPort: 8080, bonjourName: "GCD Web Server")
        
        print("Visit \(webServer.serverURL) in your web browser")
    }
}
