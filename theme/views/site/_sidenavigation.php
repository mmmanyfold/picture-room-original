<div class="side-nav hidden-xs">
  <h3>Shop</h3>
  <ul id="menutree" class="list-unstyled">
	  <?php foreach($this->MenuTree as $MenuBranch):
		echo
		'<li><a href="'.$MenuBranch['link'].'">'.$MenuBranch['label'].'</a></li>';
	  endforeach;  ?>
  </ul>
</div>
