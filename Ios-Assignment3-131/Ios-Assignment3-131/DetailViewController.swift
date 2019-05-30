//
//  DetailViewController.swift
//  Ios-Assignment3-131
//
//  Created by MorningStar on 2019/5/22.
//

import UIKit
import Charts

class DetailViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView! {
        didSet {
            chartView.delegate = self
            chartView.doubleTapToZoomEnabled = false
            chartView.chartDescription?.enabled = false
            chartView.dragEnabled = true
            chartView.setScaleEnabled(true)
            chartView.setScaleMinima(2, scaleY: 0.8)
            chartView.pinchZoomEnabled = true
            chartView.dragDecelerationEnabled = true
            chartView.dragDecelerationFrictionCoef = 0.8
            chartView.legend.enabled = false

            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.labelCount = 5
            chartView.xAxis.forceLabelsEnabled = true
            chartView.xAxis.gridLineDashLengths = [10, 10]
            chartView.xAxis.gridLineDashPhase = 0

            chartView.rightAxis.enabled = false
            chartView.leftAxis.gridLineDashLengths = [5, 5]
            chartView.leftAxis.labelPosition = .outsideChart
            chartView.leftAxis.axisMinimum = 0
            chartView.leftAxis.axisMaximum = 300
            chartView.leftAxis.gridColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
            chartView.leftAxis.gridAntialiasEnabled = true

        }
    }
    @IBOutlet weak var slectedCoinButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet var priceLabels: [UILabel]!
    var timer: DispatchSourceTimer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        reloadChartData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenSelectedView))
        maskView.addGestureRecognizer(tapGesture)

        slectedCoinButton.setTitle(DataProvider.getCoin().first, for: .normal)



        timer = DispatchSource.timer(interval: 3, queue: .main, handler: { [weak self] in
            self?.priceLabels.forEach {
                $0.text = String(format: "%.2f", Double.random(in: 100..<200))
            }
        })
        timer?.activate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard timer?.isCancelled == false else { return }
        timer?.cancel()
        timer = nil
    }

    private func reloadChartData() {
        let xValue = DataProvider.getLastThreeMonthDateStr()
        let values = (0..<xValue.count).map { index -> ChartDataEntry in
            let yVal = Double.random(in: 100..<200)
            return ChartDataEntry(x: Double(index), y: yVal)
        }
        let set1 = LineChartDataSet(entries: values, label: "Price")
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15

        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        chartView.data = data
    }


    @IBAction func selectCoin(_ sender: UIButton) {
        guard self.tableView.isHidden == true else { return }
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.tableViewHeightConstraint.constant = 150
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.maskView.isHidden = false
        })
    }

    @objc private func hiddenSelectedView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.tableView.isHidden = true
            self.maskView.isHidden = true
        })
    }

}

extension DetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProvider.getCoin().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = DataProvider.getCoin()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = coin
        cell.backgroundColor = .white
        return cell
    }
}
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = DataProvider.getCoin()[indexPath.row]
        slectedCoinButton.setTitle(coin, for: .normal)
        hiddenSelectedView()
        reloadChartData()
    }
}



extension DispatchSource {
    class func timer(interval: Double, queue: DispatchQueue, handler: @escaping () -> Void) -> DispatchSourceTimer {
        let source = DispatchSource.makeTimerSource(queue: queue)
        source.setEventHandler(handler: handler)
        source.schedule(deadline: .now(), repeating: interval, leeway: .nanoseconds(0))
        source.resume()
        return source
    }
}
