From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Date: Wed, 8 Oct 2008 23:00:54 -0400
Message-ID: <20081009030054.GD17512@mit.edu>
References: <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002061236.3c71c877@infradead.org> <20081002132457.46ad8d05.akpm@linux-foundation.org> <20081002210117.0f5062f7@infradead.org> <20081002212355.621a4fb6@infradead.org> <20081002214000.89420bb3.akpm@linux-foundation.org> <20081002214353.30873f98@infradead.org> <20081002215026.a63ba0d0.akpm@linux-foundation.org> <20081002220040.7963596c@infradead.org> <20081002222438.8f9f90a2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55933 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757443AbYJIDBJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2008 23:01:09 -0400
Content-Disposition: inline
In-Reply-To: <20081002222438.8f9f90a2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2008 at 10:24:38PM -0700, Andrew Morton wrote:
> 
> Mount a junk partition with `-oakpm' and run some benchmarks.  If the
> results are "wow" then it's worth spending time on.  If the results are
> "meh" then we can not bother..
> 

I've ported the patch to the ext4 filesystem, and dropped it into the
unstable portion of the ext4 patch queue.  If we can get someone (hi,
Ric!) to run fs_mark with and without -o akpm_lock_hack, I suspect we
will find that it makes quite a large difference on that particular
benchmark, since it is fsync-heavy to force a large number of
transaction, and the creation of the inodes should cause multiple
blocks that will be entangled between the current and committing
transactions.

	      	     	     	      	      	 - Ted

ext4: akpm's locking hack to fix locking delays

This is a port of the following patch from Andrew Morton to ext4:

	http://lkml.org/lkml/2008/10/3/22

This fixes a major contention problem in do_get_write_access() when a
buffer is modified in both the current and committing transaction.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: akpm@linux-foundation.org
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f46a513..23822fb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -540,6 +540,7 @@ do {									       \
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
+#define EXT4_MOUNT_AKPM_LOCK_HACK	0x10000000 /* akpm lock hack */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 67ebefb..f4e7157 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -752,6 +752,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",journal_async_commit");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
+	if (test_opt(sb, AKPM_LOCK_HACK))
+		seq_puts(seq, ",akpm_lock_hack");
 	if (!test_opt(sb, EXTENTS))
 		seq_puts(seq, ",noextents");
 	if (test_opt(sb, I_VERSION))
@@ -911,7 +913,7 @@ enum {
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
 	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc, Opt_nodelalloc,
-	Opt_inode_readahead_blks
+	Opt_inode_readahead_blks, Opt_akpm_lock_hack,
 };
 
 static match_table_t tokens = {
@@ -973,6 +975,7 @@ static match_table_t tokens = {
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
+	{Opt_akpm_lock_hack, "akpm_lock_hack"},
 	{Opt_err, NULL},
 };
 
@@ -1382,6 +1385,9 @@ set_qf_format:
 				return 0;
 			sbi->s_inode_readahead_blks = option;
 			break;
+		case Opt_akpm_lock_hack:
+			set_opt(sbi->s_mount_opt, AKPM_LOCK_HACK);
+			break;
 		default:
 			printk(KERN_ERR
 			       "EXT4-fs: Unrecognized mount option \"%s\" "
@@ -2534,6 +2540,10 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
 		journal->j_flags |= JBD2_BARRIER;
 	else
 		journal->j_flags &= ~JBD2_BARRIER;
+	if (test_opt(sb, AKPM_LOCK_HACK))
+		journal->j_flags |= JBD2_LOCK_HACK;
+	else
+		journal->j_flags &= ~JBD2_LOCK_HACK;
 	spin_unlock(&journal->j_state_lock);
 }
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e5d5405..32c288a 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -546,6 +546,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	int error;
 	char *frozen_buffer = NULL;
 	int need_copy = 0;
+	int locked = 0;
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
@@ -561,7 +562,13 @@ repeat:
 
 	/* @@@ Need to check for errors here at some point. */
 
-	lock_buffer(bh);
+	if (journal->j_flags & JBD2_LOCK_HACK) {
+		if (trylock_buffer(bh))
+			locked = 1;	/* lolz */
+	} else {
+		lock_buffer(bh);
+		locked = 1;
+	}
 	jbd_lock_bh_state(bh);
 
 	/* We now hold the buffer lock so it is safe to query the buffer
@@ -600,7 +607,8 @@ repeat:
 		jbd_unexpected_dirty_buffer(jh);
 	}
 
-	unlock_buffer(bh);
+	if (locked)
+		unlock_buffer(bh);
 
 	error = -EROFS;
 	if (is_handle_aborted(handle)) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 66c3499..c614dae 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -967,6 +967,7 @@ struct journal_s
 #define JBD2_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JBD2_LOADED	0x010	/* The journal superblock has been loaded */
 #define JBD2_BARRIER	0x020	/* Use IDE barriers */
+#define JBD2_LOCK_HACK	0x040	/* akpm's locking hack */
 
 /*
  * Function declarations for the journaling transaction and buffer
