//
//  StatusDetailsView.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI

struct StatusDetailsView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Jobs sorted by Job Number:")
                .font(.headline)
                .padding(.top, 8)
            ForEach(viewModel.sortedJobs, id: \.id) { job in
                Text("\(job.jobNumber) - \(job.title) (\(job.status.rawValue))")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    StatusDetailsView()
}
