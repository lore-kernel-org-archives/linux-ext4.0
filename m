From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Check dioread_nolock on remount
Date: Thu, 13 Dec 2012 22:40:42 +0100
Message-ID: <1355434842-13478-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2LMVkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 16:40:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we allow enabling dioread_nolock mount option on remount for
filesystems where blocksize < PAGE_CACHE_SIZE. This isn't really supported so
fix the bug by moving the check for blocksize != PAGE_CACHE_SIZE into
parse_options(). Change the original PAGE_SIZE to PAGE_CACHE_SIZE along the way
because that's what we are really interested in.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..9753ed2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1650,9 +1650,7 @@ static int parse_options(char *options, struct super_block *sb,
 			 unsigned int *journal_ioprio,
 			 int is_remount)
 {
-#ifdef CONFIG_QUOTA
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-#endif
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
@@ -1701,6 +1699,16 @@ static int parse_options(char *options, struct super_block *sb,
 		}
 	}
 #endif
+	if (test_opt(sb, DIOREAD_NOLOCK)) {
+		int blocksize =
+			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
+
+		if (blocksize < PAGE_CACHE_SIZE) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "dioread_nolock if block size != PAGE_SIZE");
+			return 0;
+		}
+	}
 	return 1;
 }
 
@@ -3446,15 +3454,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			clear_opt(sb, DELALLOC);
 	}
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
-	if (test_opt(sb, DIOREAD_NOLOCK)) {
-		if (blocksize < PAGE_SIZE) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "dioread_nolock if block size != PAGE_SIZE");
-			goto failed_mount;
-		}
-	}
