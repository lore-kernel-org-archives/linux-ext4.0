From: Nick Piggin <npiggin@kernel.dk>
Subject: [patch] fix up lock order reversal in writeback
Date: Tue, 16 Nov 2010 22:00:58 +1100
Message-ID: <20101116110058.GA4298@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I saw a lock order warning on ext4 trigger. This should solve it.
Raciness shouldn't matter much, because writeback can stop just
after we make the test and return anyway (so the API is racy anyway).

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-11-16 21:44:32.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-11-16 21:49:37.000000000 +1100
@@ -1125,16 +1125,20 @@ EXPORT_SYMBOL(writeback_inodes_sb);
  *
  * Invoke writeback_inodes_sb if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
+ *
+ * May be called inside i_lock. May not start writeback if locks cannot
+ * be acquired.
  */
 int writeback_inodes_sb_if_idle(struct super_block *sb)
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb(sb);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+		if (down_read_trylock(&sb->s_umount)) {
+			writeback_inodes_sb(sb);
+			up_read(&sb->s_umount);
+			return 1;
+		}
+	}
+	return 0;
 }
 EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
 
@@ -1145,17 +1149,21 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
  *
  * Invoke writeback_inodes_sb if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
+ *
+ * May be called inside i_lock. May not start writeback if locks cannot
+ * be acquired.
  */
 int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
 				   unsigned long nr)
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb_nr(sb, nr);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+		if (down_read_trylock(&sb->s_umount)) {
+			writeback_inodes_sb_nr(sb, nr);
+			up_read(&sb->s_umount);
+			return 1;
+		}
+	}
+	return 0;
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
 
