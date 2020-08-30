<?php

// custom bootstrap

$app->on(['cockpit.assets.find', 'cockpit.assetsfolders.find.before'], function(&$options) use ($app) {
  if (!$app->module('cockpit')->isSuperAdmin()) {
    $options['filter']['_by'] = $app->user['_id'];
  };
});

$this->on('cockpit.asset.upload', function (&$asset, &$_meta, &$opts, &$file, &$path) use ($app) {
  $user = $app->module('cockpit')->getUser();
  if (!$app->helper('fs')->path("assets://users/{$user['_id']}")) {
    $app->helper('fs')->mkdir("assets://users/{$user['_id']}");
  }

  $clean = uniqid().preg_replace('/[^a-zA-Z0-9-_\.]/','', str_replace(' ', '-', $asset['title']));
  $path  = '/users/' . $user['_id'] . '/' .date('Y/m/d') . '/' . $clean;
  $asset['path'] = $path;
});
