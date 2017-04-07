{% extends '_layout.swig' %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}
  {% set page_title_suffix = ' | ' + config.title %}

  {% if page.type === "categories" and not page.title  %}
    {{ __('title.category') + page_title_suffix }}
  {% elif page.type === "tags" and not page.title  %}
    {{ __('title.tag') + page_title_suffix }}
  {% else %}
    {{ page.title + page_title_suffix }}
  {% endif %}
{% endblock %}

{% block content %}

  <div id="posts" class="posts-expand">
  {% include '_partials/page-header.swig' %}
    {# tagcloud page support #}
    {% if page.type === "tags" %}
      <div class="tag-cloud">
        <div class="tag-cloud-title">
            {{ _p('counter.tag_cloud', site.tags.length) }}
        </div>
        <div class="tag-cloud-tags">
          {{ tagcloud({min_font: 12, max_font: 30, amount: 200, color: true, start_color: '#ccc', end_color: '#111'}) }}
        </div>
      </div>
    {% elif page.type === 'categories' %}
      <div class="category-all-page">
        <div class="category-all-title">
            {{ _p('counter.categories', site.categories.length) }}
        </div>
        <div class="category-all">
          {{ list_categories() }}
        </div>
      </div>
    {% else %}
      {{ page.content }}
      <script src="http://kba977.github.io/js/src/printer.js"></script>
      <script>
            var str = '<br>基本上很安静，喜欢雨天喝红茶听歌看闲书<br>';
            str += '<br>买书如山崩，看书如抽丝<br>';
            str += '<br>在意文字或者字母的排列<br>';
            str += '<br>梦想是成为一个有趣的人<br>';
            str += '<br>喜欢素数和平方数<br>';
            str += '<br>很温和，比较懒<br>';
            str += '<br>正在学习日文<br>';
            str += '<br>万年小透明<br>';
            str += '<br>两脚书橱<br>';
            str += '<br>自以为是<br>';
            str += '<br>自娱自乐<br>';
            str += '<br>精英主义<br>';
            str += '<br>想养只狗<br>';
            str += '<br>洁癖<br>';
            str += '<br>自矜<br>';
            str += '<br>INTJ<br><br>';

            Printer.init(str, {
                "speed": 200,
                "selector": 'about',
                "hasCur": false,
                "lnStr": ""
            }).print();
      </script>
    {% endif %}
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}
