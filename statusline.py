#!/usr/bin/env python3
"""
Custom statusline for Claude Code
Features: Model, Git (branch + diff), Directory, Session Cost, Duration, Lines Stats
Requires: git, python3, nerd-fonts
"""

import json
import sys
import os
import subprocess
from pathlib import Path


# Gruvbox-Material Hard Color Palette (256-color approximations)
class Colors:
    # Backgrounds
    BG0 = 234  # #1d2021
    BG1 = 235  # #282828
    BG2 = 236  # #32302f

    # Foreground colors
    FG = 223  # #d4be98
    ORANGE = 208  # #e78a4e
    GREEN = 142  # #a9b665
    BLUE = 109  # #7daea3
    YELLOW = 214  # #d8a657
    RED = 167  # #ea6962
    GREY = 246  # #928374

    # Special
    RESET = "\033[0m"
    BOLD = "\033[1m"


# Nerd Font Icons (no emojis)
class Icons:
    MODEL = "󰧑"  # nf-md-brain
    GIT_BRANCH = ""  # nf-dev-git_branch
    FOLDER = ""  # nf-fa-folder
    DOLLAR = ""  # nf-fa-dollar
    CLOCK = "󰥔"  # nf-md-clock_outline
    PLUS = ""  # nf-fa-plus
    PENCIL = "󰏫"  # nf-fa-pencil
    MINUS = ""  # nf-fa-minus


# Separators
POWERLINE_ARROW = ""  # nf-pl-right_hard_divider
COMPONENT_SEP = "┃"


def color_bg(color_code):
    """Set background color"""
    return f"\033[48;5;{color_code}m"


def color_fg(color_code):
    """Set foreground color"""
    return f"\033[38;5;{color_code}m"


def get_git_branch(cwd):
    """Get current git branch"""
    git_head = Path(cwd) / ".git" / "HEAD"

    if not git_head.exists():
        return None

    try:
        with open(git_head, "r") as f:
            ref = f.read().strip()
            if ref.startswith("ref: refs/heads/"):
                return ref.replace("ref: refs/heads/", "")
            # Detached HEAD - show short commit hash
            return ref[:7]
    except Exception:
        return None


def get_git_diff_stats(cwd):
    """Get git diff statistics (added, modified, removed files)"""
    try:
        result = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=1,
        )

        if result.returncode != 0:
            return None

        lines = result.stdout.strip().split("\n")
        if not lines or lines == [""]:
            return None

        added = 0
        modified = 0
        removed = 0

        for line in lines:
            if not line:
                continue

            status = line[:2]

            # Check staged changes (first character)
            if status[0] == "A":
                added += 1
            elif status[0] == "M":
                modified += 1
            elif status[0] == "D":
                removed += 1

            # Check unstaged changes (second character)
            if status[1] == "M":
                modified += 1
            elif status[1] == "D":
                removed += 1

            # Untracked files
            if status == "??":
                added += 1

        if added == 0 and modified == 0 and removed == 0:
            return None

        return {"added": added, "modified": modified, "removed": removed}

    except Exception:
        return None


def format_duration(seconds):
    """Format duration as 'Xh Ym' or 'Xm'"""
    if seconds is None or seconds == 0:
        return "0m"

    minutes = int(seconds // 60)
    hours = minutes // 60
    remaining_minutes = minutes % 60

    if hours > 0:
        return f"{hours}h {remaining_minutes}m"
    return f"{minutes}m"


def format_cost(cost):
    """Format cost as $X.XX"""
    if cost is None or cost == 0:
        return "$0.00"
    return f"${cost:.2f}"


def format_section(content, fg_color, bg_color, next_bg_color=None):
    """Format a powerline section with colors and arrow"""
    section = ""

    # Content with background and foreground
    section += color_bg(bg_color) + color_fg(fg_color)
    section += f" {content} "

    # Arrow separator
    if next_bg_color is not None:
        # Transition to next section
        section += color_fg(bg_color) + color_bg(next_bg_color)
        section += POWERLINE_ARROW
    else:
        # Final section - reset background
        section += Colors.RESET + color_fg(bg_color)
        section += POWERLINE_ARROW

    return section


def format_component(icon, text, fg_color):
    """Format a component within a section"""
    return color_fg(fg_color) + icon + " " + text


def main():
    try:
        # Read JSON input from stdin
        data = json.load(sys.stdin)

        # Extract information
        model_name = data.get("model", {}).get("display_name", "Claude")
        cwd = data.get("workspace", {}).get("current_dir", os.getcwd())
        cost_data = data.get("cost", {})

        # Session metrics
        session_cost = cost_data.get("total_cost", 0)
        session_duration = cost_data.get("duration", 0)
        lines_added = cost_data.get("lines_added", 0)
        lines_removed = cost_data.get("lines_removed", 0)

        # Git information
        git_branch = get_git_branch(cwd)
        git_diff = get_git_diff_stats(cwd) if git_branch else None

        # Directory name
        dir_name = os.path.basename(cwd) or "~"

        sections = []

        # Section A: Model (orange, like lualine_a mode)
        model_content = format_component(Icons.MODEL, model_name, Colors.ORANGE)
        sections.append(
            format_section(model_content, Colors.ORANGE, Colors.BG0, Colors.BG0)
        )

        # Section B: Git Info (green, like lualine_b)
        if git_branch:
            git_content = format_component(Icons.GIT_BRANCH, git_branch, Colors.GREEN)

            # Add diff stats if available
            if git_diff:
                diff_parts = []
                if git_diff["added"] > 0:
                    diff_parts.append(
                        color_fg(Colors.GREEN) + f"{Icons.PLUS} {git_diff['added']}"
                    )
                if git_diff["modified"] > 0:
                    diff_parts.append(
                        color_fg(Colors.YELLOW)
                        + f"{Icons.PENCIL} {git_diff['modified']}"
                    )
                if git_diff["removed"] > 0:
                    diff_parts.append(
                        color_fg(Colors.RED) + f"{Icons.MINUS} {git_diff['removed']}"
                    )

                if diff_parts:
                    git_content += (
                        " "
                        + color_fg(Colors.GREY)
                        + COMPONENT_SEP
                        + " "
                        + " ".join(diff_parts)
                    )

            sections.append(
                format_section(git_content, Colors.GREEN, Colors.BG0, Colors.BG0)
            )

        # Section C: Directory (foreground, like lualine_c filename)
        dir_content = format_component(Icons.FOLDER, dir_name, Colors.FG)
        sections.append(format_section(dir_content, Colors.FG, Colors.BG0, Colors.BG0))

        # Section Y: Session Metrics (yellow/foreground, like lualine_y progress + lualine_z location)
        metrics_parts = []

        # Cost
        if session_cost > 0:
            metrics_parts.append(
                format_component(Icons.DOLLAR, format_cost(session_cost), Colors.YELLOW)
            )

        # Duration
        if session_duration > 0:
            metrics_parts.append(
                format_component(
                    Icons.CLOCK, format_duration(session_duration), Colors.FG
                )
            )

        # Lines added/removed
        if lines_added > 0 or lines_removed > 0:
            lines_text = f"{Icons.PLUS}{lines_added} {Icons.MINUS}{lines_removed}"
            metrics_parts.append(color_fg(Colors.FG) + lines_text)

        if metrics_parts:
            metrics_content = (" " + color_fg(Colors.GREY) + COMPONENT_SEP + " ").join(
                metrics_parts
            )
            sections.append(
                format_section(metrics_content, Colors.FG, Colors.BG0, None)
            )

        # Output final statusline
        statusline = "".join(sections) + Colors.RESET
        print(statusline, flush=True)

    except Exception:
        # Fallback on error
        print("Claude Code", flush=True)


if __name__ == "__main__":
    main()
