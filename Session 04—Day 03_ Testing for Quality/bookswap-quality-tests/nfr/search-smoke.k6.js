import http from 'k6/http';
import { check, sleep } from 'k6';

// Day 03 search smoke test. Default target is the Session 3 Prism mock.
// A Prism run proves the method/API shape only, not real application performance.
const BASE_URL = (__ENV.BASE_URL || 'http://host.docker.internal:4010').replace(/\/$/, '');
const SEARCH_PATH = __ENV.SEARCH_PATH || '/books';
const TOKEN = __ENV.TOKEN || 'test-token';
const SEARCH_TERM = __ENV.SEARCH_TERM || 'maths';

export const options = {
  vus: 20,
  duration: '60s',
  summaryTrendStats: ['avg', 'med', 'p(95)', 'p(99)', 'max'],
  thresholds: {
    http_req_duration: ['p(99)<800'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const separator = SEARCH_PATH.includes('?') ? '&' : '?';
  const url = `${BASE_URL}${SEARCH_PATH}${separator}search=${encodeURIComponent(SEARCH_TERM)}&page=1&pageSize=20`;
  const response = http.get(url, {
    headers: { Authorization: `Bearer ${TOKEN}`, Accept: 'application/json' },
    tags: { name: 'GET /books search' },
  });

  let hasItems = false;
  try {
    hasItems = Array.isArray(response.json('items'));
  } catch (_) {
    hasItems = false;
  }
  check(response, {
    'search returns HTTP 200': (r) => r.status === 200,
    'response contains items array': () => hasItems,
  });
  sleep(1);
}
