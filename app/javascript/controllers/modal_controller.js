import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.element.focus()
  }
  hide(event) {
    event.preventDefault();

    this.element.remove();
  }

  disconnect() {
    this.#modalTurboFrame.src = null;
  }

  // private: 親のturbo-frameを探す便利メソッド?
  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}
