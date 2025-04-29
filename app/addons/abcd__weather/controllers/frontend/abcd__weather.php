<?php

use Tygh\Registry;
use Tygh\Database;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode === 'view') {

    $lang_code = CART_LANGUAGE;

    $cities = db_get_array(
        "SELECT c.city_id, t.city_name 
         FROM ?:abcd__weather_cities AS c
         JOIN ?:abcd__weather_city_descriptions AS t ON c.city_id = t.city_id 
         WHERE t.lang_code = ?s AND c.status = 'A'",
        $lang_code
    );

    $selected_city_id = isset($_REQUEST['city_id']) ? (int) $_REQUEST['city_id'] : ($cities[0]['city_id'] ?? 0);

    $weather_data = [];
    $last_update = '';
    $selected_city_name = '';
    foreach ($cities as $city) {
        if ($city['city_id'] == $selected_city_id) {
            $selected_city_name = $city['city_name'];
            break;
        }
    }

    if ($selected_city_id) {
        $api_id = db_get_field("SELECT api_id FROM ?:abcd__weather_cities WHERE city_id = ?i", $selected_city_id);
        $weather_data = fn_abcd__weather_get_weather_by_api_id_from_db($api_id);
        if (!empty($weather_data)) {
            $last_update = date('Y-m-d H:i:s');
        }
    }


    if (isset($_REQUEST['ajax']) && $_REQUEST['ajax'] === 'Y') {
        Tygh::$app['view']->assign([
            'weather_data' => $weather_data,
            'last_update' => $last_update,
            'next_update_in' => (int) Registry::get('addons.abcd__weather.update_interval') ?: 300,
        ]);

        echo json_encode([
            'weather_data' => $weather_data,
            'last_update' => $last_update,
            'next_update_in' => (int) Registry::get('addons.abcd__weather.update_interval') ?: 300,
            'selected_city_name' => $selected_city_name,
            'weather_title' => __('weather.in_city', ['[city]' => $selected_city_name]),
        ]);
        exit;
    }

    Tygh::$app['view']->assign([
        'cities' => $cities,
        'selected_city_id' => $selected_city_id,
        'selected_city_name' => $selected_city_name,
        'weather_data' => $weather_data,
        'last_update' => $last_update,
        'next_update_in' => Registry::get('addons.abcd__weather.update_interval') ?? 300,
    ]);
}
