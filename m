From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.7
Date: Tue, 24 May 2016 12:29:24 -0400
Message-ID: <20160524162924.GA23194@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Note: there are some merge conflicts in the Direct I/O handling code.
The resolution of them is in linux-next, as well as here:

   http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=trial-merge

Also see below for the output of "git show trial-merge".  (I couldn't
figure out a way to generate this from the git web interface --- is
there a way?)

					- Ted


The following changes since commit c3b46c73264b03000d1e18b22f5caf63332547c9:

  Linux 4.6-rc4 (2016-04-17 19:13:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 12735f881952c32b31bc4e433768f18489f79ec9:

  ext4: pre-zero allocated blocks for DAX IO (2016-05-13 00:51:15 -0400)

----------------------------------------------------------------
Fix a number of bugs, most notably a potential stale data exposure
after a crash and a potential BUG_ON crash if a file has the data
journalling flag enabled while it has dirty delayed allocation blocks
that haven't been written yet.  Also fix a potential crash in the new
project quota code and a maliciously corrupted file system.

In addition, fix some DAX-specific bugs, including when there is a
transient ENOSPC situation and races between writes via direct I/O and
an mmap'ed segment that could lead to lost I/O.

Finally the usual set of miscellaneous cleanups.

----------------------------------------------------------------
Daeho Jeong (2):
      ext4: handle unwritten or delalloc buffers before enabling data journaling
      ext4: fix races between changing inode journal mode and ext4_writepages

Jakub Wilk (1):
      ext4: remove trailing \n from ext4_warning/ext4_error calls

Jan Kara (10):
      ext4: fix data exposure after a crash
      ext4: remove EXT4_STATE_ORDERED_MODE
      jbd2: add support for avoiding data writes during transaction commits
      ext4: do not ask jbd2 to write data for delalloc buffers
      ext4: fix oops on corrupted filesystem
      dax: call get_blocks() with create == 1 for write faults to unwritten extents
      ext4: handle transient ENOSPC properly for DAX
      ext4: fix race in transient ENOSPC detection
      ext4: refactor direct IO code
      ext4: pre-zero allocated blocks for DAX IO

Jens Axboe (1):
      ext4: remove unnecessary bio get/put

Luis de Bethencourt (1):
      jbd2: remove excess descriptions for handle_s

Nicolai Stange (3):
      ext4: address UBSAN warning in mb_find_order_for_block()
      ext4: silence UBSAN in ext4_mb_init()
      ext4: remove unmeetable inconsisteny check from ext4_find_extent()

Seth Forshee (1):
      ext4: fix check of dqget() return value in ext4_ioctl_setproject()

Theodore Ts'o (4):
      ext4: allow readdir()'s of large empty directories to be interrupted
      ext4: fix jbd2 handle extension in ext4_ext_truncate_extend_restart()
      ext4: fix hang when processing corrupted orphaned inode list
      ext4: clean up error handling when orphan list is corrupted

 fs/compat.c                   |   4 ++
 fs/dax.c                      |   2 +-
 fs/ext4/balloc.c              |   3 +-
 fs/ext4/dir.c                 |   5 ++
 fs/ext4/ext4.h                |  21 ++++--
 fs/ext4/ext4_jbd2.h           |  15 +++-
 fs/ext4/extents.c             |  20 +++---
 fs/ext4/extents_status.c      |   2 +-
 fs/ext4/file.c                |   6 +-
 fs/ext4/ialloc.c              |  59 ++++++++--------
 fs/ext4/indirect.c            | 127 ----------------------------------
 fs/ext4/inline.c              |   2 +-
 fs/ext4/inode.c               | 326 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 fs/ext4/ioctl.c               |   2 +-
 fs/ext4/mballoc.c             |  12 ++--
 fs/ext4/mmp.c                 |   4 +-
 fs/ext4/move_extent.c         |   2 +-
 fs/ext4/namei.c               |   9 ++-
 fs/ext4/page-io.c             |   2 -
 fs/ext4/resize.c              |   2 +-
 fs/ext4/super.c               |   4 ++
 fs/jbd2/commit.c              |   4 ++
 fs/jbd2/journal.c             |   3 +-
 fs/jbd2/transaction.c         |  22 ++++--
 fs/ocfs2/journal.h            |   2 +-
 fs/readdir.c                  |   4 ++
 include/linux/jbd2.h          |  16 +++--
 kernel/locking/percpu-rwsem.c |   1 +
 28 files changed, 366 insertions(+), 315 deletions(-)

--------------

commit 49cb72c1e6373ef999ea92aecb5479c3bb1ab654
Merge: f6c658d 12735f8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun May 22 22:19:57 2016 -0400

    Merge branch 'dev' into test

diff --cc fs/ext4/inode.c
index 79b298d,f9ab1e8..f7140ca
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -3334,12 -3327,13 +3327,13 @@@ static int ext4_end_io_dio(struct kioc
   * if the machine crashes during the write.
   *
   */
- static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 -static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter,
 -				    loff_t offset)
++static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
  {
  	struct file *file = iocb->ki_filp;
  	struct inode *inode = file->f_mapping->host;
+ 	struct ext4_inode_info *ei = EXT4_I(inode);
  	ssize_t ret;
 +	loff_t offset = iocb->ki_pos;
  	size_t count = iov_iter_count(iter);
  	int overwrite = 0;
  	get_block_t *get_block_func = NULL;
@@@ -3399,12 -3423,12 +3423,12 @@@
  #ifdef CONFIG_EXT4_FS_ENCRYPTION
  	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
  #endif
- 	if (IS_DAX(inode))
+ 	if (IS_DAX(inode)) {
 -		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
 +		ret = dax_do_io(iocb, inode, iter, get_block_func,
  				ext4_end_io_dio, dio_flags);
- 	else
+ 	} else
  		ret = __blockdev_direct_IO(iocb, inode,
 -					   inode->i_sb->s_bdev, iter, offset,
 +					   inode->i_sb->s_bdev, iter,
  					   get_block_func,
  					   ext4_end_io_dio, NULL, dio_flags);
  
@@@ -3428,6 -3451,82 +3451,81 @@@
  	if (overwrite)
  		inode_lock(inode);
  
+ 	if (ret < 0 && final_size > inode->i_size)
+ 		ext4_truncate_failed_write(inode);
+ 
+ 	/* Handle extending of i_size after direct IO write */
+ 	if (orphan) {
+ 		int err;
+ 
+ 		/* Credits for sb + inode write */
+ 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+ 		if (IS_ERR(handle)) {
+ 			/* This is really bad luck. We've written the data
+ 			 * but cannot extend i_size. Bail out and pretend
+ 			 * the write failed... */
+ 			ret = PTR_ERR(handle);
+ 			if (inode->i_nlink)
+ 				ext4_orphan_del(NULL, inode);
+ 
+ 			goto out;
+ 		}
+ 		if (inode->i_nlink)
+ 			ext4_orphan_del(handle, inode);
+ 		if (ret > 0) {
+ 			loff_t end = offset + ret;
+ 			if (end > inode->i_size) {
+ 				ei->i_disksize = end;
+ 				i_size_write(inode, end);
+ 				/*
+ 				 * We're going to return a positive `ret'
+ 				 * here due to non-zero-length I/O, so there's
+ 				 * no way of reporting error returns from
+ 				 * ext4_mark_inode_dirty() to userspace.  So
+ 				 * ignore it.
+ 				 */
+ 				ext4_mark_inode_dirty(handle, inode);
+ 			}
+ 		}
+ 		err = ext4_journal_stop(handle);
+ 		if (ret == 0)
+ 			ret = err;
+ 	}
+ out:
+ 	return ret;
+ }
+ 
 -static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter,
 -				   loff_t offset)
++static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
+ {
+ 	int unlocked = 0;
+ 	struct inode *inode = iocb->ki_filp->f_mapping->host;
+ 	ssize_t ret;
+ 
+ 	if (ext4_should_dioread_nolock(inode)) {
+ 		/*
+ 		 * Nolock dioread optimization may be dynamically disabled
+ 		 * via ext4_inode_block_unlocked_dio(). Check inode's state
+ 		 * while holding extra i_dio_count ref.
+ 		 */
+ 		inode_dio_begin(inode);
+ 		smp_mb();
+ 		if (unlikely(ext4_test_inode_state(inode,
+ 						    EXT4_STATE_DIOREAD_LOCK)))
+ 			inode_dio_end(inode);
+ 		else
+ 			unlocked = 1;
+ 	}
+ 	if (IS_DAX(inode)) {
 -		ret = dax_do_io(iocb, inode, iter, offset, ext4_dio_get_block,
++		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block,
+ 				NULL, unlocked ? 0 : DIO_LOCKING);
+ 	} else {
+ 		ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
 -					   iter, offset, ext4_dio_get_block,
++					   iter, ext4_dio_get_block,
+ 					   NULL, NULL,
+ 					   unlocked ? 0 : DIO_LOCKING);
+ 	}
+ 	if (unlocked)
+ 		inode_dio_end(inode);
  	return ret;
  }
  
@@@ -3455,10 -3554,10 +3553,10 @@@ static ssize_t ext4_direct_IO(struct ki
  		return 0;
  
  	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
- 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
- 		ret = ext4_ext_direct_IO(iocb, iter);
+ 	if (iov_iter_rw(iter) == READ)
 -		ret = ext4_direct_IO_read(iocb, iter, offset);
++		ret = ext4_direct_IO_read(iocb, iter);
  	else
- 		ret = ext4_ind_direct_IO(iocb, iter);
 -		ret = ext4_direct_IO_write(iocb, iter, offset);
++		ret = ext4_direct_IO_write(iocb, iter);
  	trace_ext4_direct_IO_exit(inode, offset, count, iov_iter_rw(iter), ret);
  	return ret;
  }
