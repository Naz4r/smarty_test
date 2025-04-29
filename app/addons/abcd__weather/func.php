<?php

use Tygh\Http;
use Tygh\Registry;
use Tygh\Settings;

if (!defined('BOOTSTRAP')) { die('Access denied'); }


function fn_abcd__weather_get_city_id_from_api($city_name)
{
    $api_key = 'af61ead54f4050bd0f514d7c47360542';
    $url = "http://api.openweathermap.org/data/2.5/weather?q=" . urlencode($city_name) . "&appid={$api_key}&lang=ua";

    $response = fn_get_contents($url);

    if ($response) {
        $data = json_decode($response, true);
        if (!empty($data['id'])) {
            return $data['id'];
        }
    }
    return null;
}


function fn_abcd__weather_get_weather_by_api_id_from_db($api_id)
{
    $api_key = 'af61ead54f4050bd0f514d7c47360542';
    $url = "http://api.openweathermap.org/data/2.5/weather?id={$api_id}&appid={$api_key}&units=metric&lang=ua";

    $response = Http::get($url);

    if ($response) {
        $data = json_decode($response, true);
        if (!empty($data)) {
            return $data;
        }
    }

    return null;
}

function fn_abcd__get_weather_cities() {
    $lang_code = CART_LANGUAGE;

    $cities = db_get_array(
        "SELECT c.city_id, t.city_name 
         FROM ?:abcd__weather_cities AS c
         JOIN ?:abcd__weather_city_descriptions AS t ON c.city_id = t.city_id 
         WHERE t.lang_code = ?s AND c.status = 'A'",
        $lang_code
    );

    $variants = [];
    foreach ($cities as $city) {
        $variants[$city['city_id']] = $city['city_name'];
    }

    return $variants;
}

function fn_abcd__weather_get_block_weather($value, $block, $block_scheme)
{

    $city_id = !empty($block['content']['city']) ? (int)$block['content']['city'] : null;



    $api_id = db_get_field("SELECT api_id FROM ?:abcd__weather_cities WHERE city_id = ?i", $city_id);

    if (empty($api_id)) {
        return [];
    }

    $lang_code = CART_LANGUAGE;


    $city_name = db_get_field(
        "SELECT t.city_name 
         FROM ?:abcd__weather_city_descriptions AS t 
         WHERE t.city_id = ?i AND t.lang_code = ?s",
        $city_id, $lang_code
    );

    if (empty($city_name)) {
        return [];
    }


    $weather_data = get_weather_from_api($api_id);

    if (empty($weather_data)) {
        return [];
    }
    $last_update = date('Y-m-d H:i:s');


    $result = [
        'city_name' => $city_name,
        'humidity' => $weather_data['humidity'] ?? 0,
        'temp' => $weather_data['temp'] ?? 0,
        'description' => $weather_data['description'] ?? 'No description',
        'wind' => $weather_data['wind'] ?? 0,
         'last_update' => $last_update
    ];

    return $result;
}

function get_weather_from_api($api_id)
{

    $api_key = 'af61ead54f4050bd0f514d7c47360542';


    $url = "http://api.openweathermap.org/data/2.5/weather?id={$api_id}&appid={$api_key}&units=metric&lang=ua";


    $response = Http::get($url);


    if ($response) {

        $data = json_decode($response, true);


        if (!empty($data) && isset($data['main']) && isset($data['weather'][0]) && isset($data['wind'])) {

            $weather_data = [
                'temp' => $data['main']['temp'],
                'humidity' => $data['main']['humidity'],
                'description' => $data['weather'][0]['description'],
                'wind' => $data['wind']['speed'],
            ];

            return $weather_data;
        }
    }


    return null;
}

