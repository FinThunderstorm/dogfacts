package dev.alanen.dog.facts.plugins

import org.litote.kmongo.*

data class Voting(val id: String, val votesCount: Int)

class VotingService(dbUrl: String) {
    private val client = KMongo.createClient(dbUrl)
    private val database = client.getDatabase("votings")
    private val votingCollection = database.getCollection<Voting>()

    fun getOrCreateIfNotExists(id: String): Voting {
        val existing: Voting? = votingCollection.findOne(Voting::id eq id)
        if (existing != null) {
            return existing
        }

        votingCollection.insertOne(Voting(id, 0))
        val obj: Voting = Voting(id, 0)
        return obj
    }

    fun addVote(id: String): Boolean {
        votingCollection.findOneAndUpdate(Voting::id eq id, inc(Voting::votesCount, 1))
        return true
    }
}