//
//  JobSJobStatsViewExampleOne.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI
import SampleData

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel(jobs: SampleData.generateRandomJobList(size: 10), invoices: SampleData.generateRandomInvoiceList(size: 10))
    var body: some View {
        JobSJobStatsViewExampleTwo()
            .environmentObject(viewModel)
    }
}

#Preview {
    DashboardView()
}

struct JobSJobStatsViewExampleTwo: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        UserCardView()
                            .frame(height: 100)
//                        NavigationLink {
//                            StatusDetailsView()
//                        } label: {
                            jobStatus
//                        }
                        invoiceStatus
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .navigationTitle("Dashboard")
                }
            }
        }
        .ignoresSafeArea(.all)
    }
    // MARK: Job Status
    var jobStatus: some View {
        ReusableStatusCard(statusType: .job)

    }
    // MARK: Job Status
    var invoiceStatus: some View {
        ReusableStatusCard(statusType: .invoice)
    }
}
