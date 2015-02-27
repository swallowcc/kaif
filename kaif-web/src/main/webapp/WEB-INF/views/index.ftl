<#import "/spring.ftl" as spring />
<#import "macros/template.ftl" as template>
<#import "macros/comp.ftl" as comp>
<#import "macros/url.ftl" as url>
<#import "macros/aside.ftl" as aside>

<#assign headContent>

<title>綜合文章區 | kaif.io</title>
<meta name="description" content="最新與最熱門的文章都在 kaif.io">

</#assign>

<@template.page
layout='full'
head=headContent
>

    <@template.home>
    <div class="grid">
        <div class="grid-body">
            <@comp.articleList data=articlePage showZone=true></@comp.articleList>
        </div>
        <aside class="grid-aside">
            <@aside.createArticle />
            <@aside.recommendZones zoneInfos=recommendZones />
        </aside>
    </div>
    </@template.home>

</@template.page>

<!--/\\\________/\\\______/\\\\\\\\\______/\\\\\\\\\\\___/\\\\\\\\\\\\\\\______/\\\\\\\\\__________________________/\\\_______
   _\/\\\_____/\\\//_____/\\\\\\\\\\\\\___\/////\\\///___\/\\\///////////_____/\\\\\\\\\\\\\_____________________/\\\//\\\_____
    _\/\\\__/\\\//_______/\\\/////////\\\______\/\\\______\/\\\_______________/\\\/////////\\\___________________/\\\_/\\\______
     _\/\\\\\\//\\\______\/\\\_______\/\\\______\/\\\______\/\\\\\\\\\\\______\/\\\_______\/\\\__________________\//\\\\//_______
      _\/\\\//_\//\\\_____\/\\\\\\\\\\\\\\\______\/\\\______\/\\\///////_______\/\\\\\\\\\\\\\\\_________________/\\\///\\\_______
       _\/\\\____\//\\\____\/\\\/////////\\\______\/\\\______\/\\\______________\/\\\/////////\\\_______________/\\\/__\///\\\/\\\_
        _\/\\\_____\//\\\___\/\\\_______\/\\\______\/\\\______\/\\\______________\/\\\_______\/\\\______________/\\\______\//\\\//__
         _\/\\\______\//\\\__\/\\\_______\/\\\___/\\\\\\\\\\\__\/\\\______________\/\\\_______\/\\\_____________\//\\\\\\\\\\\//\\\__
          _\///________\///___\///________\///___\///////////___\///_______________\///________\///_______________\///////////_\///___
  __/\\\________/\\\______/\\\\\\\\\______/\\\\\\\\\\\___/\\\\\\\\\\\\\\\______/\\\\\\\\\______/\\\\\_____/\\\______/\\\\\\\\\\\\_
   _\/\\\_____/\\\//_____/\\\\\\\\\\\\\___\/////\\\///___\/\\\///////////_____/\\\\\\\\\\\\\___\/\\\\\\___\/\\\____/\\\//////////__
    _\/\\\__/\\\//_______/\\\/////////\\\______\/\\\______\/\\\_______________/\\\/////////\\\__\/\\\/\\\__\/\\\___/\\\_____________
     _\/\\\\\\//\\\______\/\\\_______\/\\\______\/\\\______\/\\\\\\\\\\\______\/\\\_______\/\\\__\/\\\//\\\_\/\\\__\/\\\____/\\\\\\\_
      _\/\\\//_\//\\\_____\/\\\\\\\\\\\\\\\______\/\\\______\/\\\///////_______\/\\\\\\\\\\\\\\\__\/\\\\//\\\\/\\\__\/\\\___\/////\\\_
       _\/\\\____\//\\\____\/\\\/////////\\\______\/\\\______\/\\\______________\/\\\/////////\\\__\/\\\_\//\\\/\\\__\/\\\_______\/\\\_
        _\/\\\_____\//\\\___\/\\\_______\/\\\______\/\\\______\/\\\______________\/\\\_______\/\\\__\/\\\__\//\\\\\\__\/\\\_______\/\\\_
         _\/\\\______\//\\\__\/\\\_______\/\\\___/\\\\\\\\\\\__\/\\\______________\/\\\_______\/\\\__\/\\\___\//\\\\\__\//\\\\\\\\\\\\/__
          _\///________\///___\///________\///___\///////////___\///_______________\///________\///___\///_____\/////____\////////////_-->
