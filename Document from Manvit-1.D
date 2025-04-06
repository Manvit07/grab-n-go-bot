package com.aystudio.watchlist.data.local

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) :
    SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    override fun onCreate(db: SQLiteDatabase) {
        val createTableQuery = """
            CREATE TABLE $TABLE_NAME (
                $COLUMN_ID INTEGER PRIMARY KEY,
                $COLUMN_ADULT INTEGER,
                $COLUMN_BACKDROP_PATH TEXT,
                $COLUMN_GENRE_IDS TEXT,
                $COLUMN_ORIGINAL_LANGUAGE TEXT,
                $COLUMN_ORIGINAL_TITLE TEXT,
                $COLUMN_OVERVIEW TEXT,
                $COLUMN_POPULARITY REAL,
                $COLUMN_POSTER_PATH TEXT,
                $COLUMN_RELEASE_DATE TEXT,
                $COLUMN_TITLE TEXT,
                $COLUMN_VIDEO INTEGER,
                $COLUMN_VOTE_AVERAGE REAL,
                $COLUMN_VOTE_COUNT INTEGER
            )
        """.trimIndent()
        db.execSQL(createTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    companion object {
        const val DATABASE_NAME = "movies_database"
        const val DATABASE_VERSION = 1
        const val TABLE_NAME = "movies_table"
        const val COLUMN_ID = "id"
        const val COLUMN_ADULT = "adult"
        const val COLUMN_BACKDROP_PATH = "backdrop_path"
        const val COLUMN_GENRE_IDS = "genre_ids"
        const val COLUMN_ORIGINAL_LANGUAGE = "original_language"
        const val COLUMN_ORIGINAL_TITLE = "original_title"
        const val COLUMN_OVERVIEW = "overview"
        const val COLUMN_POPULARITY = "popularity"
        const val COLUMN_POSTER_PATH = "poster_path"
        const val COLUMN_RELEASE_DATE = "release_date"
        const val COLUMN_TITLE = "title"
        const val COLUMN_VIDEO = "video"
        const val COLUMN_VOTE_AVERAGE = "vote_average"
        const val COLUMN_VOTE_COUNT = "vote_count"
    }
}
