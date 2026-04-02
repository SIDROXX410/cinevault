// ============================================
// CINEVAULT — script.js
// All interactivity: rendering, filtering, modal
// ============================================

// ----- Movie Data (normally fetched from backend/database) -----
// In a real full-stack app, this would come from an API call like:
// fetch('/api/movies').then(res => res.json()).then(data => renderMovies(data))
// This data mirrors what is stored in database.sql

const movies = [
  {
    id: 1,
    title: "The Shawshank Redemption",
    year: 1994,
    genre: "Drama",
    rating: "9.3",
    director: "Frank Darabont",
    duration: "142 min",
    emoji: "🏛️",
    poster: "https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_SX300.jpg",
    synopsis: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency. Andy Dufresne, a banker wrongly convicted of his wife's murder, endures the brutal realities of Shawshank prison while maintaining hope and helping his fellow inmates along the way."
  },
  {
    id: 2,
    title: "The Godfather",
    year: 1972,
    genre: "Crime",
    rating: "9.2",
    director: "Francis Ford Coppola",
    duration: "175 min",
    emoji: "🌹",
    poster: "https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
    synopsis: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son. A saga of family, power, and loyalty that redefined American cinema and became one of the greatest films ever made."
  },
  {
    id: 3,
    title: "Inception",
    year: 2010,
    genre: "Sci-Fi",
    rating: "8.8",
    director: "Christopher Nolan",
    duration: "148 min",
    emoji: "🌀",
    poster: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg",
    synopsis: "A thief who enters the dreams of others to steal secrets from their subconscious is given the inverse task of planting an idea into the mind of a CEO. A visually stunning and intellectually challenging journey through layered realities and the architecture of the mind."
  },
  {
    id: 4,
    title: "Interstellar",
    year: 2014,
    genre: "Sci-Fi",
    rating: "8.7",
    director: "Christopher Nolan",
    duration: "169 min",
    emoji: "🪐",
    poster: "https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg",
    synopsis: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival. An epic odyssey that blends theoretical physics with deeply human emotion, exploring time, gravity, and the unbreakable bond between a father and daughter."
  },
  {
    id: 5,
    title: "Parasite",
    year: 2019,
    genre: "Thriller",
    rating: "8.5",
    director: "Bong Joon-ho",
    duration: "132 min",
    emoji: "🪜",
    poster: "https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SX300.jpg",
    synopsis: "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan. A razor-sharp critique of economic inequality wrapped in darkly comic suspense."
  },
  {
    id: 6,
    title: "Schindler's List",
    year: 1993,
    genre: "Drama",
    rating: "9.0",
    director: "Steven Spielberg",
    duration: "195 min",
    emoji: "🕯️",
    poster: "https://m.media-amazon.com/images/M/MV5BNDE4OTEyMDItNjBlOS00NjgzLWFlZGMtMmIyY2M0ZjA4YWMwXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg",
    synopsis: "In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis. A devastating and profoundly moving portrayal of courage, humanity, and the Holocaust."
  },
  {
    id: 7,
    title: "The Dark Knight",
    year: 2008,
    genre: "Thriller",
    rating: "9.0",
    director: "Christopher Nolan",
    duration: "152 min",
    emoji: "🦇",
    poster: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg",
    synopsis: "When the menace known as the Joker wreaks havoc and chaos on Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice. Heath Ledger's iconic performance elevates this into a profound examination of order vs. chaos."
  },
  {
    id: 8,
    title: "Pulp Fiction",
    year: 1994,
    genre: "Crime",
    rating: "8.9",
    director: "Quentin Tarantino",
    duration: "154 min",
    emoji: "💼",
    poster: "https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
    synopsis: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption. Tarantino's non-linear narrative masterpiece redefined independent cinema with sharp dialogue and audacious style."
  },
  {
    id: 9,
    title: "2001: A Space Odyssey",
    year: 1968,
    genre: "Sci-Fi",
    rating: "8.3",
    director: "Stanley Kubrick",
    duration: "149 min",
    emoji: "🔲",
    poster: "https://m.media-amazon.com/images/M/MV5BMmNlYzRiNDctZWNhMi00MzI4LThkZTctZTUzZTQzM2IxOMjBlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
    synopsis: "After discovering a mysterious artifact buried beneath the Lunar surface, a spacecraft is sent to Jupiter to find its origins, and an astronaut must battle HAL 9000, the ship's intelligent computer. Kubrick's visionary opus remains cinema's most profound meditation on evolution and consciousness."
  },
  {
    id: 10,
    title: "Spirited Away",
    year: 2001,
    genre: "Adventure",
    rating: "8.6",
    director: "Hayao Miyazaki",
    duration: "125 min",
    emoji: "🐉",
    poster: "https://m.media-amazon.com/images/M/MV5BMjlmZmI5MDctNDE2YS00YWE0LWE5ZWItZDBhYWQ0NTcxNWRhXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg",
    synopsis: "During her family's move to the suburbs, a sullen ten-year-old girl wanders into a world ruled by gods, witches, and spirits. Studio Ghibli's enchanting masterpiece is an immersive journey through a breathtaking spirit world of boundless imagination."
  },
  {
    id: 11,
    title: "No Country for Old Men",
    year: 2007,
    genre: "Thriller",
    rating: "8.2",
    director: "Coen Brothers",
    duration: "122 min",
    emoji: "🔩",
    poster: "https://m.media-amazon.com/images/M/MV5BMjA5Njk3MjM4OV5BMl5BanBnXkFtZTcwMTc5MTE1MQ@@._V1_SX300.jpg",
    synopsis: "Violence and mayhem ensue after a hunter stumbles upon a drug deal gone wrong and more than two million dollars in cash near the Rio Grande. The Coens' existential thriller pits an unstoppable force of evil against aging lawmen."
  },
  {
    id: 12,
    title: "Lawrence of Arabia",
    year: 1962,
    genre: "Adventure",
    rating: "8.3",
    director: "David Lean",
    duration: "228 min",
    emoji: "🏜️",
    poster: "https://m.media-amazon.com/images/M/MV5BYWY5ZGM0YTAtNjVlNS00ZDJkLWJjNTMtZGYwODc2MDQwMGFjXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_SX300.jpg",
    synopsis: "The story of T.E. Lawrence, the English officer who successfully united and led the Arab tribes during World War I. David Lean's colossal epic remains the definitive portrait of one man's myth-making against a backdrop of sweeping desert grandeur."
  }
];

// ----- State -----
let activeFilter = 'All'; // tracks which genre filter is selected

// ----- Filter Function -----
// Called when user clicks a genre button
function filterMovies(genre, btn) {
  activeFilter = genre;

  // Remove 'active' class from all filter buttons, add to clicked one
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');

  renderMovies(); // re-render grid with filtered data
}

// ----- Render Movies Grid -----
// Builds and injects movie cards into the DOM
function renderMovies() {
  const grid = document.getElementById('moviesGrid');

  // Filter movies based on active genre
  const filtered = activeFilter === 'All'
    ? movies
    : movies.filter(m => m.genre === activeFilter);

  // Build HTML for each movie card
  grid.innerHTML = filtered.map(m => `
    <div class="movie-card" onclick="openModal(${m.id})">
      <div class="poster-wrap">
        <img
          src="${m.poster}"
          alt="${m.title}"
          onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
        />
        <div class="poster-placeholder" style="display:none;">${m.emoji}</div>
        <div class="card-overlay">
          <p class="synopsis-preview">${m.synopsis.slice(0, 100)}…</p>
        </div>
        <span class="rating-badge">${m.rating}</span>
        <span class="genre-tag">${m.genre}</span>
      </div>
      <div class="card-body">
        <p class="movie-title">${m.title}</p>
        <div class="movie-meta">
          <span>${m.year}</span>
          <span class="meta-dot"></span>
          <span>${m.duration}</span>
        </div>
      </div>
    </div>
  `).join('');
}

// ----- Open Modal -----
// Displays full movie detail when a card is clicked
function openModal(id) {
  // Find movie by ID
  const m = movies.find(movie => movie.id === id);
  if (!m) return;

  // Generate star rating (out of 5 stars, scaled from 10)
  const starCount = Math.round(parseFloat(m.rating) / 2);
  const stars = '★'.repeat(starCount) + '☆'.repeat(5 - starCount);

  // Inject poster image
  document.getElementById('modalPoster').innerHTML = `
    <img
      src="${m.poster}"
      alt="${m.title}"
      class="modal-poster"
      onerror="this.outerHTML='<div class=\\'modal-placeholder\\'>${m.emoji}</div>'"
    />
  `;

  // Inject movie details
  document.getElementById('modalContent').innerHTML = `
    <div>
      <p class="modal-genre">${m.genre}</p>
      <h2 class="modal-title">${m.title}</h2>
    </div>
    <div class="modal-details">
      <strong>${m.year}</strong>
      <span class="meta-dot" style="display:inline-block;width:3px;height:3px;border-radius:50%;background:#9a9589;"></span>
      <strong>${m.duration}</strong>
      <span class="meta-dot" style="display:inline-block;width:3px;height:3px;border-radius:50%;background:#9a9589;"></span>
      <span>Dir. <strong>${m.director}</strong></span>
    </div>
    <div class="modal-rating">
      <span class="stars">${stars}</span>
      <span class="rating-text">${m.rating}</span>
      <span class="rating-label">/ 10</span>
    </div>
    <p class="modal-synopsis">${m.synopsis}</p>
  `;

  // Show the modal
  document.getElementById('modalBackdrop').classList.add('open');
}

// ----- Close Modal -----
// Closes modal when clicking the backdrop (outside the modal box)
function closeModal(event) {
  if (event.target === document.getElementById('modalBackdrop')) {
    closeModalDirect();
  }
}

// Closes modal directly (used by the ✕ button)
function closeModalDirect() {
  document.getElementById('modalBackdrop').classList.remove('open');
}

// ----- Close modal with Escape key -----
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closeModalDirect();
});

// ----- Initial Render -----
// Run on page load
renderMovies();
