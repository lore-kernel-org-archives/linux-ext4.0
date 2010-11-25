From: Nick Piggin <npiggin@kernel.dk>
Subject: [RFC][PATCH] Possible data integrity problems in lots of
 filesystems?
Date: Thu, 25 Nov 2010 18:49:09 +1100
Message-ID: <20101125074909.GA4160@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Boaz Harrosh <bharrosh@panasas.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:27442 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765Ab0KYHtS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Nov 2010 02:49:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a call for review and comments from all filesystem developers.
Not just those cced, but everyone who maintains a filesystem[*], because
I wasn't able to put in a lot of time to understand the more complex
filesystems.

[*] You all read linux-fsdevel anyway, right? If not, please do, it's
pretty low volume and high s/n.

So there seem to be several problems with inode data and metadata
synchronization. Some of it is bugs in core code, but also a couple
of oft repeated bugs in filesystems.

http://marc.info/?l=linux-fsdevel&m=129052164315259&w=2

Basically 2 patterns of problem.

First is checking inode dirty bits
(I_DIRTY/I_DIRTY_SYNC/I_DIRTY_DATASYNC) without locking. What happens is
that other paths (async writeout or even a concurrent sync or fsync) can
clear these bits with the data not being on platter.

* solution: must wait on I_SYNC before testing these things. See my
  patch in above linked series. I think I covered everyone here, but
  please double check.

* There is opportunity in some filesystems for clearing inode dirty bits
  in fsync, and for checking and avoiding fsync work if dirty bits are
  not sure.

Second is confusing sync and async inode metadata writeout
Core code clears I_DIRTY_SYNC and I_DIRTY_DATASYNC before calling
->write_inode *regardless* of whether it is a for-integrity call or
not. This means background writeback can clear it, and subsequent
sync_inode_metadata or sync(2) call will skip the next ->write_inode
completely.

* solution: for fsync, you must ensure that everything that a
  synchronous ->write_inode call does is also done by an
  asynchronous ->write_inode call *plus* a subsequent fsync.

  So if a synchronous ->write_inode syncs a bh, but an async one
  just marks it dirty, your .fsync would have to sync the bh.

* solution: for sync(2), you must ensure that everything that a
  synchronous ->write_inode call does is also done by an
  asynchronous ->write_inode call plus a subsequent ->sync_fs
  call, plus __sync_blockdev call on the buffer mapping.

  Many simple filesystems just go via buffer mapping, and
  ->write_inode simply dirties the inode's bh. These guys are
  fine here (although most are broken wrt fsync).

If you need any more state bits in your inode to work out what is going
on, Christoph's recent hfsplus fsync optimisation patches has a good
example of how it can be done.

The ext2 fix below is an example of how we can do this nicely, the
rest of the filesystems I note when it looks like they went wrong, and
band aid fixed it.

---
 adfs/inode.c     |    2 +-
 affs/file.c      |    1 +
 bfs/inode.c      |    2 +-
 exofs/inode.c    |    2 +-
 ext2/ext2.h      |    2 ++
 ext2/file.c      |   24 +++++++++++++++++++++---
 ext2/inode.c     |   12 ++----------
 ext4/inode.c     |    2 +-
 fat/inode.c      |    2 +-
 jfs/inode.c      |    2 +-
 minix/inode.c    |    2 +-
 omfs/inode.c     |    2 +-
 reiserfs/inode.c |    2 ++
 sysv/inode.c     |    2 +-
 udf/inode.c      |    2 +-
 ufs/inode.c      |    2 +-
 16 files changed, 39 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2010-11-24 11:29:42.000000000 +1100
+++ linux-2.6/fs/ext2/inode.c	2010-11-25 17:22:49.000000000 +1100
@@ -1211,7 +1211,7 @@ static int ext2_setsize(struct inode *in
 	return 0;
 }
 
-static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
+struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
 					struct buffer_head **p)
 {
 	struct buffer_head * bh;
@@ -1505,16 +1505,8 @@ static int __ext2_write_inode(struct ino
 	} else for (n = 0; n < EXT2_N_BLOCKS; n++)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
-	if (do_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
-				sb->s_id, (unsigned long) ino);
-			err = -EIO;
-		}
-	}
-	ei->i_state &= ~EXT2_STATE_NEW;
 	brelse (bh);
+	ei->i_state &= ~EXT2_STATE_NEW;
 	return err;
 }
 
Index: linux-2.6/fs/ext2/file.c
===================================================================
--- linux-2.6.orig/fs/ext2/file.c	2010-11-24 11:29:42.000000000 +1100
+++ linux-2.6/fs/ext2/file.c	2010-11-24 12:23:53.000000000 +1100
@@ -21,6 +21,7 @@
 #include <linux/time.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
+#include <linux/buffer_head.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -43,16 +44,33 @@ static int ext2_release_file (struct ino
 int ext2_fsync(struct file *file, int datasync)
 {
 	int ret;
-	struct super_block *sb = file->f_mapping->host->i_sb;
-	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+	struct inode *inode = file->f_mapping->host;
+	ino_t ino = inode->i_ino;
+	struct super_block *sb = inode->i_sb;
+	struct address_space *sb_mapping = sb->s_bdev->bd_inode->i_mapping;
+	struct buffer_head *bh;
+	struct ext2_inode *raw_inode;
 
 	ret = generic_file_fsync(file, datasync);
-	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+	if (ret == -EIO || test_and_clear_bit(AS_EIO, &sb_mapping->flags)) {
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
 			   "detected IO error when writing metadata buffers");
+		return -EIO;
+	}
+
+	raw_inode = ext2_get_inode(sb, ino, &bh);
+	if (IS_ERR(raw_inode))
+ 		return -EIO;
+
+	sync_dirty_buffer(bh);
+	if (buffer_req(bh) && !buffer_uptodate(bh)) {
+		printk ("IO error syncing ext2 inode [%s:%08lx]\n",
+			sb->s_id, (unsigned long) ino);
 		ret = -EIO;
 	}
+	brelse (bh);
+
 	return ret;
 }
 
Index: linux-2.6/fs/ext2/ext2.h
===================================================================
--- linux-2.6.orig/fs/ext2/ext2.h	2010-11-24 11:29:42.000000000 +1100
+++ linux-2.6/fs/ext2/ext2.h	2010-11-24 12:23:53.000000000 +1100
@@ -124,6 +124,8 @@ extern int ext2_get_block(struct inode *
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern void ext2_get_inode_flags(struct ext2_inode_info *);
+extern struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
+					struct buffer_head **p);
 extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
 
Index: linux-2.6/fs/adfs/inode.c
===================================================================
--- linux-2.6.orig/fs/adfs/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/adfs/inode.c	2010-11-25 17:30:08.000000000 +1100
@@ -383,7 +383,7 @@ int adfs_write_inode(struct inode *inode
 	obj.attr	= ADFS_I(inode)->attr;
 	obj.size	= inode->i_size;
 
-	ret = adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
+	ret = adfs_dir_update(sb, &obj, 1 /* XXX: fix fsync and use 'wbc->sync_mode == WB_SYNC_ALL' */);
 	unlock_kernel();
 	return ret;
 }
Index: linux-2.6/fs/affs/file.c
===================================================================
--- linux-2.6.orig/fs/affs/file.c	2010-11-25 17:31:12.000000000 +1100
+++ linux-2.6/fs/affs/file.c	2010-11-25 17:31:30.000000000 +1100
@@ -931,6 +931,7 @@ int affs_file_fsync(struct file *filp, i
 	int ret, err;
 
 	ret = write_inode_now(inode, 0);
+	/* XXX: could just sync the buffer been dirtied by write_inode */
 	err = sync_blockdev(inode->i_sb->s_bdev);
 	if (!ret)
 		ret = err;
Index: linux-2.6/fs/bfs/inode.c
===================================================================
--- linux-2.6.orig/fs/bfs/inode.c	2010-11-25 17:23:40.000000000 +1100
+++ linux-2.6/fs/bfs/inode.c	2010-11-25 17:32:26.000000000 +1100
@@ -151,7 +151,7 @@ static int bfs_write_inode(struct inode
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
 	mark_buffer_dirty(bh);
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (1 /* XXX: fix fsync and use wbc->sync_mode == WB_SYNC_ALL */ ) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh))
 			err = -EIO;
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-11-25 17:36:32.000000000 +1100
@@ -1273,7 +1273,7 @@ static int exofs_update_inode(struct ino
 
 int exofs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return exofs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return exofs_update_inode(inode, 1 /* XXX: fix fsync and use wbc->sync_mode == WB_SYNC_ALL */ );
 }
 
 /*
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/ext4/inode.c	2010-11-25 17:40:37.000000000 +1100
@@ -5240,7 +5240,7 @@ int ext4_write_inode(struct inode *inode
 		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
-		if (wbc->sync_mode == WB_SYNC_ALL)
+		if (1 /* XXX: fix fxync and use wbc->sync_mode == WB_SYNC_ALL */)
 			sync_dirty_buffer(iloc.bh);
 		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, iloc.bh->b_blocknr,
Index: linux-2.6/fs/fat/inode.c
===================================================================
--- linux-2.6.orig/fs/fat/inode.c	2010-11-25 17:23:40.000000000 +1100
+++ linux-2.6/fs/fat/inode.c	2010-11-25 17:42:04.000000000 +1100
@@ -645,7 +645,7 @@ static int __fat_write_inode(struct inod
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
 	err = 0;
-	if (wait)
+	if (1 /* XXX: fix fsync and use wait */)
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
 	return err;
Index: linux-2.6/fs/jfs/inode.c
===================================================================
--- linux-2.6.orig/fs/jfs/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/jfs/inode.c	2010-11-25 17:45:27.000000000 +1100
@@ -123,7 +123,7 @@ int jfs_commit_inode(struct inode *inode
 
 int jfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	int wait = wbc->sync_mode == WB_SYNC_ALL;
+	int wait = 1; /* XXX fix fsync and use wbc->sync_mode == WB_SYNC_ALL; */
 
 	if (test_cflag(COMMIT_Nolink, inode))
 		return 0;
Index: linux-2.6/fs/minix/inode.c
===================================================================
--- linux-2.6.orig/fs/minix/inode.c	2010-11-25 17:23:40.000000000 +1100
+++ linux-2.6/fs/minix/inode.c	2010-11-25 17:46:42.000000000 +1100
@@ -576,7 +576,7 @@ static int minix_write_inode(struct inod
 		bh = V2_minix_update_inode(inode);
 	if (!bh)
 		return -EIO;
-	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
+	if (1 /* XXX: fix fsync and use wbc->sync_mode == WB_SYNC_ALL */ && buffer_dirty(bh)) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk("IO error syncing minix inode [%s:%08lx]\n",
Index: linux-2.6/fs/omfs/inode.c
===================================================================
--- linux-2.6.orig/fs/omfs/inode.c	2010-11-25 17:23:40.000000000 +1100
+++ linux-2.6/fs/omfs/inode.c	2010-11-25 17:50:50.000000000 +1100
@@ -169,7 +169,7 @@ static int __omfs_write_inode(struct ino
 
 static int omfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return __omfs_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	return __omfs_write_inode(inode, 1 /* XXX: fix fsync and use wbc->sync_mode == WB_SYNC_ALL */);
 }
 
 int omfs_sync_inode(struct inode *inode)
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/reiserfs/inode.c	2010-11-25 17:53:45.000000000 +1100
@@ -1635,6 +1635,8 @@ int reiserfs_write_inode(struct inode *i
 	 ** these cases are just when the system needs ram, not when the
 	 ** inode needs to reach disk for safety, and they can safely be
 	 ** ignored because the altered inode has already been logged.
+	 ** XXX: is this really OK? The caller clears the inode dirty bit, so
+	 ** a subsequent sync for integrity might never reach here.
 	 */
 	if (wbc->sync_mode == WB_SYNC_ALL && !(current->flags & PF_MEMALLOC)) {
 		reiserfs_write_lock(inode->i_sb);
Index: linux-2.6/fs/sysv/inode.c
===================================================================
--- linux-2.6.orig/fs/sysv/inode.c	2010-11-25 17:23:40.000000000 +1100
+++ linux-2.6/fs/sysv/inode.c	2010-11-25 17:54:47.000000000 +1100
@@ -286,7 +286,7 @@ static int __sysv_write_inode(struct ino
 		write3byte(sbi, (u8 *)&si->i_data[block],
 			&raw_inode->i_data[3*block]);
 	mark_buffer_dirty(bh);
-	if (wait) {
+	if (1 /* XXX: fix fsync and use wait */) {
                 sync_dirty_buffer(bh);
                 if (buffer_req(bh) && !buffer_uptodate(bh)) {
                         printk ("IO error syncing sysv inode [%s:%08x]\n",
Index: linux-2.6/fs/udf/inode.c
===================================================================
--- linux-2.6.orig/fs/udf/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/udf/inode.c	2010-11-25 17:55:36.000000000 +1100
@@ -1598,7 +1598,7 @@ static int udf_update_inode(struct inode
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
-	if (do_sync) {
+	if (1 /* XXX fix fsync and use do_sync */) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
 			printk(KERN_WARNING "IO error syncing udf inode "
Index: linux-2.6/fs/ufs/inode.c
===================================================================
--- linux-2.6.orig/fs/ufs/inode.c	2010-11-25 17:25:54.000000000 +1100
+++ linux-2.6/fs/ufs/inode.c	2010-11-25 17:56:12.000000000 +1100
@@ -889,7 +889,7 @@ static int ufs_update_inode(struct inode
 	}
 		
 	mark_buffer_dirty(bh);
-	if (do_sync)
+	if (1 /* XXX: fix fsync and use do_sync */)
 		sync_dirty_buffer(bh);
 	brelse (bh);
 	
