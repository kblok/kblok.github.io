---
layout: page
title: Today I Learned
permalink: /til/
redirect_from:
  - /til.html
---

Short notes. The rest of the blog is [in the archive]({{ '/archive/' | relative_url }}).

<ul class="landing-posts">
{% assign tils = site.tils | sort: "date" | reverse %}
{% for post in tils %}
  <li>
    <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d, %Y" }}</time>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
