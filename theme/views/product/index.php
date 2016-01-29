<?php $form = $this->beginWidget('CActiveForm', array(
	'id'=>'product'
));

//Note we used form-named DIVs with the Yii CHtml::tag() command so our javascript can update fields when choosing matrix items
?>

<div class="product-detail">
  <h2 class="product-header gutter-top-double gutter-bottom-double text-center">
  <strong><?= CHtml::link($model->family->family,$model->family->Link) ?></strong>
  <?= CHtml::tag('div',array('id'=>CHtml::activeId($model,'title')),$model->Title); ?>
  </h2>

  <div class="row">
    <div class="col-sm-6">
      <div id="photos">
        <?= $this->renderPartial('/product/_photos', array('model'=>$model), true); ?>
   		</div>
    </div>
    <div class="col-sm-6">
      <?= CHtml::tag('div',
   			array('id'=>CHtml::activeId($model,'description_long'),'class'=>'description'),
        $model->WebLongDescription); ?>
<div class="row gutter-top">
<div class="col-sm-6">

            <?php if ($model->IsMaster): ?>
                <?php $this->widget('ext.wsmenu.wsmatrixselector', array(
                    'form'=> $form,
                    'model'=> $model
                  )); //matrix chooser ?>
            <?php endif; ?>
            <?php if (!_xls_get_conf('DISABLE_CART', false)): ?>
                <div class="span3 qty clearfix" <?= (_xls_get_conf('SHOW_QTY_ENTRY') ? '' : 'style="display:none;"'); ?>>
                  <span>
                    <?= $form->labelEx($model, 'intQty'); ?>
                    <?= $form->textField(
                      $model,
                      'intQty',
                      $htmlOptions = array('type' => 'number')
                    );
                    ?>
                  </span>
                </div>
                <div>

                  <?php if ($model->getIsAddable() === true):?>
                    <?php
                      $matrixProduct = null;
                      if($model->IsMaster === true)
                        {
                        $matrixProduct = 'js:{"product_size": $("#SelectSize option:selected").val(),
                        "product_color": $("#SelectColor option:selected").val(),
                        "id": ' . $model->id . ',
                        "qty": $("#' . CHtml::activeId($model, 'intQty') . '").val() }';
                      }
                      else
                      {
                        $matrixProduct = array('id' => $model->id, 'qty' => 'js:$("#' . CHtml::activeId($model, 'intQty') . '").val()');
                      }
                    ?>

              <?= CHtml::tag('div',array('id'=>CHtml::activeId($model,'FormattedPrice'),'class'=>'price gutter-bottom'),$model->Price); ?>

              <?= CHtml::tag('div',array('id'=>CHtml::activeId($model,'FormattedRegularPrice').'_wrap','class'=>'price_reg',
                  'style'=>(!$model->SlashedPrice ? 'display:none' : '')),
                  Yii::t('product', 'Regular Price').": ".
                    CHtml::tag('span',array('id'=>CHtml::activeId($model,'FormattedRegularPrice'),
                      'class'=>'price_slash'),$model->SlashedPrice));
              ?>
</div></div><div class="col-sm-6">

                    <?= CHtml::tag(
                      'div', array(
                      'id' => 'addToCart',
                      'onClick' => CHtml::ajax(
                        array(
                          'url' => array('cart/AddToCart'),
                          //If we are viewing a matrix product, Add To Cart needs to pass selected options, otherwise just our model id
                          'data' => $matrixProduct,
                          'type' => 'POST',
                          'dataType' => 'json',
                          'success' => 'js:function(data){
                                  var afterAddCart = ' . CJSON::encode(CPropertyValue::ensureInteger(_xls_get_conf('AFTER_ADD_CART'))) . ';
                                  var editCartUrl = "' . Yii::app()->createUrl("/editcart") . '";
                                  if (data.action == "alert")
                                  {
                                    alert(data.errormsg);
                                  }
                                  else if (data.action == "success")
                                  {
                                    if (afterAddCart === 1)
                                    {
                                      window.location.href = editCartUrl;
                                    }
                                    else
                                    {
                                       $("#shoppingcart").replaceWith(data.shoppingcart);
                                       $("#cartItemsTotal").text(data.totalItemCount);
                                       sleep(250, showModal);
                                     }
                                  }
                                }'
                        )
                      ),
                                   ), CHtml::link(Yii::t('product', 'Add to Cart'), '#', array('class'=>'btn btn-primary'))
                    );?></div>
                  <?php else: ?>
                    <div class="outer span5" id="out-of-stock"><?= Yii::t('product', 'Out of stock')?></div>
                  <?php endif; ?>

                  <?php
                    if (_xls_get_conf('ENABLE_WISH_LIST'))
                    {
                      echo CHtml::tag('div',array(
                        'id'=>'addToWishList',
                        'class'=>'wishlist span4',
                        'onClick'=>CHtml::ajax(array(
                          'url'=>array('wishlist/add'),
                          'data'=>array('id'=>$model->id,
                            'qty'=>'js:$("#'.CHtml::activeId($model,'intQty').'").val()',
                            'size'=>'js:$("#SelectSize option:selected").val()',
                            'color'=>'js:$("#SelectColor option:selected").val()'),
                          'type'=>'POST',
                          'success' => 'function(data) {
                                      if (data=="multiple")
                                      {
                                        $("#WishitemShare").dialog("open");
                                      }
                                      else
                                      {
                                        alert(data);
                                      }
                                    }'
                        )),
                      ),CHtml::link(Yii::t('product', 'Add to Wish List'), '#'));
                    }
                  ?>
                </div>

                <div class="span11">
                  <?php
                    $this->widget('zii.widgets.grid.CGridView', array(
                      'id' => 'autoadd',
                      'dataProvider' => $model->autoadd(),
                      'showTableOnEmpty'=>false,
                      'selectableRows'=>0,
                      'emptyText'=>'',
                      'summaryText' => Yii::t('global',
                        'The following related products will be added to your cart automatically with this purchase:'),
                      'hideHeader'=>false,
                      'columns' => array(
                        'SliderImageTag:html',
                        'TitleTag:html',
                        'Price',
                      ),
                    ));
                  ?>
                </div>
            <?php endif; ?>
      </div>
    </div>
  </div>
<?php $this->endWidget(); ?>