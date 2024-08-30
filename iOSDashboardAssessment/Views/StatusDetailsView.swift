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
            Picker("", selection: $selectedStatus) {
                ForEach(JobStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // List of Jobs based on status
            List(filteredJobs) { job in
                JobRowView(job: job)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                // Handle pull-to-refresh action
                viewModel.refreshJobs()
            }
            Spacer()
        }
        .toolbar {
                   ToolbarItem(placement: .principal) {
                       Text("Job Status")
                           .font(.headline)
                           .foregroundColor(.primary)
                   }
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
        VStack(alignment: .leading) {
            Text("#\(job.jobNumber)")
                .font(.headline)
            Text(job.title)
                .font(.subheadline)
            Text("\(job.startTime) - \(job.endTime)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
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

class JobStatsViewModel: ObservableObject {
    @Published var jobs: [JobApiModel]
    
    init(jobs: [JobApiModel]) {
        self.jobs = jobs
    }
    
    var jobStats: [JobStatus: Int] {
        Dictionary(grouping: jobs, by: { $0.status })
            .mapValues { $0.count }
    }
    
    var totalJobs: Int {
        jobs.count
    }
    
    func color(for status: JobStatus) -> Color {
        switch status {
        case .yetToStart:
            return .purple
        case .inProgress:
            return .blue
        case .canceled:
            return .yellow
        case .completed:
            return .green
        case .incomplete:
            return .red
        }
    }
    
    func refreshJobs() {
        // Simulate data refresh
        jobs = SampleData.generateRandomJobList(size: 10)
    }
}
