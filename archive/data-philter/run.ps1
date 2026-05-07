# run.ps1 — Manage Data Philter services on Windows (start/stop/restart/status/logs/pull/down)

param(
    [Parameter(Position=0)]
    [ValidateSet('start','stop','restart','status','logs','pull','down')]
    [string]$command = 'start',

    # Pass-through for logs: service name (optional)
    [Parameter(Position=1)]
    [string]$service = ''
)

function Write-Log($Message){ Write-Host -ForegroundColor Green $Message }
function Write-Info($Message){ Write-Host $Message }
function Write-ErrExit($Message, [int]$Code=1){ Write-Host -ForegroundColor Red $Message; exit $Code }

$DATA_DIR = Join-Path $HOME ".data-philter"
$COMPOSE_FILE = Join-Path $DATA_DIR "docker-compose.yml"

function Ensure-Docker {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-ErrExit "Docker could not be found. Please install Docker Desktop first."
    }
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrExit "Docker daemon is not running or not accessible. Start Docker Desktop and retry."
    }
    docker compose version > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrExit "'docker compose' is not available. Update Docker Desktop to include Compose."
    }
}

function Set-ComposeProfiles {
    # Determine compose profiles based on PHILTER_MCP_SERVER
    $profiles = @()
    $mcp = $env:PHILTER_MCP_SERVER
    # Also try reading from app.env if not set in environment
    $appEnv = Join-Path $DATA_DIR 'app.env'
    if ([string]::IsNullOrWhiteSpace($mcp) -and (Test-Path $appEnv)) {
        $line = (Get-Content $appEnv | Where-Object { $_ -match '^PHILTER_MCP_SERVER=' } | Select-Object -First 1)
        if ($line) { $mcp = $line -replace '^PHILTER_MCP_SERVER=','' }
    }

    switch -Regex ($mcp) {
        '^(?i)druid$' { $profiles += 'druid'; break }
        '^(?i)clickhouse$' { $profiles += 'clickhouse'; break }
        '^(?i)(all|druid,clickhouse|clickhouse,druid)$' { $profiles += 'druid','clickhouse'; break }
        default { }
    }

    # Set COMPOSE_PROFILES environment variable
    if ($profiles -and $profiles.Count -gt 0) {
        $env:COMPOSE_PROFILES = $profiles -join ','
    }
}

function Wait-ForBackend([string]$BaseUrl='http://localhost:4000', [int]$TimeoutSeconds=120, [int]$IntervalSeconds=2){
    $health = "$BaseUrl/actuator/health"
    $elapsed = 0
    Write-Info "Waiting for backend at $BaseUrl (timeout ${TimeoutSeconds}s)..."
    while ($elapsed -lt $TimeoutSeconds) {
        try {
            $r = Invoke-WebRequest -Uri $health -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
            if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 300) { Write-Log "Backend is up!"; return }
        } catch { }
        Start-Sleep -Seconds $IntervalSeconds
        $elapsed += $IntervalSeconds
    }
    Write-Host -ForegroundColor Yellow "Backend did not become ready within ${TimeoutSeconds}s."
}

function Ensure-LocationAndFiles {
    if (-not (Test-Path $DATA_DIR)) { Write-ErrExit "Data Philter directory not found: $DATA_DIR. Run install.ps1 first." }
    if (-not (Test-Path $COMPOSE_FILE)) { Write-ErrExit "docker-compose.yml not found in $DATA_DIR. Run install.ps1 to download it." }
    Set-Location $DATA_DIR
}

Ensure-Docker
Ensure-LocationAndFiles
Set-ComposeProfiles

switch ($command) {
    'start' {
        Write-Log "Starting Data Philter services..."
        & docker compose -f $COMPOSE_FILE up -d
        if ($LASTEXITCODE -ne 0) { Write-ErrExit "Failed to start services." }
        Wait-ForBackend -BaseUrl 'http://localhost:4000' -TimeoutSeconds 120 -IntervalSeconds 2
        try { Start-Process 'http://localhost:4000' } catch { }
        Write-Log "Services started."
    }
    'stop' {
        Write-Log "Stopping services..."
        & docker compose -f $COMPOSE_FILE stop
        if ($LASTEXITCODE -ne 0) { Write-ErrExit "Failed to stop services." }
        Write-Log "Services stopped."
    }
    'restart' {
        Write-Log "Restarting services..."
        & docker compose -f $COMPOSE_FILE restart
        if ($LASTEXITCODE -ne 0) { Write-ErrExit "Failed to restart services." }
        Wait-ForBackend -BaseUrl 'http://localhost:4000' -TimeoutSeconds 120 -IntervalSeconds 2
        Write-Log "Services restarted."
    }
    'status' {
        & docker compose -f $COMPOSE_FILE ps
    }
    'logs' {
        $args = @('-f', $COMPOSE_FILE, 'logs', '-f')
        if ($service) { $args += $service }
        & docker compose @args
    }
    'pull' {
        Write-Log "Pulling latest images..."
        & docker compose -f $COMPOSE_FILE pull
    }
    'down' {
        Write-Log "Stopping and removing containers, networks, and volumes (not data volumes unless defined)."
        & docker compose -f $COMPOSE_FILE down
    }
}
