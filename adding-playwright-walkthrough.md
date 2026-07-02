What do I need?

* Playwright stuff installed globally
* Skills -> to learn my agent how the details work
* Files -> Little text files that I can check in so that I can reproduce it the next time (or a collega or pipeline etc)

The commands that I now used:

We learned last time:
npm install -g @playwright/cli@latest
npm init playwright@latest
npx playright test

npx skills add \
  microsoft/playwright-cli@playwright-cli \
  currents-dev/playwright-best-practices-skill@playwright-best-practices \
  github/awesome-copilot@playwright-generate-test

And now the prompt that I used:

```
Can you please use playwright-cli to walk through https://koudijs.dev -> can you make a little plan to show how you would test it? I just would like to have some simple tests to show that all works as I expect.
```

Now I notice a lot of files are beeing added (in my Git pane). Let's use a .gitignore to prevent that from happening now!

Well it just didnt create a little plan now: it just implemented the first set of tests already. 

It's giving me now a long report on how I can use all of this:

```
Done. I walked through https://koudijs.dev with playwright-cli, figured out what's worth testing, then wrote and verified a small smoke suite.

The plan
I explored the live site and settled on five things a visitor relies on, kept deliberately simple:

#	Area	What it checks
1	Home page	Title is koudijs.dev, the <h1> and the tagline render
2	Social links	LinkedIn / GitHub / Substack point to the correct URLs
3	Navigation	Each menu item (speaking, training, about, tags, search) lands on the right page + title; logo returns home
4	Theme toggle	Clicking adds dark to <body> and persists pref-theme=dark
5	Search	Typing a query renders matching posts into #searchResults
What I changed
playwright.config.ts — set baseURL: 'https://koudijs.dev' so tests use page.goto('/').
tests/koudijs.spec.ts — the 10 tests above (some are parameterized per nav link).
Removed the default tests/example.spec.ts scaffold.
Two things the walkthrough caught
Both showed up as test failures first, which is exactly what you want a smoke suite to surface:

Hugo redirects to trailing slashes — /speaking → /speaking/. I match the path with an optional trailing /.
Search reacts to keyup, not value-setting — Playwright's fill() silently did nothing; switching to pressSequentially() (real keystrokes) made results appear. Good to know if you write more search tests later.
Running them

Done. I walked through https://koudijs.dev with playwright-cli, figured out what's worth testing, then wrote and verified a small smoke suite.

The plan
I explored the live site and settled on five things a visitor relies on, kept deliberately simple:

#	Area	What it checks
1	Home page	Title is koudijs.dev, the <h1> and the tagline render
2	Social links	LinkedIn / GitHub / Substack point to the correct URLs
3	Navigation	Each menu item (speaking, training, about, tags, search) lands on the right page + title; logo returns home
4	Theme toggle	Clicking adds dark to <body> and persists pref-theme=dark
5	Search	Typing a query renders matching posts into #searchResults
What I changed
playwright.config.ts — set baseURL: 'https://koudijs.dev' so tests use page.goto('/').
tests/koudijs.spec.ts — the 10 tests above (some are parameterized per nav link).
Removed the default tests/example.spec.ts scaffold.
Two things the walkthrough caught
Both showed up as test failures first, which is exactly what you want a smoke suite to surface:

Hugo redirects to trailing slashes — /speaking → /speaking/. I match the path with an optional trailing /.
Search reacts to keyup, not value-setting — Playwright's fill() silently did nothing; switching to pressSequentially() (real keystrokes) made results appear. Good to know if you write more search tests later.
Running them

npx playwright test tests/koudijs.spec.ts                 # all browsers
npx playwright test tests/koudijs.spec.ts --project=chromium
npx playwright show-report                                # HTML report
All 10 pass on chromium against the live site (~1s). The config also has firefox/webkit projects enabled — I only ran chromium here since it's the fastest signal; let me know if you'd like me to run the full cross-browser matrix or add anything (e.g. a check that a blog post opens, or mobile viewport).

Note: these hit the production site, so they're really smoke/monitoring tests. If you'd rather run them against a local hugo server in CI, I can wire up the webServer block in the config instead — just say the word.                 # all browsers
npx playwright test tests/koudijs.spec.ts --project=chromium
npx playwright show-report                                # HTML report
All 10 pass on chromium against the live site (~1s). The config also has firefox/webkit projects enabled — I only ran chromium here since it's the fastest signal; let me know if you'd like me to run the full cross-browser matrix or add anything (e.g. a check that a blog post opens, or mobile viewport).

Note: these hit the production site, so they're really smoke/monitoring tests. If you'd rather run them against a local hugo server in CI, I can wire up the webServer block in the config instead — just say the word.
```

Let's see if we can run them locally now.


You can run with tracing always:

npx playwright test tests/koudijs.spec.ts --trace on

Now you can show a GUI to show what's happening

npx playwright show-trace


Let's see if we can get this to run inside a pull request as well