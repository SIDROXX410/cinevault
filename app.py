# ============================================
# CINEVAULT — app.py
# Backend server built with Python + Flask
# Provides REST API endpoints for movie data
# ============================================

# To run this server locally:
# 1. Install dependencies:  pip install flask flask-cors
# 2. Run:                   python app.py
# 3. Visit:                 http://localhost:5000

from flask import Flask, jsonify, request
from flask_cors import CORS
import sqlite3
import os

# ----- App Setup -----
app = Flask(__name__)
CORS(app)  # Allow frontend (GitHub Pages) to call this API

DATABASE = 'cinevault.db'


# ----- Database Helper -----
def get_db_connection():
    """Opens a connection to the SQLite database."""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row  # Return rows as dicts
    return conn


def init_db():
    """Creates tables and seeds data if database doesn't exist."""
    if not os.path.exists(DATABASE):
        conn = get_db_connection()
        with open('database.sql', 'r') as f:
            conn.executescript(f.read())
        conn.commit()
        conn.close()
        print("Database initialized from database.sql")


# ============================================
# API ROUTES
# ============================================

# ----- GET /api/movies -----
# Returns all movies (optionally filtered by genre)
# Example: GET /api/movies
# Example: GET /api/movies?genre=Drama
@app.route('/api/movies', methods=['GET'])
def get_movies():
    genre = request.args.get('genre')  # Optional query param

    conn = get_db_connection()

    if genre and genre != 'All':
        # Filter by genre if provided
        movies = conn.execute(
            'SELECT * FROM movies WHERE genre = ? ORDER BY rating DESC',
            (genre,)
        ).fetchall()
    else:
        # Return all movies sorted by rating
        movies = conn.execute(
            'SELECT * FROM movies ORDER BY rating DESC'
        ).fetchall()

    conn.close()

    # Convert rows to list of dicts for JSON response
    return jsonify([dict(movie) for movie in movies])


# ----- GET /api/movies/<id> -----
# Returns a single movie by its ID
# Example: GET /api/movies/1
@app.route('/api/movies/<int:movie_id>', methods=['GET'])
def get_movie(movie_id):
    conn = get_db_connection()
    movie = conn.execute(
        'SELECT * FROM movies WHERE id = ?',
        (movie_id,)
    ).fetchone()
    conn.close()

    if movie is None:
        return jsonify({'error': 'Movie not found'}), 404

    return jsonify(dict(movie))


# ----- GET /api/genres -----
# Returns list of all unique genres
# Example: GET /api/genres
@app.route('/api/genres', methods=['GET'])
def get_genres():
    conn = get_db_connection()
    genres = conn.execute(
        'SELECT DISTINCT genre FROM movies ORDER BY genre'
    ).fetchall()
    conn.close()

    genre_list = ['All'] + [row['genre'] for row in genres]
    return jsonify(genre_list)


# ----- GET /api/movies/search -----
# Search movies by title keyword
# Example: GET /api/movies/search?q=dark
@app.route('/api/movies/search', methods=['GET'])
def search_movies():
    query = request.args.get('q', '')

    conn = get_db_connection()
    movies = conn.execute(
        'SELECT * FROM movies WHERE title LIKE ? ORDER BY rating DESC',
        (f'%{query}%',)
    ).fetchall()
    conn.close()

    return jsonify([dict(movie) for movie in movies])


# ----- POST /api/movies -----
# Adds a new movie to the database
# Example body: { "title": "...", "year": 2020, ... }
@app.route('/api/movies', methods=['POST'])
def add_movie():
    data = request.get_json()

    # Basic validation
    required_fields = ['title', 'year', 'genre', 'rating', 'director', 'duration', 'synopsis']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing field: {field}'}), 400

    conn = get_db_connection()
    conn.execute(
        '''INSERT INTO movies (title, year, genre, rating, director, duration, synopsis, poster, emoji)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
        (
            data['title'],
            data['year'],
            data['genre'],
            data['rating'],
            data['director'],
            data['duration'],
            data['synopsis'],
            data.get('poster', ''),
            data.get('emoji', '🎬')
        )
    )
    conn.commit()
    conn.close()

    return jsonify({'message': 'Movie added successfully'}), 201


# ----- DELETE /api/movies/<id> -----
# Deletes a movie by ID
# Example: DELETE /api/movies/5
@app.route('/api/movies/<int:movie_id>', methods=['DELETE'])
def delete_movie(movie_id):
    conn = get_db_connection()
    result = conn.execute('DELETE FROM movies WHERE id = ?', (movie_id,))
    conn.commit()
    conn.close()

    if result.rowcount == 0:
        return jsonify({'error': 'Movie not found'}), 404

    return jsonify({'message': f'Movie {movie_id} deleted'})


# ----- GET /api/stats -----
# Returns summary statistics about the database
@app.route('/api/stats', methods=['GET'])
def get_stats():
    conn = get_db_connection()

    total = conn.execute('SELECT COUNT(*) as count FROM movies').fetchone()['count']
    avg_rating = conn.execute('SELECT ROUND(AVG(rating), 1) as avg FROM movies').fetchone()['avg']
    genre_count = conn.execute('SELECT COUNT(DISTINCT genre) as count FROM movies').fetchone()['count']

    conn.close()

    return jsonify({
        'total_movies': total,
        'average_rating': avg_rating,
        'total_genres': genre_count
    })


# ============================================
# ENTRY POINT
# ============================================
if __name__ == '__main__':
    init_db()   # Set up database on first run
    app.run(debug=True, port=5000)
