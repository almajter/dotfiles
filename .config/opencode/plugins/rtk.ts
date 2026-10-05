/**
 * rtk (Rust Token Killer) shell proxy for OpenCode V2.
 *
 * Ports the Claude Code PreToolUse hook (`rtk hook claude`) to OpenCode by
 * rewriting shell commands before they run. rtk prepends `rtk ` to supported
 * commands so their output is filtered before it reaches the model.
 *
 * Uses the plain V2 plugin shape (default export with `id` and `setup`) so it
 * needs no imports. Any failure is swallowed so a missing or broken rtk never
 * blocks a shell command.
 */

import { spawnSync } from "node:child_process"

const RTK = process.env.RTK_BIN || "rtk"

function rewrite(command: string, cwd: string): string | undefined {
  // Never double-rewrite a command that already goes through rtk.
  if (command.startsWith("rtk ")) return undefined

  try {
    const result = spawnSync(RTK, ["hook", "claude"], {
      input: JSON.stringify({
        hook_event_name: "PreToolUse",
        tool_name: "Bash",
        tool_input: { command },
        cwd,
      }),
      encoding: "utf8",
      timeout: 5000,
      maxBuffer: 1024 * 1024,
    })

    if (result.status !== 0 || !result.stdout) return undefined

    const parsed = JSON.parse(result.stdout)
    const updated = parsed?.hookSpecificOutput?.updatedInput?.command
    if (typeof updated === "string" && updated.length > 0 && updated !== command) return updated
  } catch {
    // Ignore: rtk is optional tooling.
  }

  return undefined
}

export default {
  id: "rtk",
  async setup(ctx: any) {
    await ctx.shell.hook("create.before", (event: any) => {
      const next = rewrite(event.command, event.cwd)
      if (next) event.command = next
    })
  },
}
