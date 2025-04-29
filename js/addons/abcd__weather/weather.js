const initialSeconds = parseInt('{$next_update_in|default:300}');

let timer;
let seconds = initialSeconds;

function formatTime(timeInSeconds) {
    const minutes = Math.floor(timeInSeconds / 60);
    const remainingSeconds = timeInSeconds % 60;
    return `${String(minutes).padStart(2, '0')}:${String(remainingSeconds).padStart(2, '0')}`;
}

function startTimer(startSeconds = initialSeconds) {
    seconds = startSeconds;
    clearInterval(timer);
    document.getElementById('update_timer').textContent = formatTime(seconds);

    timer = setInterval(() => {
        if (seconds > 0) {
            seconds--;
            document.getElementById('update_timer').textContent = formatTime(seconds);
        } else {
            clearInterval(timer);
            updateWeatherData();
        }
    }, 1000);
}

function updateWeatherData() {
    const cityId = document.getElementById('weather_city_selector').value;

    $.ajax({
        url: "index.php?dispatch=abcd__weather.view&ajax=Y",
        method: "GET",
        data: { city_id: cityId },
        dataType: "json",
        success: function(response) {
            $('#weather_temperature').text(response.weather_data.main.temp + "°C");
            $('#weather_humidity').text(response.weather_data.main.humidity + "%");
            $('#weather_description').text(response.weather_data.weather[0].description);
            $('#weather_wind').text(response.weather_data.wind.speed + " м/с");
            $('#weather_last_update').text(response.last_update);
            $('#weather_city_title').text(response.weather_title);
            startTimer(response.next_update_in);
        },
        error: function(xhr, status, error) {
            console.error("AJAX помилка: " + status + " - " + error);
        }
    });
}

document.getElementById('weather_city_selector').addEventListener('change', function() {
    updateWeatherData();
});

startTimer();