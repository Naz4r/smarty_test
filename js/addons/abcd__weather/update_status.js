(function (_, $) {

    function renderStatusDropdown(cityId, status) {

        const statusText = status === 'A' ? _.tr('weather.active') : _.tr('weather.disabled');
        const oppositeStatus = status === 'A' ? 'D' : 'A';
        const oppositeText = oppositeStatus === 'A' ? _.tr('weather.active') : _.tr('weather.disabled');

        const dropdownHtml = `
            <a class="btn btn-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                ${statusText}
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu" style="position: absolute; top: 100%; left: 0; z-index: 1050; min-width: 160px;">
                <li class="${status === 'A' ? 'disabled' : ''}">
                    <a class="cm-update-status ${status === 'A' ? 'disabled' : ''}"
                       data-city-id="${cityId}"
                       data-status="A"
                       data-url="admin.php?dispatch=abcd__weather.update_status">
                        ${_.tr('weather.active')}
                    </a>
                </li>
                <li class="${status === 'D' ? 'disabled' : ''}">
                    <a class="cm-update-status ${status === 'D' ? 'disabled' : ''}"
                       data-city-id="${cityId}"
                       data-status="D"
                       data-url="admin.php?dispatch=abcd__weather.update_status">
                        ${_.tr('weather.disabled')}
                    </a>
                </li>
            </ul>
        `;

        $('#status_wrapper_' + cityId).html(dropdownHtml);
        $.ceEvent('trigger', 'ce.commoninit', [$('#status_wrapper_' + cityId)]);
    }

    $(document).on('click', '.cm-update-status:not(.disabled)', function (e) {
        e.preventDefault();

        const $el = $(this);
        const cityId = $el.data('city-id');
        const newStatus = $el.data('status');
        const url = $el.data('url');

        if (!cityId || !newStatus || !url) {
            return;
        }

        $.ceAjax('request', url, {
            method: 'post',
            data: {
                city_id: cityId,
                status: newStatus
            },
            caching: false,
            callback: function (response) {
                const statusUpdate = response.status_update;
                if (statusUpdate && statusUpdate.city_id && statusUpdate.new_status) {
                    renderStatusDropdown(statusUpdate.city_id, statusUpdate.new_status);
                }
            }
        });
    });


    $.ceEvent('on', 'ce.commoninit', function (context) {
        $('[data-status-wrapper]', context).each(function () {
            const $el = $(this);
            const cityId = $el.data('city-id');
            const status = $el.data('status');

            if (cityId && status) {
                renderStatusDropdown(cityId, status);
            }
        });
    });

})(Tygh, Tygh.$);

