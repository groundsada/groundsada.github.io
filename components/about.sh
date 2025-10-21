#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load profile data
PROFILE=$(cat "$PROJECT_ROOT/data/profile.json")

# Extract about section using jq if available, otherwise use grep
if command -v jq &> /dev/null; then
  ABOUT_TITLE=$(echo "$PROFILE" | jq -r '.about.title')
  ABOUT_DESC=$(echo "$PROFILE" | jq -r '.about.description')
  ABOUT_PARA1=$(echo "$PROFILE" | jq -r '.about.details[0]')
  ABOUT_PARA2=$(echo "$PROFILE" | jq -r '.about.details[1]')
else
  ABOUT_TITLE="About Me"
  ABOUT_DESC="Passionate about applying cutting-edge AI techniques in real-world scenarios. Specialized in ML predictive models, advanced neural networks, NLP, and full-stack development. Well-versed in technologies like Flask, PyQt5, and Dart/Flutter. Proficient in data mining, collaborative innovation, and FPGA programming for network and AI applications using P4. Eager to leverage my skills in the dynamic and evolving landscape of technology."
  ABOUT_PARA1="Hey there! I'm <strong>Mohammad Firas Sada</strong>, an upcoming Master's Graduate in <strong>Artificial Intelligence</strong> with a knack for <strong>Software Engineering</strong>. Based in <strong>Chicago, IL</strong>, I'm all about crafting innovative solutions using languages like <strong>C/C++, Python</strong>, and more."
  ABOUT_PARA2="From boosting network acceleration with <strong>FPGAs</strong> at the <strong>San Diego Supercomputer Center</strong> to implementing predictive models at <strong>SAP</strong>, I love diving into tech challenges. Let's connect!"
fi

cat <<EOF
<section id="about" class="about sec-pad">
  <div class="main-container">
    <h2 class="heading heading-sec heading-sec__mb-med">
      <span class="heading-sec__main">About</span>
      <span class="heading-sec__sub">
        $ABOUT_DESC
      </span>
    </h2>
    <div class="about__content">
      <div class="about__content-main" style="max-width: 100%;">
        <div class="about__content-details">
          <p class="about__content-details-para">
            $ABOUT_PARA1
          </p>
          <p class="about__content-details-para">
            $ABOUT_PARA2
          </p>
        </div>
      </div>
    </div>
  </div>
</section>
EOF

