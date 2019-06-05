//
//  ChartsViewController.swift
//  Ios-Assignment3-131
//
//  Created by Ran Mo on 2019/6/2.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    var coinId: String?
    var coinName: String?

    lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @IBOutlet weak var coinNameLabel: UILabel! {
        didSet {
            coinNameLabel.text = coinName
        }
    }

    @IBOutlet weak var chartView: LineChartView! {
        didSet {
            chartView.delegate = self
            // 双击缩放
            chartView.doubleTapToZoomEnabled = false
            // 描述关闭
            chartView.chartDescription?.enabled = false
            // 拖移
            chartView.dragEnabled = true
            // 是否缩放
            chartView.setScaleEnabled(true)
            // 缩放系数
            chartView.setScaleMinima(2, scaleY: 0.8)
            // 捏合缩放
            chartView.pinchZoomEnabled = true
            // 拖抓后惯性效果
            chartView.dragDecelerationEnabled = true
            // 惯性系数
            chartView.dragDecelerationFrictionCoef = 0.8
            // 显示图例
            chartView.legend.enabled = false

            // x轴标签位置
            chartView.xAxis.labelPosition = .bottom
            // 网格
            chartView.xAxis.drawGridLinesEnabled = false
            // x 轴标点数
            chartView.xAxis.labelCount = 5
            // 设置x 轴标点数
            chartView.xAxis.forceLabelsEnabled = true
            // 线效果
            chartView.xAxis.gridLineDashLengths = [10, 10]
            chartView.xAxis.gridLineDashPhase = 0

            chartView.rightAxis.enabled = false
            chartView.leftAxis.gridLineDashLengths = [5, 5]
            chartView.leftAxis.labelPosition = .outsideChart
            // 网格颜色
            chartView.leftAxis.gridColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
            chartView.leftAxis.gridAntialiasEnabled = true
        }
    }

    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        loadData()
    }

    // 通过获取的最高价和最低价做个系数来做 y 轴 最大值和最小值
    private func setAxisMinAndMax(min: Double, max: Double) {
        let factor = (max - min) * 30
        chartView.leftAxis.axisMinimum = min - factor
        chartView.leftAxis.axisMaximum = max + factor
    }

    private func loadData() {
        guard let coinID = coinId else { return }

        let parameters: [String: String] =
            ["time_start": Helper.lastMonthDateStr(),
             "time_end": Helper.getString(from: Date()),
             "time_period": "daily",
             "id": coinID]

        activityIndicator.startAnimating()
        Networking.request(path: .ohlcvHistorical, parameters: parameters, success: { (data) in
            self.parseModel(from: data, success: { (model) in
                // 最后一个月每天的收盘价
                let values = model.data.quotes.map { $0.quote.USD.close }

                // 取第一天的最高价和最低价做系数计算设置 y 轴最大最小值
                if let firstQuote = model.data.quotes.first {
                    let usd = firstQuote.quote.USD
                    self.setAxisMinAndMax(min: usd.low, max: usd.high)
                }


                // 刷新 chart view
                DispatchQueue.main.async {

                    self.activityIndicator.stopAnimating()
                    if let lastestQuote = model.data.quotes.last {
                        let usd = lastestQuote.quote.USD
                        self.lowLabel.text = "Low: \(usd.low) $"
                        self.highLabel.text = "High: \(usd.high) $"
                    }

                    self.reloadChartData(yValues: values)
                }
            })
        }, failed: { error in
            self.activityIndicator.stopAnimating()
            printLog(error)
            printLog(error.localizedDescription)
        })
    }

    private func parseModel(from data: Data, success: ((CoinOHLCV) -> Void)?) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(Helper.customDateFormatter)
        do {
            let model = try jsonDecoder.decode(CoinOHLCV.self, from: data)
            success?(model)
            printLog(model)
        } catch {
            self.activityIndicator.stopAnimating()
            printLog(error)
        }
    }

    private func reloadChartData(yValues: [Double]) {
        let values = yValues.enumerated()
            .map { (offset, element) -> ChartDataEntry in
            return ChartDataEntry(x: Double(offset), y: element)
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

}

extension ChartsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
}
