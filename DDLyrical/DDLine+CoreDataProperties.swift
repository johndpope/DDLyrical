//
//  DDLine+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/5/19.
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
    @NSManaged public var segments: DDSegment?
    @NSManaged public var lyric: DDLyric?

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
