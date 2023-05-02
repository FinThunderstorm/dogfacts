package dev.alanen.dog.facts.plugins

import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.http.content.*
import io.ktor.http.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.util.*

import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import kotlinx.serialization.*
import kotlinx.serialization.json.*

import dev.alanen.dog.facts.plugins.*

fun Application.configureRouting() {
    val connectionString: String = System.getenv("CUSTOMCONNSTR_DB") ?: "mongodb://dog:facts@localhost:27017"
    println("Connecting to DB with connection string: $connectionString")
    val vs = VotingService(connectionString)
    routing {
        get("/ping") {
            call.respond("pong")
        }
        get("/") {
            val client = HttpClient.newBuilder().build()
            val request = HttpRequest.newBuilder()
                .uri(URI.create("https://dogapi.dog/api/v2/facts"))
                .build()

            val response = client.send(request, HttpResponse.BodyHandlers.ofString())

            val id = Json.parseToJsonElement(response.body()).jsonObject["data"]!!.jsonArray.get(0).jsonObject["id"].toString().replace("\"", "")

            val voting = vs.getOrCreateIfNotExists(id)

            val fact = Json.parseToJsonElement(response.body()).jsonObject["data"]!!.jsonArray.get(0).jsonObject["attributes"]!!.jsonObject["body"]
            call.respond(FreeMarkerContent("index.ftl", mapOf("fact" to fact, "voting" to voting)))
        }
        get("/vote/{id}") {
            val id = call.parameters["id"] ?: return@get call.respond(HttpStatusCode.BadRequest)
            vs.addVote(id)
            call.respondRedirect("/")
        }
    }
}