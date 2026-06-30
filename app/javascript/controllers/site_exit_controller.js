import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.escapePressCount = 0
    this.escapeTimer = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundHandleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleKeydown)

    if (this.escapeTimer) {
      window.clearTimeout(this.escapeTimer)
    }
  }

  handleKeydown(event) {
    if (event.key !== "Escape") {
      this.escapePressCount = 0
      return
    }

    this.escapePressCount += 1

    if (this.escapeTimer) {
      window.clearTimeout(this.escapeTimer)
    }

    this.escapeTimer = window.setTimeout(() => {
      this.escapePressCount = 0
    }, 600)

    if (this.escapePressCount >= 2) {
      this.exitSite()
    }
  }

  exitSite() {
    this.clearSessionData()
    this.tryCloseWindow()
  }

  clearSessionData() {
    try {
      sessionStorage.clear()
      localStorage.clear()
    } catch (error) {
      console.warn("Unable to clear browser storage.", error)
    }
  }

  tryCloseWindow() {
    try {
      if (window.opener) {
        window.close()
      } else {
        window.location.replace("about:blank")
      }
    } catch (error) {
      window.location.replace("about:blank")
    }
  }
}
