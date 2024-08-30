//
//  ReuableStatusCard.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI

struct ReusableStatusCard: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    let statusType: StatusType
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            HStack {
                Text(statusType.statusTitle)
                    .font(.subheadline.bold())
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(8)
            
            Divider()
                .background(.gray)
            
            VStack {
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
                statusbarInfo
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )

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
    // MARK: StatsBar-info
    private var statusbarInfo: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            switch statusType {
            case .job:
                ForEach(viewModel.jobStats.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { status in
                    HStack {
                        Rectangle()
                            .fill(viewModel.color(for: status))
                            .frame(width: 10, height: 10)
                            .cornerRadius(2)
                        Text("\(status.rawValue) (\(viewModel.jobStats[status] ?? 0))")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                    }
                }
            case .invoice:
                ForEach(viewModel.invoiceStats.sorted { $0.value.count > $1.value.count }, id: \.key) { status, stats in
                    HStack {
                        Rectangle()
                            .fill(viewModel.color(for: status))
                            .frame(width: 10, height: 10)
                            .cornerRadius(2)
                        Text("\(status.rawValue)(\(viewModel.priceConvertion(value: stats.total) ?? "$0"))")
                            .font(.footnote)
                    }
                }
            }
        }
    }
                       
    private func barWidth(width: CGFloat,for count: Int) -> CGFloat {
        let screenWidth = width
        return CGFloat(count) / CGFloat(viewModel.totalJobs) * screenWidth
    }
}

//#Preview {
//    ReuableStatusCard(vm: DashboardViewModel())
//}
