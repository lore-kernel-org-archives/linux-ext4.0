From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: init statistics after journal recovery
Date: Mon, 12 Apr 2010 15:48:10 +0400
Message-ID: <1271072890-5404-2-git-send-email-dmonakhov@openvz.org>
References: <1271072890-5404-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53596 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0DLLs0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 07:48:26 -0400
Received: by bwz19 with SMTP id 19so1413bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 04:48:24 -0700 (PDT)
In-Reply-To: <1271072890-5404-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently block/inode/dir counters initialized before journal was
recovered. In fact after journal recovery this info will probably
change. And freeblocks it critical for correct delalloc mode
accounting.
BUG:#15768

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 29c6875..17cb785 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2793,24 +2793,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	err = percpu_counter_init(&sbi->s_freeblocks_counter,
-			ext4_count_free_blocks(sb));
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_freeinodes_counter,
-				ext4_count_free_inodes(sb));
-	}
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_dirs_counter,
-				ext4_count_dirs(sb));
-	}
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
-	}
-	if (err) {
-		ext4_msg(sb, KERN_ERR, "insufficient memory");
-		goto failed_mount3;
-	}
-
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
 
@@ -2859,6 +2841,24 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto no_journal;
 	}
 
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
+			ext4_count_free_blocks(sb));
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_freeinodes_counter,
+				ext4_count_free_inodes(sb));
+	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirs_counter,
+				ext4_count_dirs(sb));
+	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	}
+	if (err) {
+		ext4_msg(sb, KERN_ERR, "insufficient memory");
+		goto failed_mount_wq;
+	}
+
 	if (ext4_blocks_count(es) > 0xffffffffULL &&
 	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
 				       JBD2_FEATURE_INCOMPAT_64BIT)) {
@@ -3059,6 +3059,10 @@ failed_mount_wq:
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 	}
+	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	percpu_counter_destroy(&sbi->s_freeinodes_counter);
+	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount3:
 	if (sbi->s_flex_groups) {
 		if (is_vmalloc_addr(sbi->s_flex_groups))
@@ -3066,10 +3070,6 @@ failed_mount3:
 		else
 			kfree(sbi->s_flex_groups);
 	}
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
-	percpu_counter_destroy(&sbi->s_freeinodes_counter);
-	percpu_counter_destroy(&sbi->s_dirs_counter);
-	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-- 
1.6.6.1

