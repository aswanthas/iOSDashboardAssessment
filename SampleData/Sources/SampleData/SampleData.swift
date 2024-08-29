// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class SampleData: NSObject {

    private static let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    private static let jobTitles = ["Inerior design", "Home Cleaning", "Renovation", "lawn moaning", "Superb"]
    private static let jobNouns = ["Job", "Task", "Project", "Assignment", "Work"]
    
    private static let firstNames = ["John", "Jane", "Alice", "Bob", "Eva"]
    private static let lastNames = ["Doe", "Smith", "Johnson", "Brown", "Lee"]

    public static func generateRandomJobList(size: Int) -> [JobApiModel] {
        return (1...size).compactMap { index in
            guard let randomStartTime = generateRandomDate(daysFromNow: 1...30),
                  let randomEndTime = generateRandomDate(daysFromNow: 31...60) else {
                return nil
            }
            return JobApiModel(
                jobNumber: index,
                title: generateRandomJobTitle(),
                startTime: isoFormatter.string(from: randomStartTime),
                endTime: isoFormatter.string(from: randomEndTime),
                status: JobStatus.allCases.randomElement()!
            )
        }
    }

    public static func generateRandomInvoiceList(size: Int) -> [InvoiceApiModel] {
        return (1...size).map { _ in
            InvoiceApiModel(
                invoiceNumber: Int.random(in: 1..<Int.max),
                customerName: generateRandomCustomerName(),
                total: Int.random(in: 1...10) * 1000,
                status: InvoiceStatus.allCases.randomElement()!
            )
        }
    }

    private static func generateRandomJobTitle() -> String {
        return "\(jobTitles.randomElement()!) \(jobNouns.randomElement()!)"
    }

    private static func generateRandomCustomerName() -> String {
        return "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
    }

    private static func generateRandomDate(daysFromNow range: ClosedRange<Int>) -> Date? {
        return Calendar.current.date(byAdding: .day, value: Int.random(in: range), to: Date())
    }
}
