//
//  JobSJobStatsViewExampleOne.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI
import SampleData

enum Route {
case detailPage
}

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel(jobs: SampleData.generateRandomJobList(size: 10),
                                                            invoices: SampleData.generateRandomInvoiceList(size: 10))
    var body: some View {
        ZStack {
            Color.bg
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        UserCardView()
                            .frame(height: 100)
                        jobStatus
                        invoiceStatus
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .navigationTitle("Dashboard")
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .environmentObject(viewModel)
    }
    // MARK: Job Status
    var jobStatus: some View {
        NavigationLink(destination: StatusDetailsView(statusType: .job).environmentObject(viewModel)) {
            ReusableStatusCard(statusType: .job)
        }
    }
    // MARK: Invoice Status
    var invoiceStatus: some View {
        ReusableStatusCard(statusType: .invoice)
    }
}

#Preview {
    DashboardView()
}
