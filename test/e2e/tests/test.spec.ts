import { test, expect } from "@playwright/test";

test("test", async ({ page }) => {
  await page.goto("http://localhost:8080");

  await expect(page).toHaveTitle("Currency Converter");
  
  await page.fill('input[name="from"]', "USD");
  await page.fill('input[name="to"]', "EUR");
  await page.fill('input[name="amount"]', "100");
  await page.click('button[type="submit"]');

  await page.waitForSelector("text=API");
});
