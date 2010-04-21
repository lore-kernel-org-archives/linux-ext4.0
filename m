From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: init statistics after journal recovery v2
Date: Wed, 21 Apr 2010 16:03:06 -0400
Message-ID: <20100421200306.GI14986@thunk.org>
References: <1271099576-7507-1-git-send-email-dmonakhov@openvz.org>
 <1271099576-7507-2-git-send-email-dmonakhov@openvz.org>
 <20100412193728.GP3404@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53113 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0DUUDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 16:03:16 -0400
Content-Disposition: inline
In-Reply-To: <20100412193728.GP3404@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I've checked into the ext4 patch queue.  Fixes some
whitespace issues, and removed some unneeded curly braces.

	   	       	       	    - Ted

ext4: init statistics after journal recovery

From: Dmitry Monakhov <dmonakhov@openvz.org>

Currently block/inode/dir counters initialized before journal was
recovered. In fact after journal recovery this info will probably
change. And freeblocks it critical for correct delalloc mode
accounting.

https://bugzilla.kernel.org/show_bug.cgi?id=15768

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 00d09f5..d83cdcb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2794,24 +2794,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -2911,6 +2893,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 no_journal:
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
@@ -3060,6 +3056,10 @@ failed_mount_wq:
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
@@ -3067,10 +3067,6 @@ failed_mount3:
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
