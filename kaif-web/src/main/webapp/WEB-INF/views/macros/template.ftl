<#import "/spring.ftl" as spring />

<#macro page config>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Kaif prototype">

    <title>kaif.io</title>

    <#-- meta data for dart, see ServerType for detail -->
    <#if kaif.profilesActive?contains('dev')>

        <#-- for detect dev mode only, should not leak information to produciton -->
        <meta name="kaifProfilesActive" content="${kaif.profilesActive}">

        <#-- server locale is only used in dev mode, because the page will be cached for everyone
        -->
        <meta name="kaifLocale" content="${(request.getLocale().toString())!"en_US"}">
    </#if>

    <link rel='stylesheet' href='/webjars/yui-pure/0.5.0/pure-min.css'>
    <link rel="stylesheet" href="/webjars/font-awesome/4.2.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="css/kaif.css?${kaif.deployServerTime}">
</head>
<body>
<header class="header">
    <div class="home-menu pure-menu pure-menu-open pure-menu-horizontal">
        <a class="pure-menu-heading" href="/">Kaif.io</a>
        <ul account-menu>
            <#-- mock
            <li><a href="/sign-up">Sign Up</a></li>
            <li><a href="/sign-in">Sign In</a></li>
            <li><a href="/settings">myname</a></li>
            <li><a href="/sign-out">Sign Out</a></li>
            -->
        </ul>
    </div>
</header>

<main class="content">
    <#nested>
</main>

<footer class="footer l-box is-center">
    Sample footer
</footer>

<#-- deprecated
<script src="js/jquery-2.1.3.min.js"></script>
<script src="js/kaif.js"></script>
-->

<#if kaif.profilesActive?contains('dev')>
    <#-- require dart pub serve, please run `./gradlew pubServe` -->
    <div id="waitingPubServe"
         style="position: fixed; bottom:0; right:0px; padding: 3px 10px; background-color: rgba(92, 0, 0, 0.67); color:white">
        Waiting Pub Serve...
    </div>
    <script src="//localhost:15980/main.dart.js"></script>
<#else>
    <script src="dart_dist/web/main.dart.js?${kaif.deployServerTime}"></script>
</#if>
</body>
</html>

</#macro>

