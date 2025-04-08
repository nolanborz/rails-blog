import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.outsideClickHandler = this.closeIfOutside.bind(this);
    document.addEventListener("click", this.outsideClickHandler);
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler);
  }

  toggle(event) {
    event.stopPropagation();
    this.menuTarget.classList.toggle("hidden");
  }

  closeIfOutside(event) {
    if (
      !this.element.contains(event.target) &&
      !this.menuTarget.classList.contains("hidden")
    ) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
