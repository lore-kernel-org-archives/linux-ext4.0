From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 18:12:09 -0500
Message-ID: <20081103231209.GA29964@mit.edu>
References: <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org> <20081103211929.GA18117@mit.edu> <20081103132735.9e63a3d0.akpm@linux-foundation.org> <20081103220144.GD18117@mit.edu> <20081103142706.92e3a2ae.akpm@linux-foundation.org> <20081103225544.GH18117@mit.edu> <20081103230104.GC3371@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44273 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbYKCXMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 18:12:49 -0500
Content-Disposition: inline
In-Reply-To: <20081103230104.GC3371@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 03:01:04PM -0800, Arthur Jones wrote:
> 
> Same problem as the last one, jbd2_journal_start_commit returns
> true if it started a commit, not an error...

Ah, right.  !@#! differing return conventions....

BTW, did you ever open a bugzilla entry for this the symlink
corruption problem that we should reference in the commit log?

					- Ted

commit fd7384f8243a957386af3767532d035346f0d149
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Nov 3 18:10:55 2008 -0500

    ext4: wait on all pending commits in ext4_sync_fs()
    
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

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 97cb896..9e7e66c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2907,12 +2907,9 @@ int ext4_force_commit(struct super_block *sb)
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
@@ -2922,15 +2919,15 @@ static void ext4_write_super(struct super_block *sb)
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
+	int ret = 0;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
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
