
{capture name="mainbox"}
    <form action="{""|fn_url}" method="post" name="weather_form" id="weather_form">
        <input type="hidden" name="sl" value="{$smarty.request.sl|default:$smarty.const.DESCR_SL}" />

        {include file="common/pagination.tpl" params=$params}

        <div class="bulk-edit clearfix" style="display: none;">
            <ul class="btn-group bulk-edit__wrapper">
                <li class="btn bulk-edit__btn bulk-edit__btn--delete">
                    <span class="bulk-edit__btn-content dropdown-toggle" data-toggle="dropdown">
                        {__("weather.actions")} <span class="caret"></span>
                    </span>
                    <ul class="dropdown-menu">
                        <li>
                            <a class="cm-submit cm-confirm"
                               data-ca-dispatch="dispatch[abcd__weather.delete_city]"
                               data-ca-target-form="weather_form"
                               data-ca-confirm-text="{__("weather.confirm_delete_selected")}">
                                {__("weather.delete_selected")}
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-middle table--relative table-responsive table--overflow-hidden">
                <thead data-ca-bulkedit-default-object="true" data-ca-bulkedit-component="defaultObject">
                <tr>
                    <th class="center {$no_hide_input} mobile-hide table__check-items-column">
                        {include file="common/check_items.tpl" check_statuses=""|fn_get_default_status_filters:true}
                    </th>
                    <th>{__("weather.city")}</th>
                    <th class="center">{__("weather.tools")}</th>
                    <th class="right nowrap">{__("weather.status")}</th>
                </tr>
                </thead>
                <tbody>
                {if $cities}
                    {foreach from=$cities item=city}
                        <tr class="cm-longtap-target">
                            <td class="center {$no_hide_input} mobile-hide table__check-items-column">
                                <input type="checkbox" name="city_ids[]" value="{$city.city_id}" class="cm-item" />
                            </td>
                            <td data-th="{__("weather.city")}">
                                <a href="{"abcd__weather.update?city_id=`$city.city_id`&sl=`$smarty.request.sl|default:$smarty.const.DESCR_SL`"|fn_url}">{$city.city_name}</a>
                            </td>

                            <td class="center" data-th="{__("weather.tools")}">
                                <div class="hidden-tools">
                                    {capture name="tools_list_`$city.city_id`"}
                                        <li>{btn type="list" text=__("weather.edit") href="abcd__weather.update?city_id=`$city.city_id`&sl=`$smarty.request.sl|default:$smarty.const.DESCR_SL`"}</li>
                                        <li>{btn type="list" text=__("weather.delete") class="cm-confirm" href="abcd__weather.delete_city?city_id=`$city.city_id`&sl=`$smarty.request.sl|default:$smarty.const.DESCR_SL`" method="POST"}</li>
                                    {/capture}
                                    {assign var="tools_name" value="tools_list_"|cat:$city.city_id}
                                    {dropdown content=$smarty.capture.$tools_name class="dropleft"}
                                </div>
                            </td>

                            <td class="right nowrap" data-th="{__("weather.status")}">
                                <div class="dropdown"
                                     id="status_wrapper_{$city.city_id}"
                                     data-status-wrapper
                                     data-city-id="{$city.city_id}"
                                     data-status="{$city.status}"
                                     style="position: relative; display: inline-block;">

                                </div>
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="4" class="no-items">{__("weather.no_data")}</td>
                    </tr>
                {/if}
                </tbody>
            </table>
        </div>

        {include file="common/pagination.tpl" params=$params}
    </form>
{/capture}

{capture name="sidebar"}
    <form action="{""|fn_url}" method="get" name="weather_filter_form" class="sidebar-row">
        <h4>{__("weather.search")}</h4>
        <input type="hidden" name="dispatch" value="abcd__weather.manage" />
        <input type="hidden" name="page" value="1" />
        <input type="hidden" name="lang_code" value="{$params.lang_code}" />
        <input type="hidden" name="sl" value="{$smarty.request.sl|default:$smarty.const.DESCR_SL}" />

        <div class="control-group">
            <label for="city_query" class="control-label">{__("weather.city")}:</label>
            <div class="controls">
                <input type="text" name="city_query" id="city_query" value="{$params.city_query}" class="input-medium" />
            </div>
        </div>

        <div class="buttons-container">
            {include file="buttons/search.tpl" but_name="dispatch[abcd__weather.manage]"}
        </div>
    </form>
{/capture}

{capture name="buttons"}
    {include file="common/tools.tpl"
    tool_href="abcd__weather.add?sl=`$smarty.request.sl|default:$smarty.const.DESCR_SL`"
    title=__("weather.add")
    icon="icon-plus"
    }
{/capture}

{include file="common/mainbox.tpl"
title=__("weather.weather_informer")
content=$smarty.capture.mainbox
buttons=$smarty.capture.buttons
sidebar=$smarty.capture.sidebar
select_languages=true
}

{script src="js/addons/abcd__weather/bulk_edit.js"}
{script src="js/addons/abcd__weather/update_status.js"}
{literal}
<script>
    Tygh.tr({
        'weather.active': '{/literal}{__("weather.active")|escape:"javascript"}{literal}',
        'weather.disabled': '{/literal}{__("weather.disabled")|escape:"javascript"}{literal}'
    });
</script>
{/literal}
