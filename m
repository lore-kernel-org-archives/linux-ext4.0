From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 42/53] ext4: init statistics after journal recovery
Date: Sun, 30 May 2010 22:49:55 -0400
Message-ID: <1275274206-3900-42-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44548 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 84061e07c5fbbbf9dc8aef8fb750fc3a2dfc31f3 upstream (as of v2.6.34-git13)

Currently block/inode/dir counters initialized before journal was
recovered. In fact after journal recovery this info will probably
change. And freeblocks it critical for correct delalloc mode
accounting.

https://bugzilla.kernel.org/show_bug.cgi?id=15768

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d85549c..bf3ca2c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2695,24 +2695,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -2832,7 +2814,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 no_journal:
-
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
+				  ext4_count_free_blocks(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_freeinodes_counter,
+					  ext4_count_free_inodes(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirs_counter,
+					  ext4_count_dirs(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	if (err) {
+		ext4_msg(sb, KERN_ERR, "insufficient memory");
+		goto failed_mount_wq;
+	}
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
 			ext4_msg(sb, KERN_WARNING, "Ignoring nobh option - "
@@ -2965,6 +2960,10 @@ failed_mount_wq:
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
@@ -2972,10 +2971,6 @@ failed_mount3:
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
1.6.6.1.1.g974db.dirty

