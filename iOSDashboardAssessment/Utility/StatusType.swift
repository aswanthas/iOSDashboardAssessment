//
//  StatusType.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 30/08/24.
//

import Foundation

public enum StatusType {
     case job
     case invoice
    var statusTitle: String {
           switch self {
           case .job:
               return "Job Status"
           case .invoice:
               return "Invoice Status"
           }
       }
    var statusTypeDescription: String {
        switch self {
        case .job:
            return "Jobs"
        case .invoice:
            return "Total value"
        }
    }
 }
