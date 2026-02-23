import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = [ "openSearchForm" ]

   toggle() {
    this.openSearchFormTarget.classList.toggle("hidden")
  }
}
