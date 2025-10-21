#!/bin/bash

# Arguments: form_id section_id
FORM_ID=$1
SECTION_ID=$2

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load form data
FORMS=$(cat "$PROJECT_ROOT/data/forms.json")

if command -v jq &> /dev/null; then
  ACTION=$(echo "$FORMS" | jq -r ".$FORM_ID.action")
  TITLE=$(echo "$FORMS" | jq -r ".$FORM_ID.title")
  DESC=$(echo "$FORMS" | jq -r ".$FORM_ID.description")
else
  # Fallback based on form_id
  if [[ "$FORM_ID" == "resume" ]]; then
    ACTION="https://formspree.io/f/xbjvnyog"
    TITLE="Request Resume"
    DESC="Please fill out this form if you'd like to receive a copy of my resume!"
  else
    ACTION="https://formspree.io/f/mrgwnkqe"
    TITLE="Contact"
    DESC="Please fill out this form to connect!"
  fi
fi

cat <<EOF
<section id="$SECTION_ID" class="contact sec-pad dynamicBg">
  <div class="main-container">
    <h2 class="heading heading-sec heading-sec__mb-med">
      <span class="heading-sec__main heading-sec__main--lt">$TITLE</span>
      <span class="heading-sec__sub heading-sec__sub--lt">
        $DESC
      </span>
    </h2>
    <div class="contact__form-container">
      <form action="$ACTION" class="contact__form" method="POST">
        <div class="contact__form-field">
          <label class="contact__form-label" for="name">Name</label>
          <input
            required
            placeholder="Enter Your Name"
            type="text"
            class="contact__form-input"
            name="name"
            id="name"
          />
        </div>
        <div class="contact__form-field">
          <label class="contact__form-label" for="email">Email</label>
          <input
            required
            placeholder="Enter Your Email"
            type="text"
            class="contact__form-input"
            name="email"
            id="email"
          />
        </div>
        <div class="contact__form-field">
          <label class="contact__form-label" for="message">Message</label>
          <textarea
            required
            cols="30"
            rows="10"
            class="contact__form-input"
            placeholder="Enter Your Message"
            name="message"
            id="message"
          ></textarea>
        </div>
        <button type="submit" class="btn btn--theme contact__btn">
          Submit
        </button>
      </form>
    </div>
  </div>
</section>
EOF

