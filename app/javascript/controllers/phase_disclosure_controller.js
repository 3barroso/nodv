import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "content", "icon"];
  static values = { name: String };

  toggle() {
    const expanded = this.buttonTarget.getAttribute("aria-expanded") === "true";
    const nextExpanded = !expanded;

    this.buttonTarget.setAttribute("aria-expanded", String(nextExpanded));
    this.buttonTarget.setAttribute(
      "aria-label",
      `${nextExpanded ? "Collapse" : "Expand"} ${this.nameValue} section`
    );
    this.contentTarget.hidden = !nextExpanded;
    this.iconTarget.classList.toggle("rotate-180", nextExpanded);
  }
}