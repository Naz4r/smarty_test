{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" name="city_form" enctype="multipart/form-data">
        <input type="hidden" name="dispatch" value="abcd__weather.update_city">

        {if $city.city_id}
            <input type="hidden" name="city_data[city_id]" value="{$city.city_id}">
        {/if}


        {assign var="lang_code" value=$smarty.request.descr_sl|default:$smarty.const.CART_LANGUAGE}

        <div class="control-group">
            <label class="control-label" for="city_name">
                {__("weather.city_name_label")} ({$languages[$lang_code].name})
            </label>
            <div class="controls">
                <input type="text"
                       name="translations[{$lang_code}][city_name]"
                       id="city_name"
                       value="{$translations[$lang_code].city_name|default:''}"
                       class="input-large"
                       placeholder="{__("weather.city_name_placeholder")}"
                       required>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="status">{__("weather.status_label")}</label>
            <div class="controls">
                <select name="city_data[status]" id="status">
                    <option value="A" {if $city.status == "A"}selected{/if}>{__("weather.active")}</option>
                    <option value="D" {if $city.status == "D"}selected{/if}>{__("weather.disabled")}</option>
                </select>
            </div>
        </div>

        <div class="buttons-container">
            {if $city.city_id}
                {assign var="but_text" value=__("save")}
            {else}
                {assign var="but_text" value=__("create")}
            {/if}

            <div class="buttons">
                <button class="btn btn-primary" type="submit" name="dispatch[abcd__weather.update_city]">{$but_text}</button>
                <a class="btn cm-back-link" href="{"abcd__weather.manage"|fn_url}">{__("cancel")}</a>
            </div>
        </div>
    </form>

{/capture}


{include file="common/mainbox.tpl"
title=($city.city_id|default:false) ? __("weather.edit_city") : __("weather.new_city")
content=$smarty.capture.mainbox
select_languages=true
}
