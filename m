From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 23:17:04 -0400
Message-ID: <20121008031704.17730.qmail@science.horizon.com>
References: <20121008024126.GC468@thunk.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:22542 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751211Ab2JHDRG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 23:17:06 -0400
In-Reply-To: <20121008024126.GC468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm testing that patch, but you may want to fix it a bit more before submitting to
stable@...
fs/ext4/resize.c: In function 'update_backups':
fs/ext4/resize.c:973:39: error: too many arguments to function 'ext4_superblock_csum_set'
In file included from fs/ext4/ext4_jbd2.h:20:0,
                 from fs/ext4/resize.c:17:
fs/ext4/ext4.h:2049:13: note: declared here

The fix is of course obvious and I'm compiling it now.

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 41f6ef6..e781259 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -970,7 +970,7 @@ static void update_backups(struct super_block *sb,
 		goto exit_err;
 	}
 
-	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
+	ext4_superblock_csum_set(sb);
 
 	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
 		struct buffer_head *bh;
