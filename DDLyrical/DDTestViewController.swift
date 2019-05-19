//
//  File.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/18.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit

enum CharacterType {
    case kana
    case kanji
    case startingBracket
    case endingBracket
    case other
}

class DDTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let text = "どこかで鐘(かね)が鳴って"
        
//        let (segments, annotations) = parse(line: text)
        
//        test_isKana()
//        test_isKanji()
//        test_parse()
    }
    
    
    private func testUTF8() {
        //        let strToDecode = "🐶"
        //        let strToDecode = "い"
        let strToDecode = "中"
        let str = strToDecode.utf8DecodedString()
        print(str)
        //        for codeUnit in strToDecode.utf8 {
        //            print(codeUnit)
        //            print(String().appendingFormat("%x", codeUnit))
        //        }
        
        for scalar in strToDecode.unicodeScalars {
            print(scalar.value)
            print(String().appendingFormat("%x", scalar.value))
        }
        
        //        print("\u{3044}")
    }
}



extension String {
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .unicode)
        if let message = String(data: data!, encoding: .unicode){
            return message
        }
        return ""
    }
}
