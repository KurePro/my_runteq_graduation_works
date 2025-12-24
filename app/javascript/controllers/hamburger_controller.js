import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "openButton" ]

  // ハンバーガーボタンを押した時に実行されるアクション
  toggle() {
    this.menuTarget.classList.toggle("hidden")
    this.openButtonTarget.classList.toggle("hidden")
  }
}
