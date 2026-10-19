// app/javascript/controllers/preview_controller.js
import { Controller } from "@hotwired/stimulus";
import { post } from "@rails/request.js";

export default class extends Controller {
  static targets = [
    "editor",
    "editorContent",
    "preview",
    "editorButton",
    "previewButton",
  ];
  static values = { url: String };

  editor(event) {
    event.preventDefault();
    this.#toggleButton(this.editorButtonTarget, this.previewButtonTarget);
    this.#togglePane(this.editorTarget, this.previewTarget);
  }

  preview(event) {
    event.preventDefault();
    post(this.urlValue, {
      body: { body: this.editorContentTarget.value },
      responseKind: "turbo-stream",
    });
    this.#toggleButton(this.previewButtonTarget, this.editorButtonTarget);
    this.#togglePane(this.previewTarget, this.editorTarget);
  }

  #toggleButton(activate, deactivate) {
    // Toggle button styles
    activate.classList.remove("bg-gray-100", "hover:bg-gray-50");
    // ...
  }

  #togglePane(show, hide) {
    // Hide one pane and show the other
    show.classList.remove("hidden");
    hide.classList.add("hidden");
  }
}
