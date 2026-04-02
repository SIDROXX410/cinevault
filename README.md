# 🎬 CineVault — Curated Cinema Website

A full-stack movie showcase web application featuring curated film posters, synopses, genre filtering, and detailed movie views.

**Live Demo:** https://sidroxx410.github.io/cinevault

---

## Project Structure

```
cinevault/
│
├── index.html      ← Frontend: Main HTML page structure
├── style.css       ← Frontend: All visual styling
├── script.js       ← Frontend: Interactivity & movie data
│
├── app.py          ← Backend: Python Flask REST API server
├── database.sql    ← Database: SQL schema + all movie data
│
└── README.md       ← This file
```

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | HTML5 | Page structure and content |
| Frontend | CSS3 | Styling, animations, responsive layout |
| Frontend | JavaScript (Vanilla) | Interactivity, filtering, modal views |
| Backend | Python 3 + Flask | REST API server |
| Database | SQLite (SQL) | Stores movies, users, reviews, watchlist |

---

## Frontend (index.html + style.css + script.js)

### What it does:
- Displays 12 curated movies in a responsive grid layout
- Each movie card shows the poster, title, year, genre tag, and rating badge
- Hovering a card reveals a synopsis preview
- Clicking a card opens a full detail modal with synopsis, director, runtime, and star rating
- Genre filter buttons (All / Drama / Sci-Fi / Thriller / Crime / Adventure)
- Fully responsive — works on mobile and desktop

### Key CSS features:
- CSS Custom Properties (variables) for consistent theming
- CSS Grid for the movie card layout
- CSS Transitions for hover and modal animations
- Responsive breakpoints with `@media` queries

### Key JavaScript concepts:
- Array `.filter()` for genre filtering
- DOM manipulation with `innerHTML`
- Event listeners for clicks and keyboard (Escape key)
- Template literals for dynamic HTML generation

---

## Backend (app.py)

Built with **Python Flask** — a lightweight web framework.

### API Endpoints:

| Method | Route | Description |
|--------|-------|-------------|
| GET | `/api/movies` | Get all movies |
| GET | `/api/movies?genre=Drama` | Get movies by genre |
| GET | `/api/movies/<id>` | Get one movie by ID |
| GET | `/api/movies/search?q=dark` | Search movies by title |
| GET | `/api/genres` | Get all unique genres |
| GET | `/api/stats` | Get database statistics |
| POST | `/api/movies` | Add a new movie |
| DELETE | `/api/movies/<id>` | Delete a movie |

### How to run locally:
```bash
pip install flask flask-cors
python app.py
# Server runs at http://localhost:5000
```

---

## Database (database.sql)

Built with **SQLite** using standard SQL.

### Tables:

#### `movies` table
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key, auto-incremented |
| title | TEXT | Movie title |
| year | INTEGER | Release year |
| genre | TEXT | Genre category |
| rating | REAL | Rating out of 10 |
| director | TEXT | Director name |
| duration | TEXT | Runtime |
| synopsis | TEXT | Full movie synopsis |
| poster | TEXT | Poster image URL |
| emoji | TEXT | Fallback emoji icon |
| created_at | TEXT | Timestamp |

#### `users` table
Stores registered user accounts.

#### `watchlist` table
Junction table linking users to their saved movies (Many-to-Many relationship).

#### `reviews` table
Stores user-written reviews and scores for movies.

### Key SQL concepts used:
- `CREATE TABLE` with data types and constraints
- `PRIMARY KEY` and `AUTOINCREMENT`
- `FOREIGN KEY` relationships between tables
- `CHECK` constraints (rating must be 1–10)
- `UNIQUE` constraint on watchlist (no duplicate saves)
- `INDEX` for query performance
- `JOIN` queries for relational data
- `GROUP BY` and `AVG()` aggregate functions

---

## Architecture Diagram

```
┌─────────────────────┐
│   User's Browser    │
│  index.html         │
│  style.css          │  ←── GitHub Pages (live URL)
│  script.js          │
└────────┬────────────┘
         │ HTTP Requests (fetch API)
         ▼
┌─────────────────────┐
│   Flask Backend     │
│   app.py            │  ←── Python server (localhost:5000)
│   REST API          │
└────────┬────────────┘
         │ SQL Queries
         ▼
┌─────────────────────┐
│   SQLite Database   │
│   database.sql      │  ←── cinevault.db file
│   4 tables          │
└─────────────────────┘
```

---

## How the Full Stack Connects

1. **User** opens the website in their browser
2. **Frontend** (script.js) fetches movie data from the backend API
3. **Backend** (app.py) receives the request and queries the database
4. **Database** (database.sql) returns the matching movie records
5. **Backend** formats data as JSON and sends it back
6. **Frontend** renders the movie cards dynamically on screen

> Note: For this GitHub Pages deployment, the frontend uses hardcoded data in script.js since GitHub Pages cannot run a Python server. In a full deployment (e.g. on Render or Railway), the frontend would call the live Flask API instead.

---

## Author

**SIDROXX410** — College Assignment Project
