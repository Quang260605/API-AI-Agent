<#
.SYNOPSIS
    Automated installer & bundler for Skill_AI_ALL (v3.0) across AI Agents:
    Claude Code, Claude Desktop App (.zip), OpenCode, Antigravity/Gemini, Cursor, Windsurf, Cline, GitHub Copilot.

.EXAMPLE
    # Install globally for Claude Code, OpenCode, Antigravity, and rebuild Claude App .zip packages:
    .\apply-skill-pack.ps1 -Target Global

    # Install into a specific project folder:
    .\apply-skill-pack.ps1 -Target Project -ProjectPath "D:\MyProject"
#>

param (
    [ValidateSet("Global", "Project", "All")]
    [string]$Target = "Global",

    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$SourceFile = Join-Path $PSScriptRoot "UNIVERSAL_AI_SKILL_PACK.md"
$SkillsDir  = Join-Path $PSScriptRoot "skills"
$ZipsDir    = Join-Path $PSScriptRoot "claude-app-zips"

if (-not (Test-Path $SourceFile)) {
    Write-Error "Source file not found: $SourceFile"
    exit 1
}

function Copy-SafeFile {
    param([string]$Src, [string]$DestPath)
    $DestDir = Split-Path -Parent $DestPath
    if (-not (Test-Path $DestDir)) {
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    }
    Copy-Item -Path $Src -Destination $DestPath -Force
    Write-Host "  [OK] Installed -> $DestPath" -ForegroundColor Green
}

function Sync-SkillsFolder {
    param([string]$DestSkillsRoot)
    if (-not (Test-Path $DestSkillsRoot)) {
        New-Item -ItemType Directory -Path $DestSkillsRoot -Force | Out-Null
    }
    Get-ChildItem -Path $SkillsDir -Directory | ForEach-Object {
        $SkillMd = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $SkillMd) {
            $DestSkillMd = Join-Path $DestSkillsRoot "$($_.Name)\SKILL.md"
            Copy-SafeFile -Src $SkillMd -DestPath $DestSkillMd
        }
    }
}

# Step 0: Keep the all-in-one skill module synced with UNIVERSAL_AI_SKILL_PACK.md
$MasterSkillDest = Join-Path $SkillsDir "universal-ai-elite-skill-pack\SKILL.md"
Copy-Item -Path $SourceFile -Destination $MasterSkillDest -Force

# Step 1: Run offline Zero-Leak check on the entire Skill_AI_ALL folder before distributing
$SecretGuard = Join-Path $PSScriptRoot "secret_guard.py"
if ((Get-Command python -ErrorAction SilentlyContinue) -and (Test-Path $SecretGuard)) {
    Write-Host "[1/4] Running offline Zero-Leak Security Check on Skill_AI_ALL..." -ForegroundColor Cyan
    python $SecretGuard $PSScriptRoot
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Sensitive data detected! Installation aborted."
        exit 1
    }

    Write-Host "`n[2/4] Building POSIX-compliant .zip packages for Claude Desktop App..." -ForegroundColor Cyan
    python -c "
import pathlib, zipfile
base = pathlib.Path(r'$PSScriptRoot')
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
"
}

if ($Target -in @("Global", "All")) {
    Write-Host "`n[3/4] Applying Skill_AI_ALL to Global AI Agents..." -ForegroundColor Cyan

    # 1. Claude Code & Claude Desktop App Code Tab (Global CLAUDE.md + All Modular Skills)
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $HOME ".claude\CLAUDE.md")
    Sync-SkillsFolder -DestSkillsRoot (Join-Path $HOME ".claude\skills")

    # 2. OpenCode Desktop & CLI (Global AGENTS.md + All Modular Skills)
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $HOME ".config\opencode\AGENTS.md")
    Sync-SkillsFolder -DestSkillsRoot (Join-Path $HOME ".config\opencode\skills")

    # 3. Antigravity / Gemini CLI (All Modular Skills)
    Sync-SkillsFolder -DestSkillsRoot (Join-Path $HOME ".gemini\config\skills")
}

if ($Target -in @("Project", "All")) {
    Write-Host "`n[4/4] Applying Skill_AI_ALL to Project Folder: $ProjectPath ..." -ForegroundColor Cyan

    # Standard for OpenCode, Antigravity, Codex, Cursor, Devin
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath "AGENTS.md")

    # Standard for Claude Code
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath "CLAUDE.md")
    Sync-SkillsFolder -DestSkillsRoot (Join-Path $ProjectPath ".claude\skills")

    # Standard for Cursor / Windsurf / Cline / GitHub Copilot
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath ".cursorrules")
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath ".windsurfrules")
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath ".clinerules")
    Copy-SafeFile -Src $SourceFile -DestPath (Join-Path $ProjectPath ".github\copilot-instructions.md")
}

Write-Host "`nDone! Skill_AI_ALL v3.0 is active and protected by Zero-Leak protocol." -ForegroundColor Yellow
