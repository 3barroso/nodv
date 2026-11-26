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

  connect() {
    this.#assignInternalTextareaIds();
    this.textareaObserver = new MutationObserver(() => this.#assignInternalTextareaIds());
    this.textareaObserver.observe(this.editorContentTarget, { childList: true, subtree: true });
  }

  disconnect() {
    this.textareaObserver?.disconnect();
  }

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

  #assignInternalTextareaIds() {
    const editorId = this.editorContentTarget.id || "resource-description";

    this.editorContentTarget.querySelectorAll("textarea:not([id])").forEach((textarea) => {
      let id;
      let index = 0;

      do {
        id = `${editorId}_internal_${++index}`;
      } while (document.getElementById(id));

      textarea.id = id;

      if (textarea.classList.contains("lexxy-caption-editor") && !textarea.hasAttribute("aria-label")) {
        textarea.setAttribute("aria-label", "Image caption");
      }
    });
  }
}
