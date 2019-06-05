//
//  DDLine+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/6/5.
//
//

import Foundation
import CoreData


extension DDLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDLine> {
        return NSFetchRequest<DDLine>(entityName: "DDLine")
    }

    @NSManaged public var original: String?
    @NSManaged public var time: Double
    @NSManaged public var translation: String?
    @NSManaged public var annotations: NSSet?
    @NSManaged public var lyric: DDLyric?
    @NSManaged public var segments: NSOrderedSet?

}

// MARK: Generated accessors for annotations
extension DDLine {

    @objc(addAnnotationsObject:)
    @NSManaged public func addToAnnotations(_ value: DDAnnotation)

    @objc(removeAnnotationsObject:)
    @NSManaged public func removeFromAnnotations(_ value: DDAnnotation)

    @objc(addAnnotations:)
    @NSManaged public func addToAnnotations(_ values: NSSet)

    @objc(removeAnnotations:)
    @NSManaged public func removeFromAnnotations(_ values: NSSet)

}

// MARK: Generated accessors for segments
extension DDLine {

    @objc(insertObject:inSegmentsAtIndex:)
    @NSManaged public func insertIntoSegments(_ value: DDSegment, at idx: Int)

    @objc(removeObjectFromSegmentsAtIndex:)
    @NSManaged public func removeFromSegments(at idx: Int)

    @objc(insertSegments:atIndexes:)
    @NSManaged public func insertIntoSegments(_ values: [DDSegment], at indexes: NSIndexSet)

    @objc(removeSegmentsAtIndexes:)
    @NSManaged public func removeFromSegments(at indexes: NSIndexSet)

    @objc(replaceObjectInSegmentsAtIndex:withObject:)
    @NSManaged public func replaceSegments(at idx: Int, with value: DDSegment)

    @objc(replaceSegmentsAtIndexes:withSegments:)
    @NSManaged public func replaceSegments(at indexes: NSIndexSet, with values: [DDSegment])

    @objc(addSegmentsObject:)
    @NSManaged public func addToSegments(_ value: DDSegment)

    @objc(removeSegmentsObject:)
    @NSManaged public func removeFromSegments(_ value: DDSegment)

    @objc(addSegments:)
    @NSManaged public func addToSegments(_ values: NSOrderedSet)

    @objc(removeSegments:)
    @NSManaged public func removeFromSegments(_ values: NSOrderedSet)

}
