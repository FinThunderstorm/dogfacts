package dev.alanen.dog.facts

import io.ktor.server.application.*
import dev.alanen.dog.facts.plugins.*

fun main(args: Array<String>): Unit = io.ktor.server.netty.EngineMain.main(args)

fun Application.module() {
    configureRouting()
    configureTemplating()
}