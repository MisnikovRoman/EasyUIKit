//
//  TableView.swift
//  Created by MisnikovRoman on 01.03.2020.
//

import UIKit
import TinyConstraints

// swiftlint:disable:next line_length
final public class TableView<Cell: UITableViewCell, ViewModel>: UITableView, UITableViewDataSource, UITableViewDelegate {

    public typealias CellConfigurationAction = (Cell, ViewModel) -> Void
    public typealias CellSelectHandler = (ViewModel) -> Void

    private let cellType: Cell.Type
    private let viewModels: [ViewModel]
    private let configureCell: CellConfigurationAction
    private let selectHandler: CellSelectHandler?

    private var reuseId: String {
        String(describing: cellType)
    }

    public init(cellType: Cell.Type,
                viewModels: [ViewModel],
                configurationAction: @escaping CellConfigurationAction,
                selectAction: CellSelectHandler? = nil) {

        self.cellType = cellType
        self.viewModels = viewModels
        self.configureCell = configurationAction
        self.selectHandler = selectAction

        super.init(frame: .zero, style: .plain)

        self.setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId, for: indexPath) as? Cell
            else { return UITableViewCell() }

        self.configureCell(cell, self.viewModels[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = self.viewModels[indexPath.row]
        self.selectHandler?(viewModel)
    }
}

private extension TableView {
    func setup() {
        self.register(self.cellType, forCellReuseIdentifier: self.reuseId)
        self.dataSource = self
        self.delegate = self
    }
}
