// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import UIKit

struct TransactionCellViewModel {

    let transaction: Transaction
    let chainState: ChainState

    init(
        transaction: Transaction,
        chainState: ChainState
    ) {
        self.transaction = transaction
        self.chainState = chainState
    }
    var confirmations: Int {
        return chainState.latestBlock - Int(transaction.blockNumber)
    }

    private var state: TransactionState {
        if confirmations == 0 {
            return .pending
        }
        if transaction.isError {
            return .error
        }
        return .completed
    }

    var title: String {
        switch state {
        case .completed:
            switch transaction.direction {
            case .incoming: return "Received"
            case .outgoing: return "Sent"
            }
        case .error: return "Error"
        case .pending:
            switch transaction.direction {
            case .incoming: return "Receiving"
            case .outgoing: return "Sending"
            }
        }
    }

    var subTitle: String {
        switch transaction.direction {
        case .incoming: return "\(transaction.from)"
        case .outgoing: return "\(transaction.to)"
        }
    }

    var subTitleTextColor: UIColor {
        return Colors.gray
    }

    var subTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
    }

    var amount: String {
        let value = EthereumConverter.from(value: BInt(transaction.value), to: .ether, minimumFractionDigits: 3)
        switch transaction.direction {
        case .incoming: return "+\(value)"
        case .outgoing: return "-\(value)"
        }
    }

    var amountTextColor: UIColor {
        switch transaction.direction {
        case .incoming: return Colors.green
        case .outgoing: return Colors.red
        }
    }

    var amountFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
    }

    var backgroundColor: UIColor {
        switch state {
        case .completed:
            return .white
        case .error:
            return Colors.veryLightRed
        case .pending:
            return Colors.veryLightOrange
        }
    }

    var statusImage: UIImage? {
        switch state {
        case .error: return R.image.transaction_error()
        case .completed:
            switch transaction.direction {
            case .incoming: return R.image.transaction_received()
            case .outgoing: return R.image.transaction_sent()
            }
        case .pending:
            return R.image.transaction_pending()
        }
    }
}
