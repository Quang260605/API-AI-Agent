#!/usr/bin/env bash
# ==============================================================================
# Automated Installer & Bundler for Skill_AI_ALL (v3.0) on Kali Linux / Linux / macOS
# Supports: Claude Code, OpenCode, Antigravity/Gemini CLI, Cursor, Windsurf, Cline, Copilot
#
# Usage:
#   bash apply-skill-pack.sh global
#   bash apply-skill-pack.sh project /path/to/your/project
#   bash apply-skill-pack.sh all /path/to/your/project
# ==============================================================================

set -euo pipefail

TARGET="${1:-global}"
TARGET="$(echo "$TARGET" | tr '[:upper:]' '[:lower:]')"
PROJECT_PATH="${2:-$(pwd)}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/UNIVERSAL_AI_SKILL_PACK.md"
SKILLS_DIR="$SCRIPT_DIR/skills"
SECRET_GUARD="$SCRIPT_DIR/secret_guard.py"

if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "[ERROR] Source file not found: $SOURCE_FILE" >&2
    exit 1
fi

# Determine Python binary (python3 preferred on Kali Linux)
PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
fi

copy_safe_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    cp -f "$src" "$dest"
    echo -e "  \033[0;32m[OK]\033[0m Installed -> $dest"
}

sync_skills_folder() {
    local dest_root="$1"
    mkdir -p "$dest_root"
    for skill_folder in "$SKILLS_DIR"/*/; do
        [[ -d "$skill_folder" ]] || continue
        local skill_name
        skill_name="$(basename "$skill_folder")"
        local skill_md="${skill_folder}SKILL.md"
        if [[ -f "$skill_md" ]]; then
            copy_safe_file "$skill_md" "$dest_root/$skill_name/SKILL.md"
        fi
    done
}

# Step 0: Keep the all-in-one skill module synced with UNIVERSAL_AI_SKILL_PACK.md
mkdir -p "$SKILLS_DIR/universal-ai-elite-skill-pack"
cp -f "$SOURCE_FILE" "$SKILLS_DIR/universal-ai-elite-skill-pack/SKILL.md"

# Step 1: Run offline Zero-Leak check and rebuild .zip packages if Python is available
if [[ -n "$PYTHON_BIN" && -f "$SECRET_GUARD" ]]; then
    echo -e "\033[0;36m[1/4] Running offline Zero-Leak Security Check on Skill_AI_ALL...\033[0m"
    "$PYTHON_BIN" "$SECRET_GUARD" "$SCRIPT_DIR"

    echo -e "\n\033[0;36m[2/4] Building POSIX-compliant .zip packages...\033[0m"
    "$PYTHON_BIN" - "$SCRIPT_DIR" <<'PYEOF'
import pathlib, sys, zipfile
base = pathlib.Path(sys.argv[1])
skills_dir = base / 'skills'
out_dir = base / 'claude-app-zips'
out_dir.mkdir(parents=True, exist_ok=True)
valid_zips = set()
for sf in sorted(skills_dir.iterdir()):
    if sf.is_dir() and (sf / 'SKILL.md').exists():
        zp = out_dir / f'{sf.name}.zip'
        valid_zips.add(zp.name)
        with zipfile.ZipFile(zp, 'w', zipfile.ZIP_DEFLATED) as zf:
            for fp in sf.rglob('*'):
                if fp.is_file():
                    zf.write(fp, f'{sf.name}/{fp.relative_to(sf).as_posix()}')
        print('  [OK] Packaged ->', zp)
for old_zip in out_dir.glob('*.zip'):
    if old_zip.name not in valid_zips:
        old_zip.unlink()
PYEOF
fi

if [[ "$TARGET" == "global" || "$TARGET" == "all" || "$TARGET" == "-target" ]]; then
    echo -e "\n\033[0;36m[3/4] Applying Skill_AI_ALL to Global AI Agents on Kali/Linux...\033[0m"

    # 1. Claude Code (Global ~/.claude/CLAUDE.md + ~/.claude/skills)
    copy_safe_file "$SOURCE_FILE" "$HOME/.claude/CLAUDE.md"
    sync_skills_folder "$HOME/.claude/skills"

    # 2. OpenCode CLI & Desktop (Global ~/.config/opencode/AGENTS.md + ~/.config/opencode/skills)
    copy_safe_file "$SOURCE_FILE" "$HOME/.config/opencode/AGENTS.md"
    sync_skills_folder "$HOME/.config/opencode/skills"

    # 3. Antigravity / Gemini CLI (~/.gemini/config/skills)
    sync_skills_folder "$HOME/.gemini/config/skills"
fi

if [[ "$TARGET" == "project" || "$TARGET" == "all" ]]; then
    echo -e "\n\033[0;36m[4/4] Applying Skill_AI_ALL to Project Folder: $PROJECT_PATH ...\033[0m"

    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/AGENTS.md"
    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/CLAUDE.md"
    sync_skills_folder "$PROJECT_PATH/.claude/skills"

    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/.cursorrules"
    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/.windsurfrules"
    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/.clinerules"
    copy_safe_file "$SOURCE_FILE" "$PROJECT_PATH/.github/copilot-instructions.md"
fi

echo -e "\n\033[1;33mDone! Skill_AI_ALL v3.0 is active on Linux/Kali and protected by Zero-Leak protocol.\033[0m"
