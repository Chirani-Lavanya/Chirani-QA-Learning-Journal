
-- BookSwap practice database: 200 synthetic rows
-- 20 members, 120 books, 30 requests, 30 loans.
-- All names, emails and phone numbers are fake.

INSERT INTO members (display_name, email, phone, address, building_id, joined_on)
SELECT 'Member M' || lpad(g::text, 2, '0'),
       'm' || lpad(g::text, 2, '0') || '@bookswap.test',
       CASE WHEN g = 17 THEN '' WHEN g = 19 THEN NULL
            ELSE '+94 77 000 ' || lpad(g::text, 4, '0') END,
       'Flat ' || g || ', Test Residencies, Colombo 05',
       CASE WHEN g <= 12 THEN 12 ELSE 14 END,
       CURRENT_DATE - (200 - g * 5)
FROM generate_series(1, 20) AS g;

INSERT INTO books (owner_id, building_id, title, author, isbn, condition, status, created_at)
SELECT o.owner_id,
       CASE WHEN o.owner_id <= 12 THEN 12 ELSE 14 END,
       (ARRAY['Madol Doova','Gamperaliya','Viragaya','Kaliyugaya','Yuganthaya','Golu Hadawatha',
              'Amba Yaluwo','Hath Pana','Reef','Funny Boy','Anil''s Ghost','The Seven Moons of Maali Almeida'])[1 + g % 12],
       (ARRAY['Martin Wickramasinghe','Martin Wickramasinghe','Martin Wickramasinghe','Martin Wickramasinghe',
              'Martin Wickramasinghe','Karunasena Jayalath','T. B. Ilangaratne','Kumaratunga Munidasa',
              'Romesh Gunesekera','Shyam Selvadurai','Michael Ondaatje','Shehan Karunatilaka'])[1 + g % 12],
       CASE WHEN g = 57 THEN '955123456' ELSE '97895521' || lpad(g::text, 5, '0') END,
       (ARRAY['new','good','good','fair','poor'])[1 + g % 5],
       CASE WHEN g % 10 = 0 THEN 'unavailable' WHEN g % 4 = 0 THEN 'on_loan' ELSE 'available' END,
       CURRENT_TIMESTAMP - make_interval(days => 120 - g)
FROM generate_series(1, 120) AS g
CROSS JOIN LATERAL (SELECT 1 + (g % 20) AS owner_id) AS o;

INSERT INTO borrow_requests (book_id, borrower_id, status, created_at)
SELECT g * 4 - 1,
       1 + ((g * 7) % 20),
       (ARRAY['pending','accepted','declined'])[1 + g % 3],
       CURRENT_TIMESTAMP - make_interval(days => 30 - g)
FROM generate_series(1, 27) AS g;

-- Rows that should not exist: a member asking for their own book
-- and a duplicate open request.
INSERT INTO borrow_requests (book_id, borrower_id, status, created_at) VALUES
  (5,  6, 'pending', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  (11, 9, 'pending', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  (11, 9, 'pending', CURRENT_TIMESTAMP - INTERVAL '1 day');

INSERT INTO loans (book_id, borrower_id, status, borrowed_at, returned_at)
SELECT g * 4,
       1 + ((g * 3) % 20),
       CASE WHEN g <= 12 THEN 'returned' ELSE 'out' END,
       CURRENT_DATE - (60 - g * 2),
       CASE WHEN g <= 12 THEN CURRENT_DATE - (60 - g * 2) + 14 END
FROM generate_series(1, 28) AS g;

-- Rows that should not exist: returned before borrowed, and
-- returned with no return date.
INSERT INTO loans (book_id, borrower_id, status, borrowed_at, returned_at) VALUES
  (116, 3, 'returned', CURRENT_DATE - 10, CURRENT_DATE - 15),
  (120, 4, 'returned', CURRENT_DATE - 8, NULL);
