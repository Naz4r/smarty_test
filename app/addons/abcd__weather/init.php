<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
fn_register_hooks(
  'get_weather_data',
    'abcd__weather_get_block_weather'
);
require_once __DIR__ . '/func.php';
