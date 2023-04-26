<#-- @ftlvariable name="fact" type="java.lang.String" -->
<#import "_layout.ftl" as layout />
<@layout.header>
    <blockquote class="blockquote">
        <p>${fact}</p>
    </blockquote>
    <p>
        <a href="/" class="btn btn-primary ms-auto me-auto" role="button">Get next one</a>
    </p>
</@layout.header>