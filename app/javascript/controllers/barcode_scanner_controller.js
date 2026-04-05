import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["camera", "result", "foodName", "startBtn", "stopBtn", "status"]

  connect() {
    this.scanning = false
    this.detected = false
    // on/offを確実に切り替えるため、bindした関数を変数に保存
    this.boundHandleDetected = this.#handleDetected.bind(this)
  }

  disconnect() {
    this.#stopScanner()
  }

  async start() {
    if (this.scanning) return

    if (typeof Quagga === "undefined") {
      this.#setStatus("error", "システムエラー: Quagga2が読み込まれていません")
      return
    }

    this.detected = false
    this.#setStatus("scanning", "カメラを起動中...")
    this.startBtnTarget.classList.add("hidden")
    this.stopBtnTarget.classList.remove("hidden")
    this.resultTarget.textContent = "スキャン待機中..."
    this.cameraTarget.style.display = "block" // カメラ枠を表示

    Quagga.init(
      {
        inputStream: {
          type: "LiveStream",
          target: this.cameraTarget,
          constraints: {
            width:  { min: 640 },
            height: { min: 480 },
            facingMode: "environment", // 背面カメラ
          },
        },
        locator: { patchSize: "medium", halfSample: true },
        numOfWorkers: navigator.hardwareConcurrency || 2,
        decoder: { readers: ["ean_reader"] }, // JANコード
        locate: true,
      },
      (err) => {
        if (err) {
          console.error(err)
          this.#setStatus("error", "カメラの起動に失敗しました")
          this.#resetButtons()
          return
        }
        Quagga.start()
        this.scanning = true
        this.#setStatus("scanning", "商品のバーコードをカメラに向けてください")
      }
    )

    // バグ修正: 保存しておいた固定の関数を渡す
    Quagga.onDetected(this.boundHandleDetected)
  }

  stop() {
    this.#stopScanner()
    this.#setStatus("idle", "スキャンを停止しました")
    this.#resetButtons()
  }

  #handleDetected(result) {
    if (this.detected) return

    const code = result.codeResult.code
    if (!code) return

    // 誤検出防止フィルター
    const errors = result.codeResult.decodedCodes
      .filter(x => x.error !== undefined)
      .map(x => x.error)
    const avgError = errors.reduce((a, b) => a + b, 0) / errors.length
    if (avgError > 0.15) return

    this.detected = true
    this.#stopScanner()
    this.resultTarget.textContent = code
    this.#setStatus("success", `JANコード: ${code} を読み取りました`)
    this.#resetButtons()

    this.#fetchProductInfo(code)
  }

  async #fetchProductInfo(janCode) {
    this.#setStatus("loading", "商品情報を検索中...")

    try {
      const res = await fetch(`/foods/search_by_barcode?jan_code=${encodeURIComponent(janCode)}`, {
        headers: { "Accept": "application/json" }
      })

      if (!res.ok) throw new Error(`HTTP error: ${res.status}`)

      const data = await res.json()

      if (data.name) {
        this.foodNameTarget.value = data.name
        this.#setStatus("success", `「${data.name}」を入力しました。内容を確認してください`)
      } else {
        this.#setStatus("warn", "商品情報が見つかりませんでした。手動で入力してください")
      }
    } catch (e) {
      console.error(e)
      this.#setStatus("error", "商品情報の取得に失敗しました。手動で入力してください")
    }
  }

  #stopScanner() {
    if (!this.scanning) return
    // 保持済みの参照を使って解除（offDetectedが正しく機能する）
    Quagga.offDetected(this.boundHandleDetected)
    Quagga.stop()
    this.scanning = false
    this.cameraTarget.style.display = "none"
  }

  #setStatus(type, message) {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = message
    
    // Tailwindがビルド時に認識できるよう完全な文字列でマッピング
    const colorClass = {
      error:   "text-red-500",
      success: "text-green-600",
      warn:    "text-yellow-600",
      loading: "text-blue-500",
      scanning:"text-blue-500",
      idle:    "text-gray-500",
    }[type] ?? "text-gray-500"
    
    this.statusTarget.className = `text-sm font-bold mt-2 ${colorClass}`
  }

  #resetButtons() {
    this.startBtnTarget.classList.remove("hidden")
    this.stopBtnTarget.classList.add("hidden")
  }
}
