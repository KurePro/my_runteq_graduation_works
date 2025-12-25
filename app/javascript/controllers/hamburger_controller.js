import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "openButton" ]

  connect() {
    this.closeMenuHandler = (event) => {
      // リンクまたはフォーム送信時にメニューを閉じる
      if (event.target.closest("a") || event.target.closest("form")) {
        this.close()
      }
    }
    this.menuTarget.addEventListener("click", this.closeMenuHandler)

    // ESCキーでメニューを閉じる
    this.handleKeydown = (event) => {
      if (event.key === "Escape") {
        this.close()
      }
    }
    document.addEventListener("keydown", this.handleKeydown)

    // ウィンドウリサイズ時にメニューを閉じる (デスクトップ表示になった場合)
    this.handleResize = () => {
      if (window.innerWidth >= 768) {
        this.close()
      }
    }
    window.addEventListener("resize", this.handleResize)
  }

  disconnect() {
    this.menuTarget.removeEventListener("click", this.closeMenuHandler)
    document.removeEventListener("keydown", this.handleKeydown)
    window.removeEventListener("resize", this.handleResize)
    this.unlockScroll()
  }

  // ハンバーガーボタンを押した時に実行されるアクション
  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.openButtonTarget.classList.add("hidden")
    this.lockScroll()
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.openButtonTarget.classList.remove("hidden")
    this.unlockScroll()
  }

  lockScroll() {
    document.body.style.overflow = "hidden"
  }

  unlockScroll() {
    document.body.style.overflow = ""
  }
}
