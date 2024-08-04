$source = "C:\Git\frasermolyneux\molyneux-me\posts.json"

$json = Get-Content $source | ConvertFrom-Json

$json.items.item | ForEach-Object {
    $post = $_

    if ($post.post_type -eq "post") {
        $postContent = $post.content_encoded
        $postContent = $postContent -replace "https://molyneux.me/wp-content/uploads/", "https://sa220030efa07d.blob.core.windows.net/images/"
        $postContent = $postContent -replace ' class="[^"]*"', ''
        $postContent = $postContent -replace ' width="[^"]*"', ''
        $postContent = $postContent -replace ' height="[^"]*"', ''
        
        $categories = @()
        foreach ($category in $post.category) {
            $categories += $category._nicename
        }
    
        $content = @"
---
layout: post
title:  "$($post.title)"
date: $((Get-Date($post.post_date)).ToString('yyyy-MM-dd HH:mm:ss +0000'))
categories: $($categories -join " ")
---

$postContent
"@
    
        $postPath = "C:\Git\frasermolyneux\molyneux-me\_posts\$((Get-Date($post.post_date)).ToString('yyyy-MM-dd'))-$($post.post_name).markdown"

        if (Test-Path -Path $postPath) {
            Remove-Item -Path $postPath -Force
        }

        Set-Content -Path $postPath -Value $content
    }    
}