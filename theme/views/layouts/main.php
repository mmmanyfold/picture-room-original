<!DOCTYPE html>
<html lang="<?= Yii::app()->language ?>">
	<!-- <head> section -->
	<?php echo $this->renderPartial("/site/_head",null,true,false); ?>

	<body>
    <script>
      window.fbAsyncInit = function() {
      FB.init({
      appId      : '1107634402609958',
      xfbml      : true,
      version    : 'v2.5'
      });
      };

      (function(d, s, id){
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/sdk.js";
      fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));
    </script>
		<?php echo $this->sharingHeader; ?>
		<div id="container" class="container">

			<!-- template header -->
			<?php echo $this->renderPartial("/site/_header",null,true,false); ?>

			<!-- Require the navigation -->
			<?php echo $this->renderPartial("/site/_navigation",null,true,false); ?>

      <div class="row row-5-col">
        <div class="col-sm-1">
					<?php echo $this->renderPartial("/site/_sidenavigation",null,true,false); ?>
        </div>
        <div class="col-sm-4">
					<?php echo $content; ?>
        </div>
      </div>

			<!-- footer -->
			<?php echo $this->renderPartial("/site/_footer",null,true,false); ?>

		</div>

		<?php echo $this->sharingFooter; ?>

		<!-- backwards compatibility only, to be removed by version 3.2 -->
		<?php echo $this->loginDialog; ?>
   <script type="text/javascript" src="<?=Yii::app()->theme->baseUrl."/js/scripts.min.js" ?>"></script>
	</body>
</html>
