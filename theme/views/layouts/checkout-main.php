<!DOCTYPE html>
<html lang="<?= Yii::app()->language ?>">

<!-- <head> section -->
<?php echo $this->renderPartial("/site/_brooklynhead",null,true,false); ?>
<!--remove checkout-head from checkout folder-->

<body class="overlay">
<div id="container" class="container-fluid text-center">

	<!-- content -->
	<?php echo $content; ?>

</div>

</body>
</html>


