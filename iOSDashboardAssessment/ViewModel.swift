//
//  DashboardViewModel.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI
import SampleData

class DashboardViewModel: ObservableObject {
    @Published var jobs: [JobApiModel]
    @Published var invoices: [InvoiceApiModel]
    
    init(jobs: [JobApiModel], invoices: [InvoiceApiModel]) {
        self.jobs = jobs
        self.invoices = invoices
    }
    // MARK: job Stats logic
    var jobStats: [JobStatus: Int] {
        Dictionary(grouping: jobs, by: { $0.status })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .reduce(into: [JobStatus: Int]()) { dict, pair in
                dict[pair.key] = pair.value
            }
    }
    
    var invoiceStats: [InvoiceStatus: (count: Int, total: Int)] {
        Dictionary(grouping: invoices, by: { $0.status })
            .mapValues { invoices in
                let count = invoices.count
                let total = invoices.reduce(0) { $0 + $1.total }
                return (count, total)
            }
            .sorted { $0.value.total > $1.value.total }
            .reduce(into: [InvoiceStatus: (count: Int, total: Int)]()) { dict, pair in
                dict[pair.key] = pair.value
            }
    }
    
    var sortedJobs: [JobApiModel] {
        jobs.sorted { $0.jobNumber > $1.jobNumber }
    }
    
    var totalJobs: Int {
        jobs.count
    }
    
    var completedJobs: Int {
        jobs.filter { $0.status == .completed }.count
    }
    
    func jobs(for status: JobStatus) -> [JobApiModel] {
            jobs.filter { $0.status == status }
        }
        
        func jobCount(for status: JobStatus) -> Int {
            jobs(for: status).count
        }
    
    func color(for status: JobStatus) -> Color {
        switch status {
        case .yetToStart:
            return .purple.opacity(0.6)
        case .inProgress:
            return .blue.opacity(0.6)
        case .canceled:
            return .yellow.opacity(0.6)
        case .completed:
            return .green.opacity(0.6)
        case .incomplete:
            return .red.opacity(0.6)
        }
    }
    
    func color(for status: InvoiceStatus) -> Color {
        switch status {
        case .draft:
            return .yellow.opacity(0.6)
        case .pending:
            return .purple.opacity(0.6)
        case .paid:
            return .green.opacity(0.6)
        case .badDebt:
            return .red.opacity(0.6)
        }
    }

    
    // MARK: invoice status logic
    var sortedInvoices: [InvoiceApiModel] {
        invoices.sorted { $0.invoiceNumber < $1.invoiceNumber }
    }
    
    var totalInvoices: Int {
        invoices.count
    }
    
    func totalInvoiceCollected() -> String? {
        let totalPaid = invoices.filter({ $0.status == .paid })
            .reduce(0) { $0 + $1.total }
        return priceConvertion(value: totalPaid)
        
    }
    
    func totalInvoiceValue() -> String? {
        let totalTransaction = invoices.reduce(0) { $0 + $1.total }
        return priceConvertion(value: totalTransaction)
    }
    
    func priceConvertion(value: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        let formattedTotalPaid = formatter.string(from: NSNumber(value: value))
        return formattedTotalPaid
    }
    
    func refreshJobs() {
            // Simulate data refresh
            jobs = SampleData.generateRandomJobList(size: 10)
        }
}
