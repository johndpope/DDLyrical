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
    
    func saveContext () {
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
    
    func getLyric(by uuid: UUID) -> DDLyric? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DDLyric>(entityName: "DDLyric")
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 1 {
                fatalError("duplicate pet uuid.")
            }
            return fetchResult.first
        } catch {
            fatalError("fetch error")
        }
    }
    
    func saveLyric(at uuid: UUID, lines: Array<(time: Double, original: String, translation: String)>) -> Bool {
        let context = persistentContainer.viewContext
        let lyric = NSEntityDescription.insertNewObject(forEntityName: "DDLyric", into: context) as! DDLyric
        lyric.uuid = uuid
        
        var lineArray = Array<DDLine>()
        for item in lines {
            let line = NSEntityDescription.insertNewObject(forEntityName: "DDLine", into: context) as! DDLine
            line.time = item.time
            line.original = item.original
            line.translation = item.translation
            
            lineArray.append(line)
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
            
            saveLyric(at: UUID(), lines: lines)
        } catch {
            print("ERROR: parse lrc")
        }
    }
}
