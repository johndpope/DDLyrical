//
//  DDLyric+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/5/27.
//
//

import Foundation
import CoreData


extension DDLyric {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDLyric> {
        return NSFetchRequest<DDLyric>(entityName: "DDLyric")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var lines: NSOrderedSet?

}

// MARK: Generated accessors for lines
extension DDLyric {

    @objc(insertObject:inLinesAtIndex:)
    @NSManaged public func insertIntoLines(_ value: DDLine, at idx: Int)

    @objc(removeObjectFromLinesAtIndex:)
    @NSManaged public func removeFromLines(at idx: Int)

    @objc(insertLines:atIndexes:)
    @NSManaged public func insertIntoLines(_ values: [DDLine], at indexes: NSIndexSet)

    @objc(removeLinesAtIndexes:)
    @NSManaged public func removeFromLines(at indexes: NSIndexSet)

    @objc(replaceObjectInLinesAtIndex:withObject:)
    @NSManaged public func replaceLines(at idx: Int, with value: DDLine)

    @objc(replaceLinesAtIndexes:withLines:)
    @NSManaged public func replaceLines(at indexes: NSIndexSet, with values: [DDLine])

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: DDLine)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: DDLine)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSOrderedSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSOrderedSet)

}
