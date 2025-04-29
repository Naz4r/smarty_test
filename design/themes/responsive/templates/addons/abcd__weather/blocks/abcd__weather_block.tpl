
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
        document.getElementById('refresh-weather-btn_{$block.block_id}').addEventListener('click', function () {
            const block = this.closest('#weather_block_{$block.block_id}');
            const cityId = {$city_id};

            $.ajax({
                url: "index.php?dispatch=abcd__weather.view&ajax=Y",
                method: "GET",
                data: { city_id: cityId },
                dataType: "json",
                success: function(response) {
                    if (response.error) {
                        alert(response.error);
                        return;
                    }


                    block.querySelector('#weather_temperature').textContent = response.weather_data.main.temp + "°C";
                    block.querySelector('#weather_humidity').textContent = response.weather_data.main.humidity + "%";
                    block.querySelector('#weather_description').textContent = response.weather_data.weather[0].description;
                    block.querySelector('#weather_wind').textContent = response.weather_data.wind.speed + " м/с";
                    block.querySelector('#weather_last_update').textContent = response.last_update;
                    block.querySelector('#weather_city_title').textContent = response.weather_title;
                },
                error: function(xhr, status, error) {
                    console.error("AJAX помилка: " + status + " - " + error);
                }
            });
        });
    </script>
</div>