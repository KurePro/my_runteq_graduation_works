import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hamburger"
export default class extends Controller {
  static targets = [ "menu" ]

  // ハンバーガーボタンを押した時に実行されるアクション
  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }
}
