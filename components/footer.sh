#!/usr/bin/env bash

cat <<'EOF'
<footer class="site-footer">
  <div class="site-footer__inner">
    <div class="footer-content">
      <div class="footer-section">
        <h3>About This Site</h3>
        <p>&copy; 2025 Mohammad Firas Sada. All rights reserved.</p>
        <p>Personal website showcasing research, projects, and technical insights.</p>
      </div>
      
      <div class="footer-section">
        <h3>Built with bash-stack</h3>
        <p>This site is powered by <a href="https://github.com/cgsdev0/bash-stack" target="_blank">bash-stack</a>, an innovative HTTP server and framework for building modern web applications entirely in Bash.</p>
        
        <h4>Key Features:</h4>
        <ul>
          <li><strong>File-based routing:</strong> All routes exist as .sh files in the pages/ folder</li>
          <li><strong>HTTP request handling:</strong> Framework locates and executes corresponding scripts</li>
          <li><strong>stdout to HTTP:</strong> Anything written to stdout becomes the HTTP response body</li>
          <li><strong>HTMX integration:</strong> Included by default for dynamic interactions</li>
          <li><strong>Static site generation:</strong> Pre-renders dynamic content for deployment</li>
        </ul>
      </div>
      
      <div class="footer-section">
        <h3>Deployment & CI/CD</h3>
        <p>This site is automatically deployed using GitHub Actions with the following workflow:</p>
        
        <h4>Build Process:</h4>
        <ol>
          <li><strong>Trigger:</strong> Push to main/master branch</li>
          <li><strong>Environment:</strong> Ubuntu runner with Node.js 18</li>
          <li><strong>Dependencies:</strong> Install jq for JSON processing</li>
          <li><strong>Build:</strong> Run build.sh to generate static files</li>
          <li><strong>Deploy:</strong> Push to gh-pages branch via GitHub Pages</li>
        </ol>
        
        <h4>Technical Stack:</h4>
        <ul>
          <li><strong>Server:</strong> bash-stack (Bash 5+ with associative arrays)</li>
          <li><strong>Styling:</strong> Custom CSS (inspired by Basically Basic Jekyll theme)</li>
          <li><strong>Content:</strong> Markdown blog posts with frontmatter parsing</li>
          <li><strong>Data:</strong> JSON configuration files + GitHub API integration</li>
          <li><strong>Hosting:</strong> GitHub Pages (static site hosting)</li>
        </ul>
      </div>
      
      <div class="footer-section">
        <h3>Architecture</h3>
        <p>The site uses a component-based architecture where each UI element is a reusable Bash script:</p>
        
        <h4>Components:</h4>
        <ul>
          <li><code>header.sh</code> - Navigation and site branding</li>
          <li><code>intro.sh</code> - Profile section with social links</li>
          <li><code>recent-posts.sh</code> - Blog post listings</li>
          <li><code>projects.sh</code> - GitHub repository integration</li>
          <li><code>footer.sh</code> - This technical documentation</li>
        </ul>
        
        <h4>Pages:</h4>
        <ul>
          <li><code>index.sh</code> - Homepage composition</li>
          <li><code>blog.sh</code> - Blog listing page</li>
          <li><code>blog/[slug].sh</code> - Dynamic blog post rendering</li>
        </ul>
      </div>
    </div>
    
    <div class="footer-bottom">
      <p>Built with ❤️ using bash-stack | <a href="https://github.com/groundsada/groundsada.github.io" target="_blank">View Source</a></p>
    </div>
  </div>
</footer>
EOF






