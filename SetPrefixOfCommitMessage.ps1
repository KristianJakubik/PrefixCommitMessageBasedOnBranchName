param([string]$file)

function GetCurrentCommitMessage {
    param([string] $file)

    return Get-Content $file
}

function GetBranchPrefix {
    $branchName = git rev-parse --abbrev-ref HEAD
    $matches = $branchName | Select-String -Pattern '(\w+-\d+)'
    $prefix = $matches.Matches[0].Groups[1].Value

    return $prefix
}

function CheckIfContainsPrefix {
    param([string] $message, [string] $prefix)
    
    return $message -match '^\w+-\d+'
}

function SetPrefix{
    param([string] $message, [string] $prefix)
    
    if ($(CheckIfContainsPrefix $message $prefix)) {
        return $message
    }
    else {
        return "$prefix - $message"
    }
}

function SetNewCommitMessage {
    param([string] $message, [string] $file)

    Set-Content $file $message     
}

$message = GetCurrentCommitMessage $file
$prefix = GetBranchPrefix
$messageWithPrefix = SetPrefix $message $prefix
SetNewCommitMessage $messageWithPrefix $file

