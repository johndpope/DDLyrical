//
//  DDUploadViewController.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/11.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GCDWebServer.GCDWebUploader

class DDUploadViewController: UIViewController, GCDWebUploaderDelegate {
    
    private let textLabel = UILabel()
    private let startOrStopButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        buildUI()
    }
    
    @objc func dismissVC() {
        DDWebServer.shared.stop()
        self.dismiss(animated: true) {
            //
        }
    }
    
    @objc func startOrStopServer() {
        if DDWebServer.shared.isRunning() {
            DDWebServer.shared.stop()
            textLabel.text = String("server stopped")
            startOrStopButton.setTitle("Start Server", for: .normal)
        } else {
            let serverUrl = DDWebServer.shared.initWebUploader()
            textLabel.text = String(describing: "Visit " + serverUrl)
            startOrStopButton.setTitle("Stop Server", for: .normal)
        }
    }
    
    private func buildUI() {
        let dismissButton = UIButton()
        dismissButton.setTitle("DISMISS", for: .normal)
        dismissButton.setTitleColor(.gray, for: .normal)
        self.view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        textLabel.text = "upload file via Wi-Fi"
        textLabel.textAlignment = .center
        self.view.addSubview(textLabel)
        
        startOrStopButton.backgroundColor = .gray
        startOrStopButton.setTitle("Start Server", for: .normal)
        self.view.addSubview(startOrStopButton)
        
        startOrStopButton.addTarget(self, action: #selector(startOrStopServer), for: .touchUpInside)
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp_bottom)
            make.right.equalToSuperview()
            make.bottom.equalTo(startOrStopButton.snp_top)
            make.left.equalToSuperview()
        }
        
        startOrStopButton.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp_bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    // MARK: GCDWebUploaderDelegate
    
    func webUploader(_ uploader: GCDWebUploader, didDownloadFileAtPath path: String) {
        print("didDownloadFileAtPath: \(path)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print("didUploadFileAtPath: \(path)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("didMoveItemFromPath: \(fromPath) toPath: \(toPath)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("didDeleteItemAtPath: \(path)")
    }
    
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("didCreateDirectoryAtPath: \(path)")
    }
    
}
