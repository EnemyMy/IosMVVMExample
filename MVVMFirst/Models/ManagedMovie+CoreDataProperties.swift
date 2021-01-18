//
//  ManagedMovie+CoreDataProperties.swift
//  
//
//  Created by Алексей on 01.01.2021.
//
//

import Foundation
import CoreData


extension ManagedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMovie> {
        return NSFetchRequest<ManagedMovie>(entityName: "ManagedMovie")
    }

    @NSManaged public var title: String
    @NSManaged public var overview: String
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String
    @NSManaged public var releaseDate: String
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int16

}
