package com.aystudio.watchlist.data.local

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.os.Build
import androidx.annotation.RequiresApi
import com.aystudio.watchlist.presentation.models.DatabaseModelClass
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class MovieDao(context: Context) {

    private val dbHelper = DatabaseHelper(context)

    @RequiresApi(Build.VERSION_CODES.FROYO)
    fun addMovie(movie: DatabaseModelClass) {
        val db = dbHelper.writableDatabase
        val values = ContentValues().apply {
            put(DatabaseHelper.COLUMN_ID, movie.id)
            put(DatabaseHelper.COLUMN_ADULT, if (movie.adult == true) 1 else 0)
            put(DatabaseHelper.COLUMN_BACKDROP_PATH, movie.backdrop_path)
            put(DatabaseHelper.COLUMN_GENRE_IDS, movie.genre_ids.joinToString(","))
            put(DatabaseHelper.COLUMN_ORIGINAL_LANGUAGE, movie.original_language)
            put(DatabaseHelper.COLUMN_ORIGINAL_TITLE, movie.original_title)
            put(DatabaseHelper.COLUMN_OVERVIEW, movie.overview)
            put(DatabaseHelper.COLUMN_POPULARITY, movie.popularity)
            put(DatabaseHelper.COLUMN_POSTER_PATH, movie.poster_path)
            put(DatabaseHelper.COLUMN_RELEASE_DATE, movie.release_date)
            put(DatabaseHelper.COLUMN_TITLE, movie.title)
            put(DatabaseHelper.COLUMN_VIDEO, if (movie.video == true) 1 else 0)
            put(DatabaseHelper.COLUMN_VOTE_AVERAGE, movie.vote_average)
            put(DatabaseHelper.COLUMN_VOTE_COUNT, movie.vote_count)
        }
        db.insertWithOnConflict(
            DatabaseHelper.TABLE_NAME,
            null,
            values,
            SQLiteDatabase.CONFLICT_REPLACE
        )
        db.close()
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN)
    fun getMoviesRoomList(): Flow<List<DatabaseModelClass>> = flow {
        val db = dbHelper.readableDatabase
        val cursor: Cursor? = db.rawQuery("SELECT * FROM ${DatabaseHelper.TABLE_NAME}", null)
        val moviesList = mutableListOf<DatabaseModelClass>()
        cursor?.use {
            while (it.moveToNext()) {
                moviesList.add(
                    DatabaseModelClass(
                        id = it.getInt(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_ID)),
                        adult = it.getInt(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_ADULT)) == 1,
                        backdrop_path = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_BACKDROP_PATH)),
                        genre_ids = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_GENRE_IDS))
                            .split(",")
                            .map { id -> id.toInt() },
                        original_language = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_ORIGINAL_LANGUAGE)),
                        original_title = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_ORIGINAL_TITLE)),
                        overview = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_OVERVIEW)),
                        popularity = it.getDouble(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_POPULARITY)),
                        poster_path = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_POSTER_PATH)),
                        release_date = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_RELEASE_DATE)),
                        title = it.getString(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_TITLE)),
                        video = it.getInt(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_VIDEO)) == 1,
                        vote_average = it.getDouble(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_VOTE_AVERAGE)),
                        vote_count = it.getInt(it.getColumnIndexOrThrow(DatabaseHelper.COLUMN_VOTE_COUNT))
                    )
                )
            }
        }
        emit(moviesList)
    }


    fun deleteMovie(movie: DatabaseModelClass) {
        val db = dbHelper.writableDatabase
        db.delete(
            DatabaseHelper.TABLE_NAME,
            "${DatabaseHelper.COLUMN_ID} = ?",
            arrayOf(movie.id.toString())
        )
        db.close()
    }

    fun isMovieExists(id: Int): Boolean {
        val db = dbHelper.readableDatabase
        val query =
            "SELECT 1 FROM ${DatabaseHelper.TABLE_NAME} WHERE ${DatabaseHelper.COLUMN_ID} = ?"
        val cursor = db.rawQuery(query, arrayOf(id.toString()))
        val exists = cursor.count > 0
        cursor.close()
        return exists
    }
}
