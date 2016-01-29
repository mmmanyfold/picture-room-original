<div class="row row-5-col hidden-xs" id="menubar">
  <div class="col-sm-5 hidden-xs">
    <div class="separator"></div>
  </div>
   <div class="col-sm-4">
		 <?php if (count(CustomPage::model()->toptabs()->findAll()))
		 $this->widget('zii.widgets.CMenu', array(
		 'items'=>CustomPage::model()->toptabs()->findAll(),
		 'activeCssClass'=>'active',
		 'htmlOptions'=>array('class'=>'list-unstyled nav-page clearfix')
		 )); ?>
   </div>
   <div class="col-sm-1">
		<?php echo $this->renderPartial("/site/_search",array(),true); ?>
   </div>
   <div class="col-sm-5 hidden-xs">
     <div class="separator"></div>
   </div>
</div>