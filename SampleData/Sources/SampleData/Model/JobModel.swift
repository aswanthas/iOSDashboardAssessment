//
//  File.swift
//  
//
//  Created by SabariZuper on 15/05/24.
//

import Foundation

public struct JobApiModel {
    public let id = UUID()
    public let jobNumber: Int
    public let title: String
    public let startTime: String
    public let endTime: String
    public let status: JobStatus
}

public enum JobStatus: String, CaseIterable {
    case yetToStart = "Yet to Start"
    case inProgress = "In Progress"
    case canceled = "Canceled"
    case completed = "Completed"
    case incomplete = "Incomplete"
}
