From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 17/20] ext4: wait on all pending commits in ext4_sync_fs()
Date: Sun, 16 Nov 2008 11:05:37 -0500
Message-ID: <1226851540-8032-18-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
 <1226851540-8032-14-git-send-email-tytso@mit.edu>
 <1226851540-8032-15-git-send-email-tytso@mit.edu>
 <1226851540-8032-16-git-send-email-tytso@mit.edu>
 <1226851540-8032-17-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59022 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753538AbYKPQXn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:23:43 -0500
In-Reply-To: <1226851540-8032-17-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_sync_fs, we only wait for a commit to finish if we started it,
but there may be one already in progress which will not be synced.

In the case of a data=ordered umount with pending long symlinks which
are delayed due to a long list of other I/O on the backing block
device, this causes the buffer associated with the long symlinks to
not be moved to the inode dirty list in the second phase of
fsync_super.  Then, before they can be dirtied again, kjournald exits,
seeing the UMOUNT flag and the dirty pages are never written to the
backing block device, causing long symlink corruption and exposing new
or previously freed block data to userspace.

To ensure all commits are synced, we flush all journal commits now
when sync_fs'ing ext4.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
(cherry picked from commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184)
---
 fs/ext4/super.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b6fdc2b..7726e8e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2920,12 +2920,9 @@ int ext4_force_commit(struct super_block *sb)
 /*
  * Ext4 always journals updates to the superblock itself, so we don't
  * have to propagate any other updates to the superblock on disk at this
- * point.  Just start an async writeback to get the buffers on their way
- * to the disk.
- *
- * This implicitly triggers the writebehind on sync().
+ * point.  (We can probably nuke this function altogether, and remove
+ * any mention to sb->s_dirt in all of fs/ext4; eventual cleanup...)
  */
-
 static void ext4_write_super(struct super_block *sb)
 {
 	if (mutex_trylock(&sb->s_lock) != 0)
@@ -2935,14 +2932,14 @@ static void ext4_write_super(struct super_block *sb)
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
+	int ret = 0;
 
 	sb->s_dirt = 0;
-	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
-		if (wait)
-			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
-	}
-	return 0;
+	if (wait)
+		ret = ext4_force_commit(sb);
+	else
+		jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	return ret;
 }
 
 /*
-- 
1.6.0.4.8.g36f27.dirty

