//
//  DDLyricStore.swift
//  DDLyrical
//
//  Created by Gu Jun on 2019/5/6.
//  Copyright © 2019 Gu Jun. All rights reserved.
//

import UIKit
import CoreData
import SpotlightLyrics

class DDLyricStore: NSObject {
    
    static let shared = DDLyricStore()
    
    private override init() {
        super.init()
//        testParser()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "coredata")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createMediaFiles(_ files: Array<String>) {
        let context = persistentContainer.viewContext
        for file in files {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "DDMedia", into: context) as! DDMedia
            entity.title = file
            entity.uuid = UUID()
            entity.filename = file
        }
        
        saveContext()
    }
    
    func getAllMediaFiles() -> Array<DDMedia> {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DDMedia>(entityName: "DDMedia")
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            return fetchResult
        } catch {
            fatalError("fetch error: getLyrics")
        }
    }
    
    func getMediaFile(by uuid: UUID) -> DDMedia? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DDMedia>(entityName: "DDMedia")
        fetchRequest.fetchOffset = 0
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 1 {
                fatalError("duplicate file uuid.")
            }
            return fetchResult.first
        } catch {
            fatalError("fetch error")
        }
    }
    
    func getLyrics() -> Array<DDLyric> {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DDLyric>(entityName: "DDLyric")
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            return fetchResult
        } catch {
            fatalError("fetch error: getLyrics")
        }
    }
    
    func getLyric(by uuid: UUID) -> DDLyric? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DDLyric>(entityName: "DDLyric")
        fetchRequest.fetchOffset = 0
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 1 {
                fatalError("duplicate lyric uuid.")
            }
            return fetchResult.first
        } catch {
            fatalError("fetch error")
        }
    }
    
    func saveLyric(withFilename filename: String, lines: Array<(time: Double, original: String, translation: String)>) -> Bool {
        let context = persistentContainer.viewContext
        let lyric = NSEntityDescription.insertNewObject(forEntityName: "DDLyric", into: context) as! DDLyric
        lyric.uuid = UUID()
        lyric.filename = filename
        
        var lineArray = Array<DDLine>()
        for item in lines {
            var segmentArray = Array<DDSegment>()
            var annotationArray = Array<DDAnnotation>()
            
            let line = NSEntityDescription.insertNewObject(forEntityName: "DDLine", into: context) as! DDLine
            line.time = item.time
            line.original = item.original
            line.translation = item.translation
            
            let (segments, annotations) = self.parse(line: item.original)
            for segment in segments {
                let segmentObj = NSEntityDescription.insertNewObject(forEntityName: "DDSegment", into: context) as! DDSegment
                segmentObj.segment = segment
                segmentArray.append(segmentObj)
            }
            for annotation in annotations {
                let annotationObj = NSEntityDescription.insertNewObject(forEntityName: "DDAnnotation", into: context) as! DDAnnotation
                annotationObj.begin = Int16(annotation.start)
                annotationObj.end = Int16(annotation.end)
                annotationObj.segmentIndex = Int16(annotation.segmentIndex)
                annotationObj.text = annotation.furigana
                annotationArray.append(annotationObj)
            }
            
            lineArray.append(line)
            line.segments = NSOrderedSet(array: segmentArray)
            line.annotations = NSSet(array: annotationArray)
        }
        lyric.lines = NSOrderedSet(array: lineArray)
        
        saveContext()
        
        return true
    }
    
    
    
    private func testParser() {
        do {
            let url = Bundle.main.url(forResource: "クリスマスソング", withExtension: "lrc")
            let lyricsString = try String.init(contentsOf: url!)
            let parser = LyricsParser(lyrics: lyricsString)
            
            // Now you get everything about the lyrics
            //            print(parser.header.title)
            //            print(parser.header.author)
            //            print(parser.header.album)
            
            var lines = Array<(time: Double, original: String, translation: String)>()
            
            
            for lyric in parser.lyrics {
                let pair = lyric.text.split(separator: " ")
                var original = ""
                var translation = ""
                if (pair.count == 2) {
                    original = String(pair[0])
                    translation = String(pair[1])
                } else if (pair.count == 3) {
                    original = String(pair[0]+pair[1])
                    translation = String(pair[2])
                } else if (pair.count == 4) {
                    original = String(pair[0]+pair[1])
                    translation = String(pair[2]+pair[3])
                } else {
                    print("Unexpected")
                    print(lyric.text)
                }
                lines.append((lyric.time, original, translation))
                //                print(lyric.text)
                //                print(lyric.time)
//                timings.append(lyric.time)
            }
            
            let _ = saveLyric(withFilename: "3098401105.mp3", lines: lines)
        } catch {
            print("ERROR: parse lrc")
        }
    }
    
    
    // MARK: Parse LRC
    private func test_parse() {
        let (segments, annotations) = parse(line: "どこかで鐘(かね)が鳴って")
        print(segments)
        print(annotations)
    }
    
    private func parse(line: String) -> (segments: [String], annotations: [DDLyricAnnotation]) {
        var segments = Array<String>()
        var annotations = Array<DDLyricAnnotation>()
        
        var segment = ""
        var goingOnType: CharacterType = .kana
        var startingKanjiIndex = 0
        var endingKanjiIndex = 0
        for (index, item) in line.unicodeScalars.enumerated() {
            var charType: CharacterType = .kana
            if (item.description == "(" || item.description == "（") {
                charType = .startingBracket
            } else if (item.description == ")" || item.description == "）") {
                charType = .endingBracket
            } else if (isKana(str: item.description)) {
                charType = .kana
            } else if (isKanji(str: item.description)) {
                charType = .kanji
            } else {
                print(item)
                charType = .other
            }
            
            if (index == 0) {
                segment = item.description
                goingOnType = charType
                
                if (line.unicodeScalars.count == 1) {
                    segments.append(segment)
                    return (segments, annotations)
                } else {
                    continue
                }
            }
            
            if (charType == goingOnType) {
                segment += item.description
            } else if (charType == .kana && goingOnType != .kana) {
                if (goingOnType == .kanji) {
                    segments.append(segment)
                }
                
                segment = item.description
            } else if (charType == .kanji && goingOnType != .kanji) {
                startingKanjiIndex = index
                segments.append(segment)
                
                segment = item.description
            } else if (charType == .startingBracket) {
                segments.append(segment)
                segment = ""
                endingKanjiIndex = index - 1
            } else if (charType == .endingBracket) {
                let annotation = DDLyricAnnotation()
                annotation.start = startingKanjiIndex
                annotation.end = endingKanjiIndex
                annotation.furigana = segment
                annotation.segmentIndex = segments.count - 1
                annotations.append(annotation)
                
                startingKanjiIndex = 0
                endingKanjiIndex = 0
                segment = ""
            } else if (charType == .other) {
                print(index, item)
            } else {
                print(index, item)
            }
            goingOnType = charType
            
            if (index == line.unicodeScalars.count - 1) {
                segments.append(segment)
            }
            //            print(item)
        }
        
        return (segments, annotations)
    }
    
    private func test_isKana() {
        print(isKana(str: "🐶"))
        print(isKana(str: "い"))
        print(isKana(str: "カ"))
        print(isKana(str: "中"))
        print(isKana(str: "鐘"))
    }
    
    private func test_isKanji() {
        print(isKanji(str: "🐶"))
        print(isKanji(str: "い"))
        print(isKanji(str: "カ"))
        print(isKanji(str: "中"))
        print(isKanji(str: "鐘"))
    }
    
    private func isKana(str: String) -> Bool {
        //        let pattern = "^[\\u3040-\\u309F]+|$"
        let pattern = "[ぁ-ん]+|[ァ-ヴー]+"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0)) else {
            return false
        }
        
        // range: 检验传入字符串str的哪些部分,此处为全部
        let result: Int = regex.numberOfMatches(in: str,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, str.count))
        return result > 0
        
    }
    
    private func isKanji(str: String) -> Bool {
        if str.unicodeScalars.count != 1 {
            assertionFailure()
        }
        let pattern = "[一-龠]+"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0)) else {
            return false
        }
        
        // range: 检验传入字符串str的哪些部分,此处为全部
        let result: Int = regex.numberOfMatches(in: str,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, str.count))
        return result > 0
    }
}
