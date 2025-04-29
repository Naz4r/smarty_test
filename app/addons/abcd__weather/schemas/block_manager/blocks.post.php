<?php

$schema['abcd__weather'] = array(
    'templates' => array(
        'addons/abcd__weather/blocks/abcd__weather_block.tpl' => array()
    ),
    'wrappers' => 'blocks/wrappers',
    'cache' => false,
    'content' => [
        'weather_data' => [
            'type' => 'function',
            'function' => ['fn_abcd__weather_get_block_weather'],
        ],
        'city' => [
            'type' => 'template',
            'template' => 'addons/abcd__weather/blocks/components/select_city.tpl',
            'hide_label' => false,
            'data_function' => array('fn_abcd__get_weather_cities'),
        ],
    ],

);

return $schema;