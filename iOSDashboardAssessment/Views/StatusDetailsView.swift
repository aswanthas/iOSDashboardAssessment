//
//  StatusDetailsView.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI
import SampleData

struct StatusDetailsView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var selectedStatus: JobStatus = .yetToStart
    let statusType: StatusType

    var body: some View {
        VStack {
            // Job count and progress
            VStack(alignment: .leading) {
                HStack {
                    Group {
                        switch statusType {
                        case .job:
                            Text("\(viewModel.totalJobs) \(statusType.statusTypeDescription)")
                            Spacer()
                            Text("\(viewModel.completedJobs) of \(viewModel.totalJobs)  completed")
                        case .invoice:
                            Text("\(statusType.statusTypeDescription) (\(viewModel.totalInvoiceValue() ?? "$0.00"))")
                            Spacer()
                            Text("\(viewModel.totalInvoiceCollected() ?? "$0.00") collected")
                        }
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)

                }
                statsBar
                    .frame(height: 15)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 5))
            }
            .padding()
            
            // Job Status Tab Bar
            HorizontalPickerView(
                selected: Binding(
                    get: { JobStatus.allCases.firstIndex(of: selectedStatus) ?? 0 },
                    set: { selectedStatus = JobStatus.allCases[$0] }
                ),
                option: JobStatus.allCases.map { "\($0.rawValue) (\(viewModel.jobCount(for: $0)))" }
            ) { index in
                selectedStatus = JobStatus.allCases[index]
            }
            .frame(height: 30)
            
            // List of Jobs based on status
            List(filteredJobs) { job in
                JobRowView(job: job)
                    .frame(height: 90)
                    .listRowSeparator(.hidden)
                
            }
            .listStyle(PlainListStyle())
            .refreshable {
                // Handle pull-to-refresh action
                viewModel.refreshJobs()
            }
            Spacer()
        }
        .navigationTitle("Jobs (\(viewModel.jobs.count))")
        .navigationBarTitleDisplayMode(.inline)
    }
    // MARK: StatsBar
    private var statsBar: some View {
        GeometryReader(content: { geometry in
            HStack(spacing: 0) {
                switch statusType {
                case .job:
                    ForEach(viewModel.jobStats.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { status in
                        Rectangle()
                            .fill(viewModel.color(for: status))
                            .frame(width: barWidth(width: geometry.size.width,for: viewModel.jobStats[status] ?? 0))
                    }
                case .invoice:
                    ForEach(viewModel.invoiceStats.sorted { $0.value.count > $1.value.count }.map { $0.key }, id: \.self) { status in
                        Rectangle()
                            .fill(viewModel.color(for: status))
                            .frame(width: barWidth(width: geometry.size.width, for: viewModel.invoiceStats[status]?.count ?? 0))
                    }
                }
            }
        })
    }
    // Filter jobs based on selected status
    var filteredJobs: [JobApiModel] {
        viewModel.jobs.filter { $0.status == selectedStatus }
    }
    
    private func barWidth(width: CGFloat,for count: Int) -> CGFloat {
        let screenWidth = width
        return CGFloat(count) / CGFloat(viewModel.totalJobs) * screenWidth
    }
}

struct JobRowView: View {
    let job: JobApiModel

    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text("#\(job.jobNumber)")
                    .font(.headline)
                Text(job.title)
                    .font(.subheadline)
                if let startTimeFormatted = job.startTime.timeFormat,
                   let endTimeFormatted = job.endTime.timeFormat {
                    Text("\(startTimeFormatted) - \(endTimeFormatted)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 10)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )

        })
    }
}


struct JobListView: View {
    let jobs: [JobApiModel]
    
    var body: some View {
        List(jobs) { job in
            VStack(alignment: .leading) {
                Text("\(job.title)")
                    .font(.headline)
                Text("\(job.status.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
