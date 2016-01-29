<?php $this->beginContent('//layouts/main'); ?>
		<?php $this->widget(
			'zii.widgets.CBreadcrumbs',
			array(
		        'links' => $this->breadcrumbs,
				'homeLink' => CHtml::link("Home", array('/site/index')),
				'separator' => ' — ',
	        )
		);?>
		<!-- breadcrumbs -->

		<?= $this->renderPartial('/site/_flashmessages',null, true); ?>
		<!-- flash messages -->

		<div id="viewport">
		    <?php echo $content; ?>
	    </div>
<?= $this->renderPartial('/site/_sidecart',null, true); ?>
<?php $this->endContent();
