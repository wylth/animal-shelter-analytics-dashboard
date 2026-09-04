const express = require('express');
const mustacheExpress = require('mustache-express');
const db = require('./db');

const app = express();
const PORT = 3000;

app.engine('html', mustacheExpress());
app.set('view engine', 'html');
app.set('views', __dirname + '/views');

app.use(express.static('public'));

// Home
app.get('/', (req, res) => {
  res.render('index');
});

// Outcome stats
app.get('/outcome-stats', async (req, res) => {
  const [rows] = await db.query(`
    SELECT
        oc.outcome_type,
        COALESCE(oc.outcome_subtype, 'None') AS outcome_subtype,
        COUNT(*) AS total
    FROM Outcome o
    JOIN OutcomeClassification oc
      ON o.classification_id = oc.classification_id
    GROUP BY
        oc.outcome_type,
        oc.outcome_subtype
    ORDER BY
        oc.outcome_type,
        total DESC;
  `);
  res.render('outcome-stats.html', { rows });
});

// Top adopted breeds
app.get('/top-breeds', async (req, res) => {
  const [rows] = await db.query(`
    SELECT
        b.breed,
        COUNT(*) AS total
    FROM Animal a
    JOIN Breed b
        ON a.breed_id = b.breed_id
    JOIN Outcome o
        ON a.animal_id = o.animal_id
    JOIN OutcomeClassification oc
        ON o.classification_id = oc.classification_id
    WHERE oc.outcome_type='Adoption'
    GROUP BY b.breed
    ORDER BY total DESC
    LIMIT 10;
  `);
  res.render('top-breeds.html', { rows });
});

// Euthanasia count by sex
app.get('/euthanasia', async (req, res) => {
  const [rows] = await db.query(`
    SELECT
        o.sex_upon_outcome AS sex,
        COUNT(*) AS total
    FROM Outcome o
    JOIN OutcomeClassification oc
    ON o.classification_id=oc.classification_id
    WHERE oc.outcome_type='Euthanasia'
    GROUP BY o.sex_upon_outcome;
  `);
  res.render('euthanasia.html', { rows });
});

// Outcomes over time
app.get('/outcomes-time', async (req, res) => {
  const [rows] = await db.query(`
    SELECT
    DATE_FORMAT(datetime,'%Y-%m') AS month,
    COUNT(*) AS total
    FROM Outcome
    GROUP BY month
    ORDER BY month;
  `);
  res.render('outcomes-time.html', { rows });
});

// Test database connection
app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT COUNT(*) as count FROM Outcome');
    res.json({ success: true, count: rows[0].count });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
