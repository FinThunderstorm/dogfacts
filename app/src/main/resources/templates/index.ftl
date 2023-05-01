<#-- @ftlvariable name="fact" type="java.lang.String" -->
<#import "_layout.ftl" as layout />
<@layout.header>
    <figure>
        <blockquote class="blockquote">
            <p>${fact}</p>
        </blockquote>
        <figcaption class="blockquote-footer">
            ${voting.votesCount} votes - <a href="/vote/${voting.id}">vote</a>
        </figcaption>
    </figure>
    <p>
        <a href="/" class="btn btn-primary ms-auto me-auto" role="button">Get next one</a>
    </p>
</@layout.header>