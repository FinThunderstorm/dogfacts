package dev.alanen.dog.facts.plugins

import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.http.content.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*

fun Application.configureRouting() {
    routing {
        static("/static") {
            resources("files")
        }
        get("/") {
            val fact = "toot"
            call.respond(FreeMarkerContent("index.ftl", mapOf("fact" to fact)))
        }
    }
}