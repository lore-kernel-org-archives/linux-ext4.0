From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: + ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
	added to -mm tree
Date: Tue, 24 Jun 2008 14:34:17 +0100
Message-ID: <20080624133417.GA22898@dastardly>
References: <200806232343.m5NNhD2B022383@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4974 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYFXNeU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 09:34:20 -0400
Content-Disposition: inline
In-Reply-To: <200806232343.m5NNhD2B022383@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 23, 2008 at 04:43:13PM -0700, akpm@linux-foundation.org wrote:
> Subject: ext3-handle-corrupted-orphan-list-at-mount-cleanup
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Try to make that expression less mind-boggling.
> 
> Cc: <linux-ext4@vger.kernel.org>
> Cc: Duane Griffin <duaneg@dghda.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext3/inode.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff -puN fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount-cleanup fs/ext3/inode.c
> --- a/fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount-cleanup
> +++ a/fs/ext3/inode.c
> @@ -2258,10 +2258,16 @@ static void ext3_free_branches(handle_t 
>  
>  int ext3_can_truncate(struct inode *inode)
>  {
> -	return (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -		S_ISLNK(inode->i_mode)) &&
> -		!ext3_inode_is_fast_symlink(inode) &&
> -		!(IS_APPEND(inode) || IS_IMMUTABLE(inode));
> +	if (S_ISREG(inode->i_mode))
> +		return 1;
> +	if (S_ISDIR(inode->i_mode))
> +		return 1;
> +	if (S_ISLNK(inode->i_mode)) {
> +		if (!ext3_inode_is_fast_symlink(inode) &&
> +				!(IS_APPEND(inode) || IS_IMMUTABLE(inode)))
> +			return 1;
> +	}
> +	return 0;
>  }
>  
>  /*

Proving your point, the cleanup above is wrong. It should be:

--- fs/ext3/inode.c.orig	2008-06-24 14:19:06.000000000 +0100
+++ fs/ext3/inode.c	2008-06-24 14:19:19.000000000 +0100
@@ -2255,10 +2255,15 @@ static void ext3_free_branches(handle_t 
 
 int ext3_can_truncate(struct inode *inode)
 {
-	return (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-		S_ISLNK(inode->i_mode)) &&
-		!ext3_inode_is_fast_symlink(inode) &&
-		!(IS_APPEND(inode) || IS_IMMUTABLE(inode));
+        if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+                return 0;
+        if (S_ISREG(inode->i_mode))
+                return 1;
+        if (S_ISDIR(inode->i_mode))
+                return 1;
+        if (S_ISLNK(inode->i_mode))
+                return !ext3_inode_is_fast_symlink(inode);
+        return 0;
 }
 
 /*

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
