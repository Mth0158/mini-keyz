import { Controller } from "stimulus";

export default class extends Controller {
  static get targets() {
    return ["formWrapper", "errorMessage"];
  }

  connect() {
    this.styleErrors();
  }

  styleErrors() {
    // Get form color
    const formColor = this.formWrapperTarget.dataset.formColor;

    // Change input style if error
    const formFields = Array.from(this.formWrapperTarget.children);
    formFields.forEach((formField) => {
      const inputWrapper = Array.from(formField.children);
      console.log(inputWrapper);

      const hasError = inputWrapper.find((element) => {
        console.log(element.classList.contains("error_explanation"));
        return element.classList.contains("error_explanation");
      });
      console.log(hasError);

      const inputFields = inputWrapper.filter((element) => {
        // Has to loop again because of form_for generating <div class="form_with_errors">...</div> around our label and input fields
        console.log(element);
        const children = Array.from(element.children);
        console.log(children);
        const inputChildrenFields = children.filter((child) => {
          return child.tagName === "INPUT";
        });
        console.log(inputChildrenFields);
        return inputChildrenFields.length;
      });
      console.log(inputFields);

      if (inputFields.length === 0) return;
      console.log(inputFields[0].children);
      const isInputTypingField = inputFields[0].children.length === 1;
      console.log(isInputTypingField);

      if (hasError && isInputTypingField) {
        inputFields[0].children[0].classList.remove(`input-${formColor}`);
        inputFields[0].children[0].classList.add("input-error");
      }
    });
  }
}
