<?php

use Tygh\Registry;
use Tygh\Database\Connection;


if (!defined('BOOTSTRAP')) {
    die('Access denied');
}


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if ($mode == 'update_city') {
        $city_data = $_REQUEST['city_data'];
        $translations = $_REQUEST['translations'];

        if (!empty($city_data['city_id'])) {

            db_query("UPDATE ?:abcd__weather_cities SET status = ?s WHERE city_id = ?i",
                $city_data['status'], $city_data['city_id']
            );


            foreach ($translations as $lang_code => $data) {
                $exists = db_get_field(
                    "SELECT 1 FROM ?:abcd__weather_city_descriptions WHERE city_id = ?i AND lang_code = ?s",
                    $city_data['city_id'], $lang_code
                );

                if ($exists) {
                    db_query("UPDATE ?:abcd__weather_city_descriptions SET city_name = ?s WHERE city_id = ?i AND lang_code = ?s",
                        $data['city_name'], $city_data['city_id'], $lang_code
                    );
                } else {
                    db_query("INSERT INTO ?:abcd__weather_city_descriptions (city_id, lang_code, city_name) VALUES (?i, ?s, ?s)",
                        $city_data['city_id'], $lang_code, $data['city_name']
                    );
                }
            }

        } else {

            $default_lang = CART_LANGUAGE;
            $city_name = trim($translations[$default_lang]['city_name']);

            $api_id = fn_abcd__weather_get_city_id_from_api($city_name);

            if (!$api_id) {
                fn_set_notification('E', __('error'), __('city_not_found_in_api'));
                return [CONTROLLER_STATUS_REDIRECT, 'abcd__weather.manage'];
            }


            $city_id = db_query("INSERT INTO ?:abcd__weather_cities (api_id, status) VALUES (?s, ?s)",
                $api_id, $city_data['status']
            );


            $languages = fn_get_languages();

            foreach ($languages as $lang_code => $_lang) {

                db_query("INSERT INTO ?:abcd__weather_city_descriptions (city_id, lang_code, city_name) VALUES (?i, ?s, ?s)",
                    $city_id, $lang_code, $city_name
                );
            }
        }

        return [CONTROLLER_STATUS_OK, 'abcd__weather.manage'];
    }


    if ($mode == 'delete_city') {
        $city_ids = [];

        if (!empty($_REQUEST['city_ids']) && is_array($_REQUEST['city_ids'])) {
            $city_ids = $_REQUEST['city_ids'];
        } elseif (!empty($_REQUEST['city_id'])) {
            $city_ids[] = (int) $_REQUEST['city_id'];
        }

        if (!empty($city_ids)) {
            db_query("DELETE FROM ?:abcd__weather_cities WHERE city_id IN (?a)", $city_ids);
            db_query("DELETE FROM ?:abcd__weather_city_descriptions WHERE city_id IN (?a)", $city_ids);
        }

        return [CONTROLLER_STATUS_OK, 'abcd__weather.manage'];
    }

    if ($mode === 'update_status') {
        $city_id = (int) $_REQUEST['city_id'];
        $new_status = $_REQUEST['status'];

        if ($city_id && in_array($new_status, ['A', 'D'])) {
            db_query("UPDATE ?:abcd__weather_cities SET status = ?s WHERE city_id = ?i", $new_status, $city_id);

            fn_set_notification('N', __('notice'), __('status_changed'));

            $response = [
                'status' => 'ok',
                'new_status' => $new_status,
                'city_id' => $city_id,
            ];


            Tygh::$app['ajax']->assign('status_update', $response);

            exit;
        }
    }


}


if ($mode === 'manage') {
    $params = array_merge([
        'page' => 1,
        'items_per_page' => 5,
        'city_query' => '',
    ], $_REQUEST);

    $lang_code = $_REQUEST['descr_sl']??CART_LANGUAGE;
    $condition = db_quote(" AND wt.lang_code = ?s", $lang_code);


    if (!empty($params['city_query'])) {
        $condition .= db_quote(" AND wt.city_name LIKE ?l", '%' . $params['city_query'] . '%');
    }

    $total = db_get_field("
        SELECT COUNT(*) FROM ?:abcd__weather_cities AS wc
        LEFT JOIN ?:abcd__weather_city_descriptions AS wt ON wc.city_id = wt.city_id
        WHERE 1 ?p", $condition
    );

    $limit = db_paginate($params['page'], $params['items_per_page']);

    $cities = db_get_array("
        SELECT wc.*, wt.city_name
        FROM ?:abcd__weather_cities AS wc
        LEFT JOIN ?:abcd__weather_city_descriptions AS wt ON wc.city_id = wt.city_id
        WHERE 1 ?p ?p", $condition, $limit
    );

    Tygh::$app['view']->assign([
        'cities' => $cities,
        'params' => $params,
        'search' => [
            'total_items' => $total,
            'items_per_page' => $params['items_per_page'],
            'page' => $params['page'],
            'city_query' => $params['city_query'],
            'lang_code' => $lang_code,
        ],
    ]);

}

if ($mode === 'update') {
    $city_id = $_REQUEST['city_id'];
    $lang_code = $_REQUEST['descr_sl'] ?? CART_LANGUAGE;

    // Основна таблиця
    $city = db_get_row("SELECT * FROM ?:abcd__weather_cities WHERE city_id = ?i", $city_id);

    // Переклади по всіх мовах
    $descriptions = db_get_hash_array(
        "SELECT * FROM ?:abcd__weather_city_descriptions WHERE city_id = ?i",
        'lang_code', $city_id
    );

    Tygh::$app['view']->assign('city', $city);
    Tygh::$app['view']->assign('translations', $descriptions);
}
