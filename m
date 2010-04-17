From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Sat, 17 Apr 2010 10:12:51 +0530
Message-ID: <k2l38f6fb7d1004162142ge8e8b194i9403fa4146f017@mail.gmail.com>
References: <20100212200726.GD5337@thunk.org>
	 <20100215150021.GE3434@quack.suse.cz>
	 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
	 <20100216131039.GB3153@quack.suse.cz>
	 <20100216141854.GT5337@thunk.org>
	 <38f6fb7d1002170737l1e9e3b72ub08e106283c26501@mail.gmail.com>
	 <38f6fb7d1003182023j5513640csdc797adb49393ea0@mail.gmail.com>
	 <20100322165209.GB4754@quack.suse.cz>
	 <38f6fb7d1003230341j4ff52fffidc614d566476b5bc@mail.gmail.com>
	 <20100329154534.GE5835@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:33844 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0DQEmw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Apr 2010 00:42:52 -0400
Received: by qw-out-2122.google.com with SMTP id 5so106042qwd.37
        for <linux-ext4@vger.kernel.org>; Fri, 16 Apr 2010 21:42:51 -0700 (PDT)
In-Reply-To: <20100329154534.GE5835@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I have implemented alloc_on_commit for EXT4.
I haven't tested it thoroughly, but I could run some test scripts and
postmark without any errors.

Though it's working, the performance it very poor.
As it was predicted by Ted, I guess it is because of the increased
time in stalling of filesystem operations as block allocation is done
while transaction is in LOCKED mode.

I am sending the patch(for kernel 2.6.32.4) for my implementation.
Please go through the patch and let me know if I am doing any mistakes
resulting in poor performance.
Also, let me know if it is possible to improve performance by some other means.

Thanks in advanced.

Regards,
Kailas Joshi

Index: linux-2.6.32.4/fs/fs-writeback.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/fs-writeback.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 fs-writeback.c
*** linux-2.6.32.4/fs/fs-writeback.c	19 Jan 2010 17:27:50 -0000	1.1.1.1
--- linux-2.6.32.4/fs/fs-writeback.c	15 Apr 2010 13:14:56 -0000
*************** int write_inode_now(struct inode *inode,
*** 1259,1264 ****
--- 1259,1278 ----
  }
  EXPORT_SYMBOL(write_inode_now);

+ /** alloc_on_commit - kailas
+  * map_inode_now -   allocate delayed inode blocks and write inode to disk
+  * @inode: inode to write to disk
+  * @sync: not used
+  *
+  * The caller must either have a ref on the inode or must have set
I_WILL_FREE.
+  */
+ int map_inode_now(struct inode *inode, int sync)
+ {
+         return filemap_fdatamap(inode->i_mapping);
+ }
+ EXPORT_SYMBOL(map_inode_now);
+
+
  /**
   * sync_inode - write an inode and its pages to disk.
   * @inode: the inode to sync
Index: linux-2.6.32.4/fs/ext4/ext4.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/ext4/ext4.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 ext4.h
*** linux-2.6.32.4/fs/ext4/ext4.h	19 Jan 2010 17:27:58 -0000	1.1.1.1
--- linux-2.6.32.4/fs/ext4/ext4.h	4 Mar 2010 00:01:53 -0000
*************** struct ext4_inode_info {
*** 743,750 ****
  #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
  #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
  #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
! #define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
  #define EXT4_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
  #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
  #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
  #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
--- 743,751 ----
  #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
  #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
  #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
! #define EXT4_MOUNT_ORDERED_DATA		0x00000	/* Flush data before commit */
  #define EXT4_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
+ #define EXT4_MOUNT_ALLOC_COMMIT_DATA	0x00800	/* Alloc data on commit */
  #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
  #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
  #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
*************** struct ext4_sb_info {
*** 1020,1025 ****
--- 1021,1029 ----

  	/* workqueue for dio unwritten */
  	struct workqueue_struct *dio_unwritten_wq;
+
+ 	/* alloc_on_commit - kailas */
+         handle_t *da_handle;
  };

  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
*************** static inline int ext4_valid_inum(struct
*** 1153,1162 ****
  #define EXT4_DEFM_XATTR_USER	0x0004
  #define EXT4_DEFM_ACL		0x0008
  #define EXT4_DEFM_UID16		0x0010
! #define EXT4_DEFM_JMODE		0x0060
  #define EXT4_DEFM_JMODE_DATA	0x0020
  #define EXT4_DEFM_JMODE_ORDERED	0x0040
  #define EXT4_DEFM_JMODE_WBACK	0x0060

  /*
   * Default journal batch times
--- 1157,1167 ----
  #define EXT4_DEFM_XATTR_USER	0x0004
  #define EXT4_DEFM_ACL		0x0008
  #define EXT4_DEFM_UID16		0x0010
! #define EXT4_DEFM_JMODE		0x00E0
  #define EXT4_DEFM_JMODE_DATA	0x0020
  #define EXT4_DEFM_JMODE_ORDERED	0x0040
  #define EXT4_DEFM_JMODE_WBACK	0x0060
+ #define EXT4_DEFM_JMODE_ALLOC_COMMIT	0x00C0

  /*
   * Default journal batch times
*************** extern void ext4_truncate(struct inode *
*** 1428,1435 ****
--- 1433,1442 ----
  extern int ext4_truncate_restart_trans(handle_t *, struct inode *,
int nblocks);
  extern void ext4_set_inode_flags(struct inode *);
  extern void ext4_get_inode_flags(struct ext4_inode_info *);
+ extern int ext4_sync_alloc_da_blocks(struct inode *inode, handle_t
*da_handle);
  extern int ext4_alloc_da_blocks(struct inode *inode);
  extern void ext4_set_aops(struct inode *inode);
+ extern int ext4_ordered_da_writepage_trans_blocks(struct inode *,
int nrblocks);
  extern int ext4_writepage_trans_blocks(struct inode *);
  extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int
idxblocks);
  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
Index: linux-2.6.32.4/fs/ext4/ext4_jbd2.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/ext4/ext4_jbd2.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 ext4_jbd2.h
*** linux-2.6.32.4/fs/ext4/ext4_jbd2.h	19 Jan 2010 17:27:58 -0000	1.1.1.1
--- linux-2.6.32.4/fs/ext4/ext4_jbd2.h	25 Feb 2010 07:51:37 -0000
*************** static inline int ext4_should_order_data
*** 295,301 ****
  		return 0;
  	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
  		return 0;
! 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
  		return 1;
  	return 0;
  }
--- 295,302 ----
  		return 0;
  	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
  		return 0;
! 	if ((test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA) ||
! 	    (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ALLOC_COMMIT_DATA))
  		return 1;
  	return 0;
  }
Index: linux-2.6.32.4/fs/ext4/inode.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/ext4/inode.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 inode.c
*** linux-2.6.32.4/fs/ext4/inode.c	19 Jan 2010 17:27:58 -0000	1.1.1.1
--- linux-2.6.32.4/fs/ext4/inode.c	15 Apr 2010 08:50:16 -0000
*************** static int walk_page_buffers(handle_t *h
*** 1498,1503 ****
--- 1498,1530 ----
  	return ret;
  }

+ static int count_page_buffers(struct buffer_head *head,
+ 			     unsigned from,
+ 			     unsigned to,
+ 			     int *partial,
+ 			     int (*fn)(struct buffer_head *bh))
+ {
+ 	struct buffer_head *bh;
+ 	unsigned block_start, block_end;
+ 	unsigned blocksize = head->b_size;
+ 	int ret = 0;
+ 	struct buffer_head *next;
+
+ 	for (bh = head, block_start = 0;
+ 	     bh != head || !block_start;
+ 	     block_start = block_end, bh = next) {
+ 		next = bh->b_this_page;
+ 		block_end = block_start + blocksize;
+ 		if (block_end <= from || block_start >= to) {
+ 			if (partial && !buffer_uptodate(bh))
+ 				*partial = 1;
+ 			continue;
+ 		}
+ 		ret += ((*fn)(bh)? 1 : 0);
+ 	}
+ 	return ret;
+ }
+
  /*
   * To preserve ordering, it is essential that the hole instantiation and
   * the data write be encapsulated in a single transaction.  We cannot
*************** static int mpage_da_submit_io(struct mpa
*** 1970,1976 ****
  	long pages_skipped;
  	struct pagevec pvec;
  	unsigned long index, end;
! 	int ret = 0, err, nr_pages, i;
  	struct inode *inode = mpd->inode;
  	struct address_space *mapping = inode->i_mapping;

--- 1997,2003 ----
  	long pages_skipped;
  	struct pagevec pvec;
  	unsigned long index, end;
! 	int ret = 0, err = 0, nr_pages, i;
  	struct inode *inode = mpd->inode;
  	struct address_space *mapping = inode->i_mapping;

*************** static int mpage_da_submit_io(struct mpa
*** 2000,2006 ****
--- 2027,2042 ----
  			BUG_ON(!PageLocked(page));
  			BUG_ON(PageWriteback(page));

+ 			/* alloc_on_commit - kailas */
+ 			if(mpd->wbc->map_only) {
+ 			      mpd->pages_written++;
+ 			      __set_page_mapped_nobuffers(page);
+ 			      unlock_page(page);
+ 			      continue;
+ 			}
+
  			pages_skipped = mpd->wbc->pages_skipped;
+
  			err = mapping->a_ops->writepage(page, mpd->wbc);
  			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
  				/*
*************** static int ext4_da_get_block_prep(struct
*** 2538,2543 ****
--- 2574,2581 ----
  		map_bh(bh_result, inode->i_sb, invalid_block);
  		set_buffer_new(bh_result);
  		set_buffer_delay(bh_result);
+ 		if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ALLOC_COMMIT_DATA)
+ 		  set_buffer_da(bh_result);
  	} else if (ret > 0) {
  		bh_result->b_size = (ret << inode->i_blkbits);
  		if (buffer_unwritten(bh_result)) {
*************** static int ext4_da_writepages_trans_bloc
*** 2801,2806 ****
--- 2839,2906 ----
  	return ext4_chunk_trans_blocks(inode, max_blocks);
  }

+ /* alloc_on_commit - kailas */
+ static int ext4_clear_page_mapped(struct address_space *mapping,
+ 			      struct writeback_control *wbc)
+ {
+ 	int ret = 0;
+ 	struct pagevec pvec;
+ 	int nr_pages;
+ 	pgoff_t index;
+ 	pgoff_t end;
+ 	int i;
+
+ 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+ 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+ 	pagevec_init(&pvec, 0);
+
+ 	nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+ 				      PAGECACHE_TAG_MAPPED,
+ 				      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+ 	if (nr_pages == 0)
+ 	  return ret;
+
+ 	for (i = 0; i < nr_pages; i++) {
+ 	       struct page *page = pvec.pages[i];
+
+ 	       /*
+ 		* At this point, the page may be truncated or
+ 		* invalidated (changing page->mapping to NULL), or
+ 		* even swizzled back from swapper_space to tmpfs file
+ 		* mapping. However, page->index will not change
+ 		* because we have a reference on the page.
+ 		*/
+ 	       if (page->index > end)
+ 		      break;
+ 	
+ 	       lock_page(page);
+
+ 	       /*
+ 		* Page truncated or invalidated. We can freely skip it
+ 		* then, even for data integrity operations: the page
+ 		* has disappeared concurrently, so there could be no
+ 		* real expectation of this data interity operation
+ 		* even if there is now a new, dirty page at the same
+ 		* pagecache address.
+ 		*/
+ 	       if (unlikely(page->mapping != mapping)) {
+ 		      unlock_page(page);
+ 		      continue;
+ 	       }
+
+ 	       __set_page_dirty_nobuffers(page);
+
+ 	       unlock_page(page);
+ 	       ret = 0;
+
+ 	       pagevec_release(&pvec);
+ 	       cond_resched();
+ 	}
+
+ 	return ret;
+ }
+
+
  static int ext4_da_writepages(struct address_space *mapping,
  			      struct writeback_control *wbc)
  {
*************** retry:
*** 3003,3008 ****
--- 3104,3111 ----
  		mapping->writeback_index = index;

  out_writepages:
+ 	if(wbc->map_only) /* alloc_on_commit - kailas */
+ 	       ext4_clear_page_mapped(mapping, wbc);
  	if (!no_nrwrite_index_update)
  		wbc->no_nrwrite_index_update = 0;
  	if (wbc->nr_to_write > nr_to_writebump)
*************** static int ext4_nonda_switch(struct supe
*** 3039,3044 ****
--- 3142,3157 ----
  	return 0;
  }

+ static int buffer_da_count(struct buffer_head *head)
+ {
+         if(buffer_da(head)) {
+ 	        clear_buffer_da(head);
+ 	        return 1;
+ 	}
+
+ 	return 0;
+ }
+
  static int ext4_da_write_begin(struct file *file, struct
address_space *mapping,
  			       loff_t pos, unsigned len, unsigned flags,
  			       struct page **pagep, void **fsdata)
*************** static int ext4_da_write_begin(struct fi
*** 3062,3067 ****
--- 3175,3182 ----
  	*fsdata = (void *)0;
  	trace_ext4_da_write_begin(inode, pos, len, flags);
  retry:
+
+ 	/* alloc_on_commit - kailas */
  	/*
  	 * With delayed allocation, we don't log the i_disksize update
  	 * if there is delayed block allocation. But we still need
*************** retry:
*** 3102,3107 ****
--- 3217,3258 ----

  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
  		goto retry;
+
+ 	/* alloc_on_commit - kailas */
+ 	/*
+ 	 * With delayed allocation, we don't log the i_disksize update
+ 	 * if there is delayed block allocation. But we still need
+ 	 * to journalling the i_disksize update if writes to the end
+ 	 * of file which has an already mapped buffer.
+ 	 */
+ 	/* Count number of page buffers with BH_DA */
+ 	if (test_opt(inode->i_sb, DATA_FLAGS) ==
+ 	    EXT4_MOUNT_ALLOC_COMMIT_DATA) {
+ 	        int needed_blocks;
+ 		int credits;
+ 		int err;
+ 	
+ 		needed_blocks = count_page_buffers(page_buffers(page),
+ 						   from, to, NULL, buffer_da_count);
+ 		credits = ext4_ordered_da_writepage_trans_blocks(inode, needed_blocks);
+
+ 		if (!ext4_handle_has_enough_credits(handle, credits)) {
+                     err = ext4_journal_extend(handle, credits - 1);
+ 		    if (err > 0) {
+ 		            unlock_page(page);
+                             err = ext4_journal_restart(handle, credits);
+ 			    lock_page(page);
+ 		    }
+                     if (err != 0) {
+                             ext4_warning(inode->i_sb, __func__,
+                                          "couldn't extend journal
(err %d)", err);
+                             ext4_journal_stop(handle);
+                             ret = err;
+ 			    goto out;
+                     }
+ 		}
+ 	}
+
  out:
  	return ret;
  }
*************** static int ext4_da_write_end(struct file
*** 3153,3158 ****
--- 3304,3319 ----
  		}
  	}

+ 	if (test_opt(inode->i_sb, DATA_FLAGS) ==
+ 	    EXT4_MOUNT_ALLOC_COMMIT_DATA) {
+ 	        ret = ext4_jbd2_file_inode(handle, inode);
+ 		if (ret)
+ 		        goto errout;
+ 		ret = ext4_mark_inode_dirty(handle, inode);
+ 		if (ret)
+ 		        goto errout;
+ 	}
+
  	trace_ext4_da_write_end(inode, pos, len, copied);
  	start = pos & (PAGE_CACHE_SIZE - 1);
  	end = start + copied - 1;
*************** static int ext4_da_write_end(struct file
*** 3191,3196 ****
--- 3352,3358 ----
  	copied = ret2;
  	if (ret2 < 0)
  		ret = ret2;
+ errout:
  	ret2 = ext4_journal_stop(handle);
  	if (!ret)
  		ret = ret2;
*************** int ext4_write_inode(struct inode *inode
*** 5188,5196 ****

  	if (EXT4_SB(inode->i_sb)->s_journal) {
  		if (ext4_journal_current_handle()) {
! 			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
! 			dump_stack();
! 			return -EIO;
  		}

  		if (!wait)
--- 5351,5360 ----

  	if (EXT4_SB(inode->i_sb)->s_journal) {
  		if (ext4_journal_current_handle()) {
! /* 			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n"); */
! /* 			dump_stack(); */
! /* 			return -EIO; */
! 		        return 0;
  		}

  		if (!wait)
*************** int ext4_meta_trans_blocks(struct inode
*** 5457,5462 ****
--- 5621,5642 ----

  /*
   * Calulate the total number of credits to reserve to fit
+  * the modification of a nrblocks into a single transaction,
+  * which may include multiple chunks of block allocations.
+  *
+  * This could be called via ext4_write_begin() for alloc_on_commit mode
+  *
+  * We need to consider the worse case, when
+  * one new block per extent.
+  */
+ int ext4_ordered_da_writepage_trans_blocks(struct inode *inode, int nrblocks)
+ {
+ 	return ext4_meta_trans_blocks(inode, nrblocks, 0);
+ }
+
+
+ /*
+  * Calulate the total number of credits to reserve to fit
   * the modification of a single pages into a single transaction,
   * which may include multiple chunks of block allocations.
   *
*************** out_unlock:
*** 5823,5825 ****
--- 6004,6021 ----
  	up_read(&inode->i_alloc_sem);
  	return ret;
  }
+
+ /* alloc_on_commit - Kailas */
+ int ext4_sync_alloc_da_blocks(struct inode *inode, handle_t *da_handle)
+ {
+         int ret = 0;
+
+ 	igrab(inode);
+
+ 	if(!(inode->i_state & I_SYNC))
+ 	      ret = map_inode_now(inode, 1);
+
+ 	iput(inode);
+
+ 	return ret;
+ }
Index: linux-2.6.32.4/fs/ext4/super.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/ext4/super.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 super.c
*** linux-2.6.32.4/fs/ext4/super.c	19 Jan 2010 17:27:58 -0000	1.1.1.1
--- linux-2.6.32.4/fs/ext4/super.c	25 Mar 2010 11:27:14 -0000
*************** static int ext4_statfs(struct dentry *de
*** 68,73 ****
--- 68,74 ----
  static int ext4_unfreeze(struct super_block *sb);
  static void ext4_write_super(struct super_block *sb);
  static int ext4_freeze(struct super_block *sb);
+ static void alloc_on_commit_callback(journal_t *journal, handle_t *da_handle);


  ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
*************** static void ext4_put_nojournal(handle_t
*** 223,228 ****
--- 224,230 ----
  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
  {
  	journal_t *journal;
+ 	handle_t *handle;

  	if (sb->s_flags & MS_RDONLY)
  		return ERR_PTR(-EROFS);
*************** handle_t *ext4_journal_start_sb(struct s
*** 236,242 ****
  			ext4_abort(sb, __func__, "Detected aborted journal");
  			return ERR_PTR(-EROFS);
  		}
! 		return jbd2_journal_start(journal, nblocks);
  	}
  	return ext4_get_nojournal();
  }
--- 238,251 ----
  			ext4_abort(sb, __func__, "Detected aborted journal");
  			return ERR_PTR(-EROFS);
  		}
!
! 		handle = jbd2_journal_start(journal, nblocks);
! 		 	
! 		/* alloc_on_commit - kailas */
! 		if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ALLOC_COMMIT_DATA)
! 		        handle->h_retain_credits = 1;
!
! 		return handle;
  	}
  	return ext4_get_nojournal();
  }
*************** static int ext4_show_options(struct seq_
*** 895,900 ****
--- 904,911 ----
  		seq_puts(seq, ",data=ordered");
  	else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
  		seq_puts(seq, ",data=writeback");
+ 	else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ALLOC_COMMIT_DATA)
+ 		seq_puts(seq, ",data=alloc_on_commit");

  	if (sbi->s_inode_readahead_blks != EXT4_DEF_INODE_READAHEAD_BLKS)
  		seq_printf(seq, ",inode_readahead_blks=%u",
*************** enum {
*** 1087,1093 ****
  	Opt_journal_update, Opt_journal_dev,
  	Opt_journal_checksum, Opt_journal_async_commit,
  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
! 	Opt_data_err_abort, Opt_data_err_ignore,
  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
  	Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_resize,
--- 1098,1104 ----
  	Opt_journal_update, Opt_journal_dev,
  	Opt_journal_checksum, Opt_journal_async_commit,
  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
! 	Opt_data_alloc_on_commit, Opt_data_err_abort, Opt_data_err_ignore,
  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
  	Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_resize,
*************** static const match_table_t tokens = {
*** 1134,1139 ****
--- 1145,1151 ----
  	{Opt_data_journal, "data=journal"},
  	{Opt_data_ordered, "data=ordered"},
  	{Opt_data_writeback, "data=writeback"},
+ 	{Opt_data_alloc_on_commit, "data=alloc_on_commit"},
  	{Opt_data_err_abort, "data_err=abort"},
  	{Opt_data_err_ignore, "data_err=ignore"},
  	{Opt_offusrjquota, "usrjquota="},
*************** static int parse_options(char *options,
*** 1359,1364 ****
--- 1371,1379 ----
  		case Opt_data_ordered:
  			data_opt = EXT4_MOUNT_ORDERED_DATA;
  			goto datacheck;
+ 		case Opt_data_alloc_on_commit:
+ 			data_opt = EXT4_MOUNT_ALLOC_COMMIT_DATA;
+ 			goto datacheck;
  		case Opt_data_writeback:
  			data_opt = EXT4_MOUNT_WRITEBACK_DATA;
  		datacheck:
*************** static void ext4_orphan_cleanup(struct s
*** 1958,1963 ****
--- 1973,2016 ----
  	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
  }

+
+ /*
+  * This callback is called before each commit when we are using
+  * alloc-on-commit mode.
+  */
+ static void alloc_on_commit_callback(journal_t *journal, handle_t *da_handle)
+ {
+         struct jbd2_inode *jinode, *next_i;
+ 	transaction_t *transaction = journal->j_running_transaction;
+ 	struct ext4_sb_info *sbi;
+
+ 	spin_lock(&journal->j_list_lock);
+ 	list_for_each_entry_safe(jinode, next_i,
+                  &transaction->t_inode_list, i_list) {
+ 	        spin_unlock(&journal->j_list_lock);
+
+ /* 		sbi = EXT4_SB(jinode->i_vfs_inode->i_sb); */
+ /* 		sbi->da_handle = da_handle; */
+
+ 		printk(KERN_ALERT "Writing handle:%x inode:%d\n",
+ 		       da_handle, jinode->i_vfs_inode->i_ino);
+
+ /* 		ext4_alloc_da_blocks(jinode->i_vfs_inode); */
+ 		ext4_sync_alloc_da_blocks(jinode->i_vfs_inode, da_handle);
+ 		
+
+ 		printk(KERN_ALERT "Written handle:%x inode:%d\n",
+ 		       da_handle, jinode->i_vfs_inode->i_ino);
+
+ /* 		sbi->da_handle = NULL; */
+
+ 		spin_lock(&journal->j_list_lock);
+ 	}
+ 	spin_unlock(&journal->j_list_lock);
+ }
+
+
+
  /*
   * Maximal extent format file size.
   * Resulting logical blkno at s_maxbytes must fit in our on-disk
*************** static int ext4_fill_super(struct super_
*** 2434,2439 ****
--- 2487,2495 ----
  		sbi->s_mount_opt |= EXT4_MOUNT_ORDERED_DATA;
  	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_WBACK)
  		sbi->s_mount_opt |= EXT4_MOUNT_WRITEBACK_DATA;
+ 	else if ((def_mount_opts & EXT4_DEFM_JMODE) ==
+ 		 EXT4_DEFM_JMODE_ALLOC_COMMIT)
+ 		sbi->s_mount_opt |= EXT4_MOUNT_ALLOC_COMMIT_DATA;

  	if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_PANIC)
  		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
*************** static int ext4_fill_super(struct super_
*** 2804,2821 ****
  	/* We have now updated the journal if required, so we can
  	 * validate the data journaling mode. */
  	switch (test_opt(sb, DATA_FLAGS)) {
! 	case 0:
! 		/* No mode set, assume a default based on the journal
! 		 * capabilities: ORDERED_DATA if the journal can
! 		 * cope, else JOURNAL_DATA
! 		 */
! 		if (jbd2_journal_check_available_features
! 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE))
! 			set_opt(sbi->s_mount_opt, ORDERED_DATA);
! 		else
! 			set_opt(sbi->s_mount_opt, JOURNAL_DATA);
! 		break;
!
  	case EXT4_MOUNT_ORDERED_DATA:
  	case EXT4_MOUNT_WRITEBACK_DATA:
  		if (!jbd2_journal_check_available_features
--- 2860,2868 ----
  	/* We have now updated the journal if required, so we can
  	 * validate the data journaling mode. */
  	switch (test_opt(sb, DATA_FLAGS)) {
! 	case EXT4_MOUNT_ALLOC_COMMIT_DATA:
! 		sbi->s_journal->j_pre_commit_callback =
! 			alloc_on_commit_callback;
  	case EXT4_MOUNT_ORDERED_DATA:
  	case EXT4_MOUNT_WRITEBACK_DATA:
  		if (!jbd2_journal_check_available_features
*************** no_journal:
*** 2939,2944 ****
--- 2986,2994 ----
  			descr = " journalled data mode";
  		else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
  			descr = " ordered data mode";
+ 		else if (test_opt(sb, DATA_FLAGS) ==
+ 			 EXT4_MOUNT_ALLOC_COMMIT_DATA)
+ 			descr = " alloc on commit data mode";
  		else
  			descr = " writeback data mode";
  	} else
Index: linux-2.6.32.4/fs/jbd/journal.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/jbd/journal.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 journal.c
*** linux-2.6.32.4/fs/jbd/journal.c	19 Jan 2010 17:27:59 -0000	1.1.1.1
--- linux-2.6.32.4/fs/jbd/journal.c	19 Feb 2010 10:07:43 -0000
*************** static void __init jbd_create_debugfs_en
*** 1913,1919 ****
  {
  	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
  	if (jbd_debugfs_dir)
! 		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
  					       jbd_debugfs_dir,
  					       &journal_enable_debug);
  }
--- 1913,1919 ----
  {
  	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
  	if (jbd_debugfs_dir)
! 		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
  					       jbd_debugfs_dir,
  					       &journal_enable_debug);
  }
Index: linux-2.6.32.4/fs/jbd2/commit.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/jbd2/commit.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 commit.c
*** linux-2.6.32.4/fs/jbd2/commit.c	19 Jan 2010 17:27:55 -0000	1.1.1.1
--- linux-2.6.32.4/fs/jbd2/commit.c	27 Mar 2010 06:25:47 -0000
*************** void jbd2_journal_commit_transaction(jou
*** 369,374 ****
--- 369,375 ----
  	struct buffer_head *cbh = NULL; /* For transactional checksums */
  	__u32 crc32_sum = ~0;
  	int write_op = WRITE;
+ 	handle_t *da_handle = NULL;

  	/*
  	 * First job: lock down the current transaction and wait for
*************** void jbd2_journal_commit_transaction(jou
*** 399,404 ****
--- 400,417 ----
  	jbd_debug(1, "JBD: starting commit of transaction %d\n",
  			commit_transaction->t_tid);

+ 	printk(KERN_ALERT "alloc_on_commit: Commiting\n"
+ 	       , commit_transaction->t_updates);
+
+ 	/* alloc_on_commit - kailas */
+ 	if (journal->j_pre_commit_callback) {
+
+ 	        printk(KERN_ALERT "alloc_on_commit: Starting Transaction\n"
+ 		       , commit_transaction->t_updates);
+
+ 	        da_handle = jbd2_journal_start(journal, 0);
+ 	}
+
  	spin_lock(&journal->j_state_lock);
  	commit_transaction->t_state = T_LOCKED;

*************** void jbd2_journal_commit_transaction(jou
*** 416,426 ****
  					      stats.run.rs_locked);

  	spin_lock(&commit_transaction->t_handle_lock);
! 	while (commit_transaction->t_updates) {
  		DEFINE_WAIT(wait);

  		prepare_to_wait(&journal->j_wait_updates, &wait,
  					TASK_UNINTERRUPTIBLE);
  		if (commit_transaction->t_updates) {
  			spin_unlock(&commit_transaction->t_handle_lock);
  			spin_unlock(&journal->j_state_lock);
--- 429,469 ----
  					      stats.run.rs_locked);

  	spin_lock(&commit_transaction->t_handle_lock);
! 	/* alloc_on_commit - kailas */
! /* 	while (commit_transaction->t_updates != 1) { */
!  	while (1) {
! /* 	        printk(KERN_ALERT "alloc_on_commit: Wait Loop\n" */
! /* 		       , commit_transaction->t_updates); */
!
! 	        if (da_handle) {
! 		      if (commit_transaction->t_updates <= 1)
! 			   break;
! 		}
! 		else
! 		      if(!commit_transaction->t_updates)
! 			   break;
!
! 		{
  		  DEFINE_WAIT(wait);
  		
  		  prepare_to_wait(&journal->j_wait_updates, &wait,
  				  TASK_UNINTERRUPTIBLE);
+ 		  /* alloc_on_commit - kailas */
+ 		  /* 		if (commit_transaction->t_updates != 1) { */
+ 		  /*  		if (commit_transaction->t_updates) { */
+ 		
+ 		  if (da_handle) {
+ 		    if (commit_transaction->t_updates > 1) {
+ 		      spin_unlock(&commit_transaction->t_handle_lock);
+ 		      spin_unlock(&journal->j_state_lock);
+ /* 		      printk(KERN_ALERT "alloc_on_commit: %d\n" */
+ /* 			     , commit_transaction->t_updates); */
+ 		      schedule();
+ 		      spin_lock(&journal->j_state_lock);
+ 		      spin_lock(&commit_transaction->t_handle_lock);
+ 		    }
+ 		  }
+ 		  else
  		    if (commit_transaction->t_updates) {
  		      spin_unlock(&commit_transaction->t_handle_lock);
  		      spin_unlock(&journal->j_state_lock);
*************** void jbd2_journal_commit_transaction(jou
*** 428,437 ****
--- 471,502 ----
  		      spin_lock(&journal->j_state_lock);
  		      spin_lock(&commit_transaction->t_handle_lock);
  		    }
+
  		  finish_wait(&journal->j_wait_updates, &wait);
  		}
+ 	}
+
  	spin_unlock(&commit_transaction->t_handle_lock);

+ 	/* alloc_on_commit - kailas */
+ 	if (da_handle) {
+ 		J_ASSERT (da_handle->h_buffer_credits == 0);
+ 	        da_handle->h_buffer_credits = commit_transaction->t_retained_credits;
+
+ 		spin_unlock(&journal->j_state_lock);
+
+ 	        printk(KERN_ALERT "alloc_on_commit: Starting Callback\n"
+ 		       , commit_transaction->t_updates);
+
+ 	        journal->j_pre_commit_callback(journal, da_handle);
+
+ 	        printk(KERN_ALERT "alloc_on_commit: Callback Finished\n"
+ 		       , commit_transaction->t_updates);
+
+ 		jbd2_journal_stop(da_handle);
+ 		spin_lock(&journal->j_state_lock);
+ 	}
+
  	J_ASSERT (commit_transaction->t_outstanding_credits <=
  			journal->j_max_transaction_buffers);

*************** restart_loop:
*** 1057,1065 ****
  	}
  	spin_unlock(&journal->j_list_lock);

- 	if (journal->j_commit_callback)
- 		journal->j_commit_callback(journal, commit_transaction);
-
  	trace_jbd2_end_commit(journal, commit_transaction);
  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
  		  journal->j_commit_sequence, journal->j_tail_sequence);
--- 1122,1127 ----
Index: linux-2.6.32.4/fs/jbd2/journal.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/jbd2/journal.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 journal.c
*** linux-2.6.32.4/fs/jbd2/journal.c	19 Jan 2010 17:27:55 -0000	1.1.1.1
--- linux-2.6.32.4/fs/jbd2/journal.c	19 Feb 2010 10:09:26 -0000
*************** static void __init jbd2_create_debugfs_e
*** 2115,2121 ****
  {
  	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
  	if (jbd2_debugfs_dir)
! 		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO,
  					       jbd2_debugfs_dir,
  					       &jbd2_journal_enable_debug);
  }
--- 2115,2121 ----
  {
  	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
  	if (jbd2_debugfs_dir)
! 		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO | S_IWUSR,
  					       jbd2_debugfs_dir,
  					       &jbd2_journal_enable_debug);
  }
Index: linux-2.6.32.4/fs/jbd2/transaction.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/fs/jbd2/transaction.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 transaction.c
*** linux-2.6.32.4/fs/jbd2/transaction.c	19 Jan 2010 17:27:55 -0000	1.1.1.1
--- linux-2.6.32.4/fs/jbd2/transaction.c	27 Mar 2010 07:20:27 -0000
*************** int jbd2_journal_stop(handle_t *handle)
*** 1313,1325 ****
--- 1314,1345 ----
  	current->journal_info = NULL;
  	spin_lock(&journal->j_state_lock);
  	spin_lock(&transaction->t_handle_lock);
+
+ 	/* alloc_on_commit - kailas */
+ 	if (handle->h_retain_credits) {
+ 	  transaction->t_retained_credits += handle->h_buffer_credits;
+ 	}
+ 	else {
  	  transaction->t_outstanding_credits -= handle->h_buffer_credits;
+ 	}
+
  	transaction->t_updates--;
+
+ 	/* alloc_on_commit - kailas */
+ 	if(!handle->h_retain_credits) {
  	     if (!transaction->t_updates) {
  	           wake_up(&journal->j_wait_updates);
  		   if (journal->j_barrier_count)
  		         wake_up(&journal->j_wait_transaction_locked);
  	     }
+ 	}
+ 	else {
+ 	     if (transaction->t_updates == 1) {
+ 	           wake_up(&journal->j_wait_updates);
+ 		   if (journal->j_barrier_count)
+ 		         wake_up(&journal->j_wait_transaction_locked);
+ 	     }
+ 	}

  	/*
  	 * If the handle is marked SYNC, we need to set another commit
Index: linux-2.6.32.4/include/linux/buffer_head.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/include/linux/buffer_head.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 buffer_head.h
*** linux-2.6.32.4/include/linux/buffer_head.h	19 Jan 2010 17:27:35
-0000	1.1.1.1
--- linux-2.6.32.4/include/linux/buffer_head.h	19 Feb 2010 12:14:17 -0000
*************** enum bh_state_bits {
*** 40,45 ****
--- 40,46 ----
  	BH_PrivateStart,/* not a state bit, but the first bit available
  			 * for private allocation by other entities
  			 */
+ 	BH_DA,          /* Needs credit reservation for delayed block allocation*/
  };

  #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
*************** BUFFER_FNS(Write_EIO, write_io_error)
*** 128,133 ****
--- 129,135 ----
  BUFFER_FNS(Ordered, ordered)
  BUFFER_FNS(Eopnotsupp, eopnotsupp)
  BUFFER_FNS(Unwritten, unwritten)
+ BUFFER_FNS(DA, da)

  #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
  #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
Index: linux-2.6.32.4/include/linux/fs.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/include/linux/fs.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 fs.h
*** linux-2.6.32.4/include/linux/fs.h	19 Jan 2010 17:27:37 -0000	1.1.1.1
--- linux-2.6.32.4/include/linux/fs.h	15 Apr 2010 08:11:00 -0000
*************** struct block_device {
*** 679,684 ****
--- 679,685 ----
   */
  #define PAGECACHE_TAG_DIRTY	0
  #define PAGECACHE_TAG_WRITEBACK	1
+ #define PAGECACHE_TAG_MAPPED	2 /* alloc_on_commit - kailas */

  int mapping_tagged(struct address_space *mapping, int tag);

*************** extern int invalidate_inode_pages2(struc
*** 2082,2088 ****
--- 2083,2092 ----
  extern int invalidate_inode_pages2_range(struct address_space *mapping,
  					 pgoff_t start, pgoff_t end);
  extern int write_inode_now(struct inode *, int);
+ extern int map_inode_now(struct inode *, int); /* alloc_on_commit - kailas */
  extern int filemap_fdatawrite(struct address_space *);
+ extern int filemap_fdatamap(struct address_space *); /*
alloc_on_commit - kailas */
+ extern int sync_filemap_flush(struct address_space *mapping);
  extern int filemap_flush(struct address_space *);
  extern int filemap_fdatawait(struct address_space *);
  extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
Index: linux-2.6.32.4/include/linux/jbd2.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/include/linux/jbd2.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 jbd2.h
*** linux-2.6.32.4/include/linux/jbd2.h	19 Jan 2010 17:27:37 -0000	1.1.1.1
--- linux-2.6.32.4/include/linux/jbd2.h	27 Feb 2010 18:30:13 -0000
*************** struct handle_s
*** 453,458 ****
--- 453,463 ----
  	unsigned int	h_jdata:	1;	/* force data journaling */
  	unsigned int	h_aborted:	1;	/* fatal error on handle */

+         /* alloc_on_commit - kailas */
+ 	unsigned int	h_retain_credits:1;	/* Handle will retain credits
+ 						 * till transaction commit.
+ 						 */
+
  #ifdef CONFIG_DEBUG_LOCK_ALLOC
  	struct lockdep_map	h_lockdep_map;
  #endif
*************** struct transaction_s
*** 627,632 ****
--- 632,644 ----
  	int			t_outstanding_credits;

  	/*
+ 	 * Number of buffers retained by summing unused credits of all handles in
+ 	 * this transaction.
+ 	 * These credits will be used by magic handle in this transaction.
[t_handle_lock]
+ 	 */
+ 	int			t_retained_credits;
+
+ 	/*
  	 * Forward and backward links for the circular list of all transactions
  	 * awaiting checkpoint. [j_list_lock]
  	 */
*************** struct journal_s
*** 974,979 ****
--- 986,993 ----
  	u32			j_min_batch_time;
  	u32			j_max_batch_time;

+ 	/* This function is called before a transaction is closed */
+   void			(*j_pre_commit_callback)(journal_t *, handle_t *handle);
  	/* This function is called when a transaction is closed */
  	void			(*j_commit_callback)(journal_t *,
  						     transaction_t *);
Index: linux-2.6.32.4/include/linux/mm.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/include/linux/mm.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 mm.h
*** linux-2.6.32.4/include/linux/mm.h	19 Jan 2010 17:27:38 -0000	1.1.1.1
--- linux-2.6.32.4/include/linux/mm.h	15 Apr 2010 09:31:13 -0000
*************** extern int try_to_release_page(struct pa
*** 829,834 ****
--- 829,835 ----
  extern void do_invalidatepage(struct page *page, unsigned long offset);

  int __set_page_dirty_nobuffers(struct page *page);
+ int __set_page_mapped_nobuffers(struct page *page); /*
alloc_on_commit - kailas */
  int __set_page_dirty_no_writeback(struct page *page);
  int redirty_page_for_writepage(struct writeback_control *wbc,
  				struct page *page);
Index: linux-2.6.32.4/include/linux/writeback.h
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/include/linux/writeback.h,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 writeback.h
*** linux-2.6.32.4/include/linux/writeback.h	19 Jan 2010 17:27:34 -0000	1.1.1.1
--- linux-2.6.32.4/include/linux/writeback.h	15 Apr 2010 12:48:47 -0000
*************** struct writeback_control {
*** 61,66 ****
--- 61,67 ----
  	 * so we use a single control to update them
  	 */
  	unsigned no_nrwrite_index_update:1;
+         unsigned map_only:1;            /* Map inode blocks only.
alloc_on_commit - kailas */
  };

  /*
Index: linux-2.6.32.4/mm/filemap.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/mm/filemap.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 filemap.c
*** linux-2.6.32.4/mm/filemap.c	19 Jan 2010 17:27:49 -0000	1.1.1.1
--- linux-2.6.32.4/mm/filemap.c	15 Apr 2010 08:09:00 -0000
*************** int filemap_fdatawrite(struct address_sp
*** 239,244 ****
--- 239,267 ----
  }
  EXPORT_SYMBOL(filemap_fdatawrite);

+ /** alloc_on_commit - kailas
+  * filemap_fdatamap - start block mapping writeback on mapping
+  * @mapping:	target address_space
+  */
+ int filemap_fdatamap(struct address_space *mapping)
+ {
+ 	int ret;
+ 	struct writeback_control wbc = {
+ 		.sync_mode = WB_SYNC_ALL,
+ 		.nr_to_write = LONG_MAX,
+ 		.range_start = 0,
+ 		.range_end = LLONG_MAX,
+ 		.map_only = 1,
+ 	};
+
+ 	if (!mapping_cap_writeback_dirty(mapping))
+ 		return 0;
+
+ 	ret = do_writepages(mapping, &wbc);
+ 	return ret;
+ }
+ EXPORT_SYMBOL(filemap_fdatamap);
+
  int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
  				loff_t end)
  {
Index: linux-2.6.32.4/mm/page-writeback.c
===================================================================
RCS file: /repo/kernel-source/linux-2.6.32.4/mm/page-writeback.c,v
retrieving revision 1.1.1.1
diff -p -w -B -r1.1.1.1 page-writeback.c
*** linux-2.6.32.4/mm/page-writeback.c	19 Jan 2010 17:27:49 -0000	1.1.1.1
--- linux-2.6.32.4/mm/page-writeback.c	15 Apr 2010 09:28:48 -0000
*************** int __set_page_dirty_nobuffers(struct pa
*** 1141,1146 ****
--- 1141,1156 ----
  }
  EXPORT_SYMBOL(__set_page_dirty_nobuffers);

+ /* alloc_on_commit - kailas */
+ int __set_page_mapped_nobuffers(struct page *page)
+ {
+ 	struct address_space *mapping = page_mapping(page);
+         radix_tree_tag_set(&mapping->page_tree,
+ 			   page_index(page), PAGECACHE_TAG_MAPPED);
+ 	return 0;
+ }
+ EXPORT_SYMBOL(__set_page_mapped_nobuffers);
+
  /*
   * When a writepage implementation decides that it doesn't want to write this
   * page for some reason, it should redirty the locked page via
