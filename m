From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/4]ext4: Fix lock order problem in ext4_move_extents()
Date: Fri, 30 Oct 2009 16:41:56 +0900
Message-ID: <4AEA98C4.3070907@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40851 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZJ3Hnj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 03:43:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix lock order problem in ext4_move_extents()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

ext4_move_extents() checks the logical block contiguousness
of original file with ext4_find_extent() and mext_next_extent().
Therefore the extent which ext4_ext_path structure indicates
must not be changed between above functions.

But in current implementation, there is no i_data_sem protection
between ext4_ext_find_extent() and mext_next_extent().
So the extent which ext4_ext_path structure indicates may be overwritten by delalloc.
As a result, ext4_move_extents() will exchange wrong blocks
between original and donor files.
I change the place where acquire/release i_data_sem to solve this problem.

Moreover, I changed move_extent_per_page() to start transaction first,
and then acquire i_data_sem.
Without this change, there is a possibility of the deadlock
between mmap() and ext4_move_extents().
I got the dmesg in the end and the scenario of this problem
which I think about is as follows:

* NOTE: "A", "B" and "C" mean different processes

A-1: ext4_ext_move_extents() acquires i_data_sem of two inodes.

B:   do_page_fault() starts the transaction (T),
     and then tries to acquire i_data_sem.
     But process "A" is already holding it, so it is kept waiting.

C:   While "A" and "B" running, kjournald2 tries to commit transaction (T)
     but it is under updating, so kjournald2 waits for it.

A-2: Call ext4_journal_start with holding i_data_sem,
     but transaction (T) is locked.

Sep 25 15:02:02 bsdg9725 kernel: SysRq : Show Blocked State
Sep 25 15:02:02 bsdg9725 kernel:   task                PC stack   pid father
Sep 25 15:02:02 bsdg9725 kernel: kjournald2    D c103a83b     0  4989      2 0x00000000
Sep 25 15:02:02 bsdg9725 kernel:  c9b67e94 00000096 00000046 c103a83b d8ffafc0 d8ffb14c c2626c80 00000000
Sep 25 15:02:02 bsdg9725 kernel:  d0726280 00000246 c9b67e6c c9b67e88 00000246 c11166fb 00000001 00000246
Sep 25 15:02:02 bsdg9725 kernel:  d5832814 ce30e87c d5832814 d5832814 ce30e87c d5832974 c9b67f64 c1116700
Sep 25 15:02:02 bsdg9725 kernel: Call Trace:
Sep 25 15:02:02 bsdg9725 kernel:  [<c103a83b>] ? prepare_to_wait+0x17/0x45
Sep 25 15:02:02 bsdg9725 kernel:  [<c11166fb>] ? jbd2_journal_commit_transaction+0x24c/0x1595
Sep 25 15:02:02 bsdg9725 kernel:  [<c1116700>] jbd2_journal_commit_transaction+0x251/0x1595
Sep 25 15:02:02 bsdg9725 kernel:  [<c1030f8f>] ? lock_timer_base+0x1f/0x3e
Sep 25 15:02:02 bsdg9725 kernel:  [<c103a6bd>] ? autoremove_wake_function+0x0/0x33
Sep 25 15:02:02 bsdg9725 kernel:  [<c1030ff6>] ? try_to_del_timer_sync+0x48/0x4f
Sep 25 15:02:03 bsdg9725 kernel:  [<c1030ff6>] ? try_to_del_timer_sync+0x48/0x4f
Sep 25 15:02:03 bsdg9725 kernel:  [<c103134c>] ? del_timer_sync+0x5c/0x6c
Sep 25 15:02:03 bsdg9725 kernel:  [<c111c279>] kjournald2+0x134/0x32c
Sep 25 15:02:03 bsdg9725 kernel:  [<c103a6bd>] ? autoremove_wake_function+0x0/0x33
Sep 25 15:02:03 bsdg9725 kernel:  [<c111c145>] ? kjournald2+0x0/0x32c
Sep 25 15:02:03 bsdg9725 kernel:  [<c103a61f>] kthread+0x6e/0x73
Sep 25 15:02:03 bsdg9725 kernel:  [<c103a5b1>] ? kthread+0x0/0x73
Sep 25 15:02:03 bsdg9725 kernel:  [<c10034f7>] kernel_thread_helper+0x7/0x10
Sep 25 15:02:03 bsdg9725 kernel: mvext         D c103a83b     0  4996   4969 0x00000004
Sep 25 15:02:03 bsdg9725 kernel:  d336dd68 00000092 00000046 c103a83b d588afc0 d588b14c c2626c80 00000000
Sep 25 15:02:03 bsdg9725 kernel:  caa21400 00000246 ffff9701 ffffffff 00000246 c1115411 00000001 00000246
Sep 25 15:02:03 bsdg9725 kernel:  00000001 00000000 00000000 d5832898 d336dd84 d336dd98 d336dda4 c1115416
Sep 25 15:02:03 bsdg9725 kernel: Call Trace:
Sep 25 15:02:03 bsdg9725 kernel:  [<c103a83b>] ? prepare_to_wait+0x17/0x45
Sep 25 15:02:03 bsdg9725 kernel:  [<c1115411>] ? start_this_handle+0x2cb/0x4c7
Sep 25 15:02:03 bsdg9725 kernel:  [<c1115416>] start_this_handle+0x2d0/0x4c7
Sep 25 15:02:03 bsdg9725 kernel:  [<c103a6bd>] ? autoremove_wake_function+0x0/0x33
Sep 25 15:02:03 bsdg9725 kernel:  [<c11156ab>] jbd2_journal_start+0x9e/0xcd
Sep 25 15:02:03 bsdg9725 kernel:  [<c10f76f8>] ext4_journal_start_sb+0x44/0x64
Sep 25 15:02:03 bsdg9725 kernel:  [<c110a8c3>] ext4_move_extents+0x755/0xcfe
Sep 25 15:02:04 bsdg9725 kernel:  [<c10edc48>] ext4_ioctl+0x5b3/0x8a3
Sep 25 15:02:04 bsdg9725 kernel:  [<c106a481>] ? unlock_page+0x18/0x1b
Sep 25 15:02:04 bsdg9725 kernel:  [<c107a84c>] ? __do_fault+0x318/0x34b
Sep 25 15:02:04 bsdg9725 kernel:  [<c10ed695>] ? ext4_ioctl+0x0/0x8a3
Sep 25 15:02:04 bsdg9725 kernel:  [<c1099638>] vfs_ioctl+0x22/0x67
Sep 25 15:02:04 bsdg9725 kernel:  [<c1099b9d>] do_vfs_ioctl+0x46d/0x4b8
Sep 25 15:02:04 bsdg9725 kernel:  [<c13ce190>] ? do_page_fault+0x280/0x296
Sep 25 15:02:04 bsdg9725 kernel:  [<c103da84>] ? up_read+0x16/0x2a
Sep 25 15:02:04 bsdg9725 kernel:  [<c1099c14>] sys_ioctl+0x2c/0x45
Sep 25 15:02:04 bsdg9725 kernel:  [<c1002958>] sysenter_do_call+0x12/0x36
Sep 25 15:02:04 bsdg9725 kernel: mmap          D c9a4dcc0     0  4998   4969 0x00000004
Sep 25 15:02:04 bsdg9725 kernel:  c9a4dcf8 00000092 00000000 c9a4dcc0 d5888000 d588818c c2626c80 00000000
Sep 25 15:02:04 bsdg9725 kernel:  dea60500 00000046 c13cbc96 c9a4dcec 00000046 c13cbd8e 00000001 cd1ab170
Sep 25 15:02:04 bsdg9725 kernel:  cd1ab19c c9a4dcec c1047fb5 fffeffff cd1ab19c cd1ab16c c9a4dd18 c13cbd9c
Sep 25 15:02:04 bsdg9725 kernel: Call Trace:
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbc96>] ? rwsem_down_failed_common+0x2b/0x150
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbd8e>] ? rwsem_down_failed_common+0x123/0x150
Sep 25 15:02:04 bsdg9725 kernel:  [<c1047fb5>] ? trace_hardirqs_on+0xb/0xd
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbd9c>] rwsem_down_failed_common+0x131/0x150
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbdfb>] rwsem_down_read_failed+0x1d/0x26
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbe3f>] call_rwsem_down_read_failed+0x7/0xc
Sep 25 15:02:04 bsdg9725 kernel:  [<c10e9282>] ? ext4_get_blocks+0x2c/0x260
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cb600>] ? down_read+0x5e/0x6f
Sep 25 15:02:04 bsdg9725 kernel:  [<c10e9282>] ext4_get_blocks+0x2c/0x260
Sep 25 15:02:04 bsdg9725 kernel:  [<c10eccc8>] ext4_da_get_block_prep+0x97/0x1c6
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbfe0>] ? _spin_unlock+0x1d/0x20
Sep 25 15:02:04 bsdg9725 kernel:  [<c10aa3b0>] __block_prepare_write+0x13b/0x31b
Sep 25 15:02:04 bsdg9725 kernel:  [<c106a306>] ? find_get_page+0xa7/0xb1
Sep 25 15:02:04 bsdg9725 kernel:  [<c10aa62c>] block_write_begin+0x75/0xce
Sep 25 15:02:04 bsdg9725 kernel:  [<c10ecc31>] ? ext4_da_get_block_prep+0x0/0x1c6
Sep 25 15:02:04 bsdg9725 kernel:  [<c10ec6c9>] ext4_da_write_begin+0x180/0x21e
Sep 25 15:02:04 bsdg9725 kernel:  [<c10ecc31>] ? ext4_da_get_block_prep+0x0/0x1c6
Sep 25 15:02:04 bsdg9725 kernel:  [<c10eb389>] ext4_page_mkwrite+0x155/0x1a9
Sep 25 15:02:04 bsdg9725 kernel:  [<c107a68c>] __do_fault+0x158/0x34b
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cbfe0>] ? _spin_unlock+0x1d/0x20
Sep 25 15:02:04 bsdg9725 kernel:  [<c107bd88>] handle_mm_fault+0x21b/0x4b8
Sep 25 15:02:04 bsdg9725 kernel:  [<c103da2c>] ? down_read_trylock+0x39/0x43
Sep 25 15:02:04 bsdg9725 kernel:  [<c13ce134>] do_page_fault+0x224/0x296
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cdf10>] ? do_page_fault+0x0/0x296
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cc73b>] error_code+0x6b/0x70
Sep 25 15:02:04 bsdg9725 kernel:  [<c13cdf10>] ? do_page_fault+0x0/0x296



Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |  117 ++++++++++++++++++++++---------------------------
 1 files changed, 53 insertions(+), 64 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 83f8c9e..a7410b3 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -77,12 +77,14 @@ static int
 mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 		      struct ext4_extent **extent)
 {
+	struct ext4_extent_header *eh;
 	int ppos, leaf_ppos = path->p_depth;

 	ppos = leaf_ppos;
 	if (EXT_LAST_EXTENT(path[ppos].p_hdr) > path[ppos].p_ext) {
 		/* leaf block */
 		*extent = ++path[ppos].p_ext;
+		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
 		return 0;
 	}

@@ -119,9 +121,18 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 					ext_block_hdr(path[cur_ppos+1].p_bh);
 			}

+			path[leaf_ppos].p_ext = *extent = NULL;
+
+			eh = path[leaf_ppos].p_hdr;
+			if (le16_to_cpu(eh->eh_entries) == 0)
+				/* empty leaf is found */
+				return -ENODATA;
+
 			/* leaf block */
 			path[leaf_ppos].p_ext = *extent =
 				EXT_FIRST_EXTENT(path[leaf_ppos].p_hdr);
+			path[leaf_ppos].p_block =
+					ext_pblock(path[leaf_ppos].p_ext);
 			return 0;
 		}
 	}
@@ -155,40 +166,15 @@ mext_check_null_inode(struct inode *inode1, struct inode *inode2,
 }

 /**
- * mext_double_down_read - Acquire two inodes' read semaphore
- *
- * @orig_inode:		original inode structure
- * @donor_inode:	donor inode structure
- * Acquire read semaphore of the two inodes (orig and donor) by i_ino order.
- */
-static void
-mext_double_down_read(struct inode *orig_inode, struct inode *donor_inode)
-{
-	struct inode *first = orig_inode, *second = donor_inode;
-
-	/*
-	 * Use the inode number to provide the stable locking order instead
-	 * of its address, because the C language doesn't guarantee you can
-	 * compare pointers that don't come from the same array.
-	 */
-	if (donor_inode->i_ino < orig_inode->i_ino) {
-		first = donor_inode;
-		second = orig_inode;
-	}
-
-	down_read(&EXT4_I(first)->i_data_sem);
-	down_read(&EXT4_I(second)->i_data_sem);
-}
-
-/**
- * mext_double_down_write - Acquire two inodes' write semaphore
+ * double_down_write_data_sem - Acquire two inodes' write lock of i_data_sem
  *
  * @orig_inode:		original inode structure
  * @donor_inode:	donor inode structure
- * Acquire write semaphore of the two inodes (orig and donor) by i_ino order.
+ * Acquire write lock of i_data_sem of the two inodes (orig and donor) by
+ * i_ino order.
  */
 static void
-mext_double_down_write(struct inode *orig_inode, struct inode *donor_inode)
+double_down_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
 {
 	struct inode *first = orig_inode, *second = donor_inode;

@@ -207,28 +193,14 @@ mext_double_down_write(struct inode *orig_inode, struct inode *donor_inode)
 }

 /**
- * mext_double_up_read - Release two inodes' read semaphore
+ * double_up_write_data_sem - Release two inodes' write lock of i_data_sem
  *
  * @orig_inode:		original inode structure to be released its lock first
  * @donor_inode:	donor inode structure to be released its lock second
- * Release read semaphore of two inodes (orig and donor).
+ * Release write lock of i_data_sem of two inodes (orig and donor).
  */
 static void
-mext_double_up_read(struct inode *orig_inode, struct inode *donor_inode)
-{
-	up_read(&EXT4_I(orig_inode)->i_data_sem);
-	up_read(&EXT4_I(donor_inode)->i_data_sem);
-}
-
-/**
- * mext_double_up_write - Release two inodes' write semaphore
- *
- * @orig_inode:		original inode structure to be released its lock first
- * @donor_inode:	donor inode structure to be released its lock second
- * Release write semaphore of two inodes (orig and donor).
- */
-static void
-mext_double_up_write(struct inode *orig_inode, struct inode *donor_inode)
+double_up_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
 {
 	up_write(&EXT4_I(orig_inode)->i_data_sem);
 	up_write(&EXT4_I(donor_inode)->i_data_sem);
@@ -688,8 +660,6 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;

-	mext_double_down_write(orig_inode, donor_inode);
-
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
@@ -785,7 +755,6 @@ out:
 		kfree(donor_path);
 	}

-	mext_double_up_write(orig_inode, donor_inode);
 	return replaced_count;
 }

@@ -851,6 +820,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * Just swap data blocks between orig and donor.
 	 */
 	if (uninit) {
+		/*
+		 * Protect extent trees against block allocations
+		 * via delalloc
+		 */
+		double_down_write_data_sem(orig_inode, donor_inode);
 		replaced_count = mext_replace_branches(handle, orig_inode,
 						donor_inode, orig_blk_offset,
 						block_len_in_page, err);
@@ -858,6 +832,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		/* Clear the inode cache not to refer to the old data */
 		ext4_ext_invalidate_cache(orig_inode);
 		ext4_ext_invalidate_cache(donor_inode);
+		double_up_write_data_sem(orig_inode, donor_inode);
 		goto out2;
 	}

@@ -905,6 +880,8 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);

+	/* Protect extent trees against block allocations via delalloc */
+	double_down_write_data_sem(orig_inode, donor_inode);
 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
 					&err2);
@@ -913,14 +890,18 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 			block_len_in_page = replaced_count;
 			replaced_size =
 				block_len_in_page << orig_inode->i_blkbits;
-		} else
+		} else {
+			double_up_write_data_sem(orig_inode, donor_inode);
 			goto out;
+		}
 	}

 	/* Clear the inode cache not to refer to the old data */
 	ext4_ext_invalidate_cache(orig_inode);
 	ext4_ext_invalidate_cache(donor_inode);

+	double_up_write_data_sem(orig_inode, donor_inode);
+
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);

@@ -1236,16 +1217,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		return -EINVAL;
 	}

-	/* protect orig and donor against a truncate */
+	/* Protect orig and donor inodes against a truncate */
 	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
 	if (ret1 < 0)
 		return ret1;

-	mext_double_down_read(orig_inode, donor_inode);
+	/* Protect extent tree against block allocations via delalloc */
+	double_down_write_data_sem(orig_inode, donor_inode);
 	/* Check the filesystem environment whether move_extent can be done */
 	ret1 = mext_check_arguments(orig_inode, donor_inode, orig_start,
 					donor_start, &len, *moved_len);
-	mext_double_up_read(orig_inode, donor_inode);
 	if (ret1)
 		goto out;

@@ -1308,6 +1289,10 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			 ext4_ext_get_actual_len(ext_cur), block_end + 1) -
 		     max(le32_to_cpu(ext_cur->ee_block), block_start);

+	/* Discard preallocations of two inodes */
+	ext4_discard_preallocations(orig_inode);
+	ext4_discard_preallocations(donor_inode);
+
 	while (!last_extent && le32_to_cpu(ext_cur->ee_block) <= block_end) {
 		seq_blocks += add_blocks;

@@ -1359,14 +1344,14 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		seq_start = le32_to_cpu(ext_cur->ee_block);
 		rest_blocks = seq_blocks;

-		/* Discard preallocations of two inodes */
-		down_write(&EXT4_I(orig_inode)->i_data_sem);
-		ext4_discard_preallocations(orig_inode);
-		up_write(&EXT4_I(orig_inode)->i_data_sem);
-
-		down_write(&EXT4_I(donor_inode)->i_data_sem);
-		ext4_discard_preallocations(donor_inode);
-		up_write(&EXT4_I(donor_inode)->i_data_sem);
+		/*
+		 * Up semaphore to avoid following problems:
+		 * a. transaction deadlock among ext4_journal_start,
+		 *    ->write_begin via pagefault, and jbd2_journal_commit
+		 * b. racing with ->readpage, ->write_begin, and ext4_get_block
+		 *    in move_extent_per_page
+		 */
+		double_up_write_data_sem(orig_inode, donor_inode);

 		while (orig_page_offset <= seq_end_page) {

@@ -1381,14 +1366,14 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			/* Count how many blocks we have exchanged */
 			*moved_len += block_len_in_page;
 			if (ret1 < 0)
-				goto out;
+				break;
 			if (*moved_len > len) {
 				ext4_error(orig_inode->i_sb, __func__,
 					"We replaced blocks too much! "
 					"sum of replaced: %llu requested: %llu",
 					*moved_len, len);
 				ret1 = -EIO;
-				goto out;
+				break;
 			}

 			orig_page_offset++;
@@ -1400,6 +1385,10 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 				block_len_in_page = rest_blocks;
 		}

+		double_down_write_data_sem(orig_inode, donor_inode);
+		if (ret1 < 0)
+			break;
+
 		/* Decrease buffer counter */
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
@@ -1429,7 +1418,7 @@ out:
 		ext4_ext_drop_refs(holecheck_path);
 		kfree(holecheck_path);
 	}
