<h2 id="weather_city_title">{__("weather.in_city", ["[city]" => $selected_city_name])}</h2>
<div class="ty-abcd-weather-block" id="abcd_weather_container">
    <form method="get" action="{$config.current_url|fn_url}">
        <label for="weather_city_selector">{__("weather.select_city")}:</label>
        <select name="city_id" id="weather_city_selector">
            {foreach from=$cities item=city}
                <option value="{$city.city_id}" {if $city.city_id == $selected_city_id}selected{/if}>
                    {$city.city_name}
                </option>
            {/foreach}
        </select>
    </form>

    <div class="ty-abcd-weather-info" id="weather_info">
        <p><strong>{__("weather.temperature")}:</strong> <span id="weather_temperature">{$weather_data.main.temp|default:"?"}°C</span></p>
        <p><strong>{__("weather.humidity")}:</strong> <span id="weather_humidity">{$weather_data.main.humidity|default:"?"}%</span></p>
        <p><strong>{__("weather.weather")}:</strong> <span id="weather_description">{$weather_data.weather.0.description|default:"-"}</span></p>
        <p><strong>{__("weather.wind")}:</strong> <span id="weather_wind">{$weather_data.wind.speed|default:"?"} м/с</span></p>
    </div>

    <p><strong>{__("weather.last_update")}:</strong> <span id="weather_last_update">{$last_update|default:"?"}</span></p>

    <div class="ty-abcd-weather-timer">
        <p>{__("weather.next_update_in")}: <span id="update_timer">{$next_update_in}</span></p>
    </div>
</div>


{script src="js/addons/abcd__weather/weather.js"}