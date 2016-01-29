<div class="pr-photos">
  <?php foreach($model->ProductPhotos as $photo) {
  echo "<div class=\"image\" data-image=\"".$photo["image_large"]."\" data-thumb=\"".$photo["image"]."\" data-alt=\"".$photo["image_alt"]."\"></div>";
  } ?>
</div>

<script type="text/html" id="product-carousel-template">
  <div class="primary-image">
    <a href="#" class="zoom">+ ZOOM</a>
    <img src="{{ primary_image.image }}" alt="{{ primary_image.alt }}" />
  </div>
  {{#multiple_images}}
  <div class="row row-5-col gutter-top pr-photos-toolbar">
    <div class="col-xs-1"><span class="current-index">1</span> / {{ total_images }}</div>
    {{#images}}
    <div class="col-xs-1">
      <a href="#" data-image="{{ image }}" data-alt="{{ alt }}" data-index="{{ index }}" {{#active}}class="active"{{/active}}>
        <img src="{{ thumb }}" alt="{{ alt }}" />
      </a>
    </div>
    {{/images}}
  </div>
  {{/multiple_images}}
</script>

<script type="text/html" id="image-zoom-template">
<div class="pr-overlay overlay-zoom">
  <img src="{{ image }}" alt="{{ alt }}" />
</div>
</script>
