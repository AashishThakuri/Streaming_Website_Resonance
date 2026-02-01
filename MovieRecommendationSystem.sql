CREATE DATABASE movie_recommendation_system;
USE movie_recommendation_system;



-- Stores movie details
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(100),
    release_year INT,
    rating decimal (2,1),
    language VARCHAR(40),
    poster_url VARCHAR(255)
);
alter Table movies add column rating decimal(2,1);

-- Stores user ratings for movies
CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_id, movie_id),

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,

    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
        ON DELETE CASCADE
);

-- Stores admin information
CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for faster queries
CREATE INDEX idx_ratings_user ON ratings(user_id);
CREATE INDEX idx_ratings_movie ON ratings(movie_id);
CREATE INDEX idx_movies_genre ON movies(genre);

DELIMITER $$

-- Allows a user to rate a movie (insert or update)
CREATE PROCEDURE rate_movie(
    IN p_user_id INT,
    IN p_movie_id INT,
    IN p_rating INT
)
BEGIN
    INSERT INTO ratings (user_id, movie_id, rating)
    VALUES (p_user_id, p_movie_id, p_rating)
    ON DUPLICATE KEY UPDATE
        rating = p_rating,
        rated_at = CURRENT_TIMESTAMP;
END$$

-- Allows admin to add a new movie
CREATE PROCEDURE add_movie(
    IN p_title VARCHAR(150),
    IN p_genre VARCHAR(100),
    IN p_release_year INT,
    IN p_language VARCHAR(40),
    IN p_poster_url VARCHAR(255)
)
BEGIN
    INSERT INTO movies (title, genre, release_year, language, poster_url)
    VALUES (p_title, p_genre, p_release_year, p_language, p_poster_url);
END$$

DELIMITER ;

-- Usage examples
-- CALL rate_movie(1, 3, 5);
-- CALL recommend_movies(1, 5);

USE movie_recommendation_system;
-- ALTER TABLE movies ADD COLUMN trailer_url VARCHAR(255);
-- ALTER TABLE movies ADD COLUMN description TEXT;
-- ALTER TABLE movies MODIFY COLUMN rating VARCHAR(10);
INSERT INTO movies (title, rating, genre, description, poster_url, trailer_url, release_year, language) VALUES 
(
    'Dead Poets Society',
    '8.1',
    'Drama',
    "At the elite Welton Academy in 1959, English teacher John Keating inspires his students to look at poetry and life in a different way. Through unconventional methods and a rallying cry of 'carpe diem,' he encourages them to think for themselves and seize the day, leading some to revive a secret club called the Dead Poets Society. As the boys discover passion and personal expression, they face the rigid expectations of their families and society, resulting in both transformation and tragedy.",
    'covers1/Dead Poets Society.webp',
    'movie trailers/Captain_my_captain_-_Dead_Poets_Society_1080p.mp4',
    1989,
    'English'
),
(
    'F1',
    'TBA',
    'Action/Sport',
    "Sonny Hayes, a former F1 racing phenom whose career was derailed by a severe accident in the 1990s, makes a dramatic return to the sport after a 30 year absence. Recruited by his old friend Ruben Cervantes to save a struggling underdog team called APXGP from collapse, Hayes must not only return to competitive racing but also mentor a young, cocky rookie driver named Joshua Pierce. Filmed during actual Grand Prix weekends, this adrenaline-fueled thriller captures the speed, danger, and passion of Formula 1.",
    'covers1/F1.jpg',
    'movie trailers/F1_Official_Trailer_2160p.mp4',
    2025,
    'English'
),
(
    'Inception',
    '8.8',
    'Sci-Fi',
    "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction stealing valuable secrets from deep within the subconscious during the dream state. His rare ability has made him a coveted player in corporate espionage but has cost him everything he loves. Now Cobb is offered a chance at redemption through one last job: inception the implantation of another person's idea into a target's subconscious. But this task is far more dangerous than any extraction, and Cobb must assemble a team of specialists to navigate multiple layers of dreams.",
    'covers1/Inception.jpg',
    'movie trailers/Inception_2010_Official_Trailer_1_-_Christopher_Nolan_Movie_HD_720P.mp4',
    2010,
    'English'
),
(
    'Inglourious Basterds',
    '8.4',
    'War/Action',
    "In Nazi-occupied France, young Jewish refugee Shosanna Dreyfus witnesses the execution of her family by the malevolent Colonel Hans Landa, the 'Jew Hunter.' Escaping to Paris, she assumes a new identity as a cinema owner. Years later, she sees an opportunity for revenge when Nazi leaders plan to attend a film premiere at her theater. Simultaneously, Lieutenant Aldo Raine leads a group of Jewish-American soldiers known as 'The Basterds' on a mission to terrorize Nazi soldiers behind enemy lines. Their paths converge in a daring plot to end the war.",
    'covers1/Inglorious Bastards.jpg',
    'movie trailers/Inglourious_Basterds_Official_Trailer_1_-_Brad_Pitt_Movie_2009_HD_720p.mp4',
    2009,
    'English'
),
(
    'Interstellar',
    '8.7',
    'Sci-Fi/Adventure',
    "In Earth's future, a global crop blight and second Dust Bowl are slowly rendering the planet uninhabitable. Former pilot Cooper, now a farmer, discovers a secret NASA operation and is recruited to pilot the Endurance spacecraft through a wormhole near Saturn to find a new home for humanity. Accompanied by a team including Dr. Amelia Brand, Cooper faces extreme time dilation, impossible choices, and the vast unknown—all while hoping to return to his children before it's too late.",
    'covers1/Interstellar.jpg',
    'movie trailers/Interstellar_Movie_-_Official_Trailer_1080P.mp4',
    2014,
    'English'
),
(
    'Ne Zha 2',
    '8.0',
    'Animation',
    "Following the events of the first film, Ne Zha and Ao Bing's souls have been preserved in the Seven-Colored Sacred Lotus after their bodies were destroyed. When conflict erupts between the Dragon King and Ne Zha's hometown, Ao Bing loses his newly formed body. To save his friend, Ne Zha with Ao Bing's spirit inhabiting his body—must complete three dangerous trials to obtain a potion that can restore Ao Bing. A visually stunning epic exploring destiny, rebellion, and the bonds of friendship.",
    'covers1/Ne Zha 2.webp',
    'movie trailers/Ne_Zha_2_Official_Trailer_HD_A24_1080P.mp4',
    2024,
    'Chinese'
),
(
    'Parasite',
    '8.5',
    'Thriller',
    "The Kims father Ki-taek, mother Chung-sook, daughter Ki-jung, and son Ki-woo live in a cramped basement apartment, struggling to make ends meet. When Ki-woo lands a tutoring job with the wealthy Park family, the Kims hatch an elaborate scheme to infiltrate and replace the Parks' domestic staff, hiding their family connection. As the two families become intertwined, a shocking discovery in the Parks' basement ignites a violent confrontation that exposes the brutal realities of class discrimination.",
    'covers1/Parasite.jpg',
    'movie trailers/Parasite_-_Official_Trailer_2019_Bong_Joon_Ho_Film_1080p.mp4',
    2019,
    'Korean'
),
(
    'Shutter Island',
    '8.2',
    'Mystery',
    "In 1954, U.S. Marshal Teddy Daniels and his new partner Chuck Aule are sent to Ashecliffe Hospital for the criminally insane on isolated Shutter Island to investigate the mysterious disappearance of a patient from a locked room. As a hurricane cuts off the island, Teddy uncovers disturbing secrets and suspects the doctors are engaged in sinister experiments. The deeper he investigates, the more he questions his partner, his memories, and his own sanity in this neo-noir psychological thriller.",
    'covers1/Shutter Island.jpg',
    'movie trailers/Shutter_Island_2010_Trailer_1_Movieclips_Classic_Trailers_1080P.mp4',
    2010,
    'English'
),
(
    'The Prestige',
    '8.5',
    'Mystery/Sci-Fi',
    "In late 19th-century London, rival magicians Robert Angier and Alfred Borden engage in a bitter feud after a tragic accident claims Angier's wife. Their rivalry escalates into a dangerous game of one-upmanship as each tries to create the ultimate illusion. Borden's 'Transported Man' trick obsesses Angier, driving him to seek out inventor Nikola Tesla. The film unravels dark secrets, hidden identities, and the terrible sacrifices both men make in their quest for the perfect trick.",
    'covers1/The Prestige.jpg',
    'movie trailers/The_Prestige_2006_Trailer_1_Movieclips_Classic_Trailers_1080P.mp4',
    2006,
    'English'
),
(
    'Troy',
    '7.3',
    'History/War',
    "In 1193 B.C., Prince Paris of Troy seduces Helen, Queen of Sparta, and smuggles her back to his homeland, igniting a war between the two nations. Helen's husband, King Menelaus, recruits his powerful brother Agamemnon to lead a massive Greek armada to besiege the fortified city of Troy. Among them is the invincible warrior Achilles, who fights for glory but finds his destiny intertwined with the fate of the city. The epic conflict unfolds with legendary duels, political intrigue, and the tragic fall of a kingdom.",
    'covers1/Troy.jpg',
    'movie trailers/Troy_2004_Official_Trailer_-_Brad_Pitt_Eric_Bana_Orlando_Bloom_Movie_HD_720P.mp4',
    2004,
    'English'
),
(
    'Unko Sweater',
    '7.5',
    'Drama',
    "In the picturesque hills of Nepal, Dharanidhar Kafle returns to his village carrying the weight of unfulfilled promises and memories of a love left behind. When he discovers that Phool Gurung still waits, wearing the woolen sweater he gave her years ago, he must confront the choices he made. A poignant Nepali drama about love, regret, separation, and the hope of second chances that transcends time and distance.",
    'covers1/Unko Sweater.jpg',
    'movie trailers/_The_Woolen_Sweater_Official_Movie_Trailer_In_Cinemas_Baisakh_26_May_09_1080P.mp4',
    2024,
    'Nepali'
);

drop table admins;

USE movie_recommendation_system;

-- Create Admins Table
CREATE TABLE IF NOT EXISTS admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- In real app, this should be hashed!
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT IGNORE INTO admins (username, password) VALUES ('admin', 'password');

USE movie_recommendation_system;

-- Drop procedure if it exists to allow updates
DROP PROCEDURE IF EXISTS recommend_movies_by_genre;

DELIMITER //

CREATE PROCEDURE recommend_movies_by_genre(
    IN p_movie_id INT,
    IN p_genre VARCHAR(100),
    IN p_limit INT
)
BEGIN
    -- Extract the first genre if it's a list (e.g., "Action/Sci-Fi" -> "Action")
    -- This is a simple approximation. For strict matching, use the full string.
    -- For this logic, we'll match any movie that contains the genre string.
    
    SELECT 
        movie_id,
        title,
        genre,
        rating,
        poster_url,
        description
    FROM movies
    WHERE 
        movie_id != p_movie_id  -- Exclude the current movie
        AND genre LIKE CONCAT('%', p_genre, '%') -- Match similar genre
    ORDER BY 
        rating DESC, -- Prioritize higher rated movies
        RAND()       -- Then randomize slightly
    LIMIT p_limit;
END //

DELIMITER ;

-- Example Usage:
-- CALL recommend_movies_by_genre(1, 'Action', 5);

select * from movies;
