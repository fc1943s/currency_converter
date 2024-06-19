import { PlaywrightTestConfig, devices } from "@playwright/test"
import * as path from "path"

const PORT = process.env.PORT || 8080

const baseURL = `http://localhost:${PORT}`

export default {
  timeout: 20 * 1000,
  testDir: path.join(__dirname, 'tests'),
  retries: process.env.CI ? 1 : 0,
  outputDir: "test-results/",
  fullyParallel: true,
  reporter: "html",

  webServer: [
    {
      command: `pwsh ../../scripts/serve.ps1`,
      url: baseURL,
      timeout: 40 * 1000,
      reuseExistingServer: false,
    },
  ],

  use: {
    baseURL,
    trace: { mode: "on-first-retry" },
    video: { mode: "on-first-retry" },
  },

  projects: [
    {
      name: "Desktop Chrome",
      use: {
        ...devices["Desktop Chrome"],
      },
    },
  ],
} as PlaywrightTestConfig
