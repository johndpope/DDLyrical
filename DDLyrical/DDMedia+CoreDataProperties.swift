//
//  DDMedia+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/6/5.
//
//

import Foundation
import CoreData


extension DDMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDMedia> {
        return NSFetchRequest<DDMedia>(entityName: "DDMedia")
    }

    @NSManaged public var artist: String?
    @NSManaged public var title: String?
    @NSManaged public var lyricist: String?
    @NSManaged public var composer: String?
    @NSManaged public var filename: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var lyric: DDLyric?

}
