import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["editor", "imagePreview"];

  connect() {
    console.log("Editor controller connected!"); // Add this to debug
    this.setupImageUpload();
  }

  boldText(event) {
    event.preventDefault();
    this.surroundText(this.editorTarget, "**", "**", "bold text");
  }

  italicText(event) {
    event.preventDefault();
    this.surroundText(this.editorTarget, "_", "_", "italic text");
  }

  // Add methods for other buttons similarly:
  // headingText, quoteText, listText, linkText, etc.

  setupImageUpload() {
    const fileInput = document.getElementById("image-upload");
    const previewContainer = this.imagePreviewTarget;
    const editorTarget = this.editorTarget;

    if (!fileInput) {
      console.error("Image upload input not found");
      return;
    }

    fileInput.addEventListener("change", function () {
      previewContainer.innerHTML = "";

      for (const file of this.files) {
        if (file.type.match("image.*")) {
          const reader = new FileReader();

          reader.onload = function (e) {
            const imgContainer = document.createElement("div");
            imgContainer.className =
              "w-32 border border-gray-300 rounded-md p-2 text-center";

            const img = document.createElement("img");
            img.src = e.target.result;
            img.className = "max-w-full h-auto mb-2";

            const insertBtn = document.createElement("button");
            insertBtn.innerText = "Insert into article";
            insertBtn.className =
              "w-full py-1 text-xs bg-blue-600 text-white rounded-md hover:bg-blue-700";
            insertBtn.addEventListener("click", function () {
              const caretPos = editorTarget.selectionStart;
              const textBefore = editorTarget.value.substring(0, caretPos);
              const textAfter = editorTarget.value.substring(caretPos);
              editorTarget.value =
                textBefore + `\n![Image description](${img.src})\n` + textAfter;
              editorTarget.focus();
            });

            imgContainer.appendChild(img);
            imgContainer.appendChild(insertBtn);
            previewContainer.appendChild(imgContainer);
          };

          reader.readAsDataURL(file);
        }
      }
    });
  }

  surroundText(field, openTag, closeTag, placeholder) {
    const start = field.selectionStart;
    const end = field.selectionEnd;

    // Get the selected text
    const selectedText = field.value.substring(start, end);
    const replacement = selectedText || placeholder;

    // Insert the tags
    field.value =
      field.value.substring(0, start) +
      openTag +
      replacement +
      closeTag +
      field.value.substring(end);

    // Reset focus and selection
    field.focus();
    field.selectionStart = start + openTag.length;
    field.selectionEnd = start + openTag.length + replacement.length;
  }

  insertText(field, text) {
    const start = field.selectionStart;

    // Insert the text
    field.value =
      field.value.substring(0, start) +
      "\n" +
      text +
      "\n" +
      field.value.substring(start);

    // Reset focus
    field.focus();
    field.selectionStart = start + text.length + 2;
    field.selectionEnd = start + text.length + 2;
  }

  headingText(event) {
    event.preventDefault();
    this.surroundText(this.editorTarget, "## ", "", "Heading");
  }

  quoteText(event) {
    event.preventDefault();
    this.surroundText(this.editorTarget, "> ", "", "Quote goes here");
  }

  listText(event) {
    event.preventDefault();
    this.insertText(this.editorTarget, "- Item 1\n- Item 2\n- Item 3");
  }

  linkText(event) {
    event.preventDefault();
    this.surroundText(
      this.editorTarget,
      "[",
      "](https://example.com)",
      "link text"
    );
  }
}
