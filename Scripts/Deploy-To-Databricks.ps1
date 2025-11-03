# Enterprise Deployment Script for DfE Education Lakehouse (Overwrite Mode)

Write-Host "🚀 Deploying DfE Education Lakehouse to Git-backed Repo..." -ForegroundColor Green

# Upload notebooks to the actual repo location (overwrite existing)
Write-Host "Uploading notebooks to Git repository (overwriting existing)..." -ForegroundColor Cyan
Get-ChildItem "notebooks" -Filter *.py | ForEach-Object {
    $notebookName = $_.BaseName
    $sourcePath = $_.FullName
    $targetPath = "/Users/ec09495@yahoo.com/education-lakehouse-pipeline/$notebookName"
    
    Write-Host "  Uploading: $notebookName" -ForegroundColor Gray
    
    # Delete existing notebook first, then upload
    try {
        databricks workspace rm "$targetPath"
        Write-Host "    ♻️  Removed existing notebook" -ForegroundColor Yellow
    } catch {
        Write-Host "    ℹ️  No existing notebook to remove" -ForegroundColor Gray
    }
    
    # Upload to Git repo
    databricks workspace import "$sourcePath" "$targetPath" --language PYTHON --format SOURCE
    Write-Host "    ✅ Uploaded successfully" -ForegroundColor Green
}

Write-Host "✅ Enterprise deployment completed!" -ForegroundColor Green
Write-Host "Notebooks deployed to: /Users/ec09495@yahoo.com/education-lakehouse-pipeline" -ForegroundColor Yellow
