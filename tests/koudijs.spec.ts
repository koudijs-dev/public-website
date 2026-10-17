import { test, expect } from '@playwright/test';

/**
 * Simple smoke tests for https://koudijs.dev
 *
 * These verify the things you'd expect a visitor to rely on:
 * the home page renders, navigation works, social links point where
 * they should, the theme toggle persists, and search returns results.
 *
 * baseURL is set to https://koudijs.dev in playwright.config.ts, so
 * page.goto('/') hits the live site.
 */

test.describe('home page', () => {
  test('loads with the expected title, heading and tagline', async ({ page }) => {
    await page.goto('/');

    await expect(page).toHaveTitle('koudijs.dev');
    await expect(page.getByRole('heading', { level: 1, name: 'koudijs.dev' })).toBeVisible();
    await expect(
      page.getByText('Consultant, trainer, and speaker on software delivery'),
    ).toBeVisible();
  });

  test('shows the social links pointing to the right profiles', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('link', { name: 'LinkedIn' })).toHaveAttribute(
      'href',
      'https://www.linkedin.com/in/simonkoudijs/',
    );
    await expect(page.getByRole('link', { name: 'GitHub' })).toHaveAttribute(
      'href',
      'https://github.com/sunib',
    );
    await expect(page.getByRole('link', { name: 'Substack' })).toHaveAttribute(
      'href',
      'https://simonkoudijs.substack.com/',
    );
  });
});

test.describe('navigation', () => {
  // Each menu item -> the page it should land on. Hugo serves these with a
  // trailing slash, so we match the path with an optional final "/".
  const pages = [
    { name: 'speaking', path: '/speaking', title: 'Speaking | koudijs.dev' },
    { name: 'training', path: '/training', title: 'Training | koudijs.dev' },
    { name: 'about', path: '/about', title: 'About | koudijs.dev' },
    { name: 'tags', path: '/tags', title: 'Tags | koudijs.dev' },
    { name: 'search', path: '/search', title: 'Search | koudijs.dev' },
  ];

  for (const { name, path, title } of pages) {
    test(`the "${name}" menu link opens ${path}`, async ({ page }) => {
      await page.goto('/');
      await page.getByRole('navigation').getByRole('link', { name, exact: true }).click();

      await expect(page).toHaveURL(new RegExp(`${path.replace(/\//g, '\\/')}/?$`));
      await expect(page).toHaveTitle(title);
    });
  }

  test('the logo returns to the home page', async ({ page }) => {
    await page.goto('/about');
    await page.getByRole('navigation').getByRole('link', { name: 'koudijs.dev' }).click();

    // Relative path resolves against baseURL, so this works for previews too.
    await expect(page).toHaveURL('/');
    await expect(page.getByRole('heading', { level: 1, name: 'koudijs.dev' })).toBeVisible();
  });
});

test.describe('theme toggle', () => {
  test('switches to dark mode and remembers the choice', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('body')).not.toHaveClass(/dark/);

    await page.locator('#theme-toggle').click();

    await expect(page.locator('body')).toHaveClass(/dark/);
    // PaperMod stores the preference so it survives a reload.
    const pref = await page.evaluate(() => localStorage.getItem('pref-theme'));
    expect(pref).toBe('dark');
  });
});

test.describe('search', () => {
  test('returns matching posts as you type', async ({ page }) => {
    await page.goto('/search/');

    const box = page.getByRole('searchbox', { name: 'search' });
    // Results are rendered into #searchResults by the client-side (fuse.js) index.
    const results = page.locator('#searchResults li');

    // fastsearch.js builds the Fuse index asynchronously (XHR on window.onload)
    // and only runs a search on keyup. On webkit the index can still be building
    // when the keystrokes fire, so those keyups no-op and nothing re-triggers a
    // search. Retype until results appear — once the index is ready, they do.
    await expect(async () => {
      await box.fill('');
      await box.pressSequentially('git');
      await expect(results.first()).toBeVisible({ timeout: 2000 });
    }).toPass({ timeout: 15000 });

    expect(await results.count()).toBeGreaterThan(0);
  });
});
