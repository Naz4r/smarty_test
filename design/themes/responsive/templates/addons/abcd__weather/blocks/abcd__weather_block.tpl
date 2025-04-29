
<div id="weather_block_{$block.block_id}" >
{if $weather_data}
    <h2 id="weather_city_title">{__("weather.in_city", ["[city]" => $weather_data.city_name])}</h2>

    <div class="ty-abcd-weather-info" id="weather_info">
        <p><strong>{__("weather.temperature")}:</strong> <span id="weather_temperature">{$weather_data.temp|default:"?"}°C</span></p>
        <p><strong>{__("weather.humidity")}:</strong> <span id="weather_humidity">{$weather_data.humidity|default:"?"}%</span></p>
        <p><strong>{__("weather.weather")}:</strong> <span id="weather_description">{$weather_data.description|default:"-"}</span></p>
        <p><strong>{__("weather.wind")}:</strong> <span id="weather_wind">{$weather_data.wind|default:"?"} м/с</span></p>
        <p><strong>{__("weather.last_update")}:</strong> <span id="weather_last_update">{$weather_data.last_update|default:"?"}</span></p>
    </div>
{else}
    <p>{__("weather.data_not_available")}</p>
{/if}
<button id="refresh-weather-btn_{$block.block_id}" class="btn btn-primary">{__("update")}</button>
    {assign var="city_id" value=$block.content.city}
    {assign var="city_url" value="abcd__weather.view?city_id=`$city_id`"|fn_url}

    <button type="button"
            class="btn btn-secondary"
            onclick="window.open('{$city_url}', '_blank')">
        {__("weather.view_on_page")}
    </button>

<script type="text/javascript">

    document.getElementById('refresh-weather-btn_{$block.block_id}').addEventListener('click', function() {
        location.reload();
    });
</script>
</div>