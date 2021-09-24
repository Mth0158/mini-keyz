import { Controller } from "stimulus";

export default class extends Controller {
  static get targets() {
    return ["radioBtn", "radioValue", "radioParent"];
  }

  toggle(event) {
    const btnColor = this.radioParentTarget.id.split("-")[2];
    console.log(btnColor);

    const blue = {
      classToApplyNotChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-white",
        "rounded",
        "border-2",
        "border-blue-200",
      ],
      classToApplyChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-blue-200",
        "rounded",
        "border-2",
        "border-blue-200",
        "outline-none",
        "ring-1",
        "ring-blue-400",
        "border-transparent",
      ],
    };

    const red = {
      classToApplyNotChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-white",
        "rounded",
        "border-2",
        "border-red-200",
      ],
      classToApplyChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-red-200",
        "rounded",
        "border-2",
        "border-red-200",
        "outline-none",
        "ring-1",
        "ring-red-400",
        "border-transparent",
      ],
    };

    const yellow = {
      classToApplyNotChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-white",
        "rounded",
        "border-2",
        "border-yellow-200",
      ],
      classToApplyChecked: [
        "flex",
        "justify-center",
        "items-center",
        "bg-yellow-200",
        "rounded",
        "border-2",
        "border-yellow-200",
        "outline-none",
        "ring-1",
        "ring-yellow-400",
        "border-transparent",
      ],
    };

    console.log(this.radioBtnTarget);
    console.log(this.radioValueTarget.checked);
    console.log(this.radioParentTarget.classList);
    // Check or uncheck on click
    event.preventDefault();
    this.radioValueTarget.checked = !this.radioValueTarget.checked;
    console.log(this.radioValueTarget.checked);

    // Change radio button style depending on styling
    if (this.radioValueTarget.checked) {
      this.radioParentTarget.classList.remove(
        ...eval(btnColor).classToApplyNotChecked
      );
      this.radioParentTarget.classList.add(
        ...eval(btnColor).classToApplyChecked
      );
    } else {
      this.radioParentTarget.classList.add(
        ...eval(btnColor).classToApplyNotChecked
      );
      this.radioParentTarget.classList.remove(
        ...eval(btnColor).classToApplyChecked
      );
    }
  }
}
