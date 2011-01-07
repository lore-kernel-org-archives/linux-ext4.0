From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: flush the i_completed_io_list during ext4_truncate
Date: Fri,  7 Jan 2011 18:43:31 -0500
Message-ID: <1294443811-28382-1-git-send-email-tytso@mit.edu>
References: <20101130012228.2144B42716@ruihe.smo.corp.google.com>
Cc: Jiaying Zhang <jiayingz@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41688 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1AGXnf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 18:43:35 -0500
In-Reply-To: <20101130012228.2144B42716@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: jiayingz@google.com (Jiaying Zhang) <>

Ted first found the bug when running 2.6.36 kernel with dioread_nolock
mount option that xfstests #13 complained about wrong file size during fsck.
However, the bug exists in the older kernels as well although it is
somehow harder to trigger.

The problem is that ext4_end_io_work() can happen after we have truncated an
inode to a smaller size. Then when ext4_end_io_work() calls
ext4_convert_unwritten_extents(), we may reallocate some blocks that have
been truncated, so the inode size becomes inconsistent with the allocated
blocks.

The following patch flushes the i_completed_io_list during truncate to reduce
the risk that some pending end_io requests are executed later and convert
already truncated blocks to initialized.

Note that although the fix helps reduce the problem a lot there may still
be a race window between vmtruncate() and ext4_end_io_work(). The fundamental
problem is that if vmtruncate() is called without either i_mutex or i_alloc_sem
held, it can race with an ongoing write request so that the io_end request is
processed later when the corresponding blocks have been truncated.

Ted and I have discussed the problem offline and we saw a few ways to fix
the race completely:

a) We guarantee that i_mutex lock and i_alloc_sem write lock are both hold
whenever vmtruncate() is called. The i_mutex lock prevents any new write
requests from entering writeback and the i_alloc_sem prevents the race
from ext4_page_mkwrite(). Currently we hold both locks if vmtruncate()
is called from do_truncate(), which is probably the most common case.
However, there are places where we may call vmtruncate() without holding
either i_mutex or i_alloc_sem. I would like to ask for other people's
opinions on what locks are expected to be held before calling vmtruncate().
There seems a disagreement among the callers of that function.

b) We change the ext4 write path so that we change the extent tree to contain
the newly allocated blocks and update i_size both at the same time --- when
the write of the data blocks is completed.

c) We add some additional locking to synchronize vmtruncate() and
ext4_end_io_work(). This approach may have performance implications so we
need to be careful.

All of the above proposals may require more substantial changes, so
we may consider to take the following patch as a bandaid.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

I had to make some changes to make this patch apply to the latest ext4
tree, since flush_completed_IO() has been moved to fsync.c.

 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |    6 ++++++
 fs/ext4/fsync.c   |    4 ++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2d20424..4bb3ef7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1663,6 +1663,7 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, int);
+extern int ext4_flush_completed_IO(struct inode *);
 
 /* hash.c */
 extern int ext4fs_dirhash(const char *name, int len, struct
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a643b50..919c13b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3534,6 +3534,12 @@ void ext4_ext_truncate(struct inode *inode)
 	int err = 0;
 
 	/*
+	 * finish any pending end_io work so we won't run the risk of
+	 * converting any truncated blocks to initialized later
+	 */
+	ext4_flush_completed_IO(inode);
+
+	/*
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c1a7bc9..7829b28 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -75,7 +75,7 @@ static void dump_completed_IO(struct inode * inode)
  * to written.
  * The function return the number of pending IOs on success.
  */
-static int flush_completed_IO(struct inode *inode)
+extern int ext4_flush_completed_IO(struct inode *inode)
 {
 	ext4_io_end_t *io;
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -169,7 +169,7 @@ int ext4_sync_file(struct file *file, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
-	ret = flush_completed_IO(inode);
+	ret = ext4_flush_completed_IO(inode);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.3.1

