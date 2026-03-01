import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.showModal();
  }

  close(event) {
    if (event) event.preventDefault();
    
    this.element.close(); 
  }

  clickOutside(event) {
    if (event.target === this.element) {
      this.close();
    }
  }

  clear() {
    this.#modalTurboFrame.src = null;
    this.#modalTurboFrame.innerHTML = "";
  }

  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}