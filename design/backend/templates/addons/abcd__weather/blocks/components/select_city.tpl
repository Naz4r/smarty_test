{if $option.values}
    <label for="{$html_id}">
        {if $option.option_name}{__($option.option_name)}{else}{__($name)}{/if}
    </label>
    <select id="{$html_id}" name="{$html_name}">
        {foreach from=$option.values key="k" item="v"}
            <option value="{$k}" {if $value == $k || (!$value && $option.default_value == $k)}selected="selected"{/if}>
                {$v}
            </option>
        {/foreach}
    </select>
{else}
    <p>{__("no_cities_available")}</p>
{/if}
