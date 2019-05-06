//
//  DDLine+CoreDataProperties.swift
//  
//
//  Created by Gu Jun on 2019/5/6.
//
//

import Foundation
import CoreData


extension DDLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDLine> {
        return NSFetchRequest<DDLine>(entityName: "DDLine")
    }

    @NSManaged public var original: String?
    @NSManaged public var translation: String?
    @NSManaged public var time: Double
    @NSManaged public var annotations: NSSet?

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
