From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext3: init statistics after journal recovery
Date: Mon, 12 Apr 2010 23:12:55 +0400
Message-ID: <1271099576-7507-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63203 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0DLTNM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 15:13:12 -0400
Received: by bwz19 with SMTP id 19so4163bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 12:13:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently block/inode/dir counters initialized before journal was
recovered. In fact after journal recovery this info will probably
change. And freeblocks it critical for correct delalloc mode
accounting.
BUG:#15768

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index e844acc..613b5ed 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1890,21 +1890,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	err = percpu_counter_init(&sbi->s_freeblocks_counter,
-			ext3_count_free_blocks(sb));
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_freeinodes_counter,
-				ext3_count_free_inodes(sb));
-	}
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_dirs_counter,
-				ext3_count_dirs(sb));
-	}
-	if (err) {
-		ext3_msg(sb, KERN_ERR, "error: insufficient memory");
-		goto failed_mount3;
-	}
-
 	/* per fileystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
 	sbi->s_rsv_window_root = RB_ROOT;
@@ -1945,16 +1930,30 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	if (!test_opt(sb, NOLOAD) &&
 	    EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		if (ext3_load_journal(sb, es, journal_devnum))
-			goto failed_mount3;
+			goto failed_mount2;
 	} else if (journal_inum) {
 		if (ext3_create_journal(sb, es, journal_inum))
-			goto failed_mount3;
+			goto failed_mount2;
 	} else {
 		if (!silent)
 			ext3_msg(sb, KERN_ERR,
 				"error: no journal found. "
 				"mounting ext3 over ext2?");
-		goto failed_mount3;
+		goto failed_mount2;
+	}
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
+			ext3_count_free_blocks(sb));
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_freeinodes_counter,
+				ext3_count_free_inodes(sb));
+	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirs_counter,
+				ext3_count_dirs(sb));
+	}
+	if (err) {
+		ext3_msg(sb, KERN_ERR, "error: insufficient memory");
+		goto failed_mount4;
 	}
 
 	/* We have now updated the journal if required, so we can
@@ -2040,11 +2039,10 @@ cantfind_ext3:
 	goto failed_mount;
 
 failed_mount4:
-	journal_destroy(sbi->s_journal);
-failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	journal_destroy(sbi->s_journal);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-- 
1.6.6.1

