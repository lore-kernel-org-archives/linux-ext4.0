From: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Subject: [Resubmit][PATCH 1/1] Comprehensive Secure Deletion for ext4
Date: Tue, 30 Jan 2007 12:44:10 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0701301237580.20954@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:35531 "EHLO sbcs.cs.sunysb.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXA3SkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jan 2007 13:40:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Note:
-------
This patch is being resubmitted as part of the call for any patches
for ext4.  It uses 2.6.20-rc6 version as the base.

Problem:
--------
The ext4 file-system does not have a comprehensive secure deletion
functionality.  Currently upon deletion, all blocks that have been
deleted are merely marked as free and not otherwise touched.

Solution:
---------
With this patch, we can ensure that data, meta-data and the filename of
any file marked with the special attribute "s", are overwritten during
deletion.

The patch performs N overwrites with configurable patterns.  It can
handle separate overwrite configurations for each of the data, meta-data
and directory entry.  In order to handle partial file truncations, our
patch will intercept truncate requests in addition to unlink requests
(something that user-mode programs such as shred cannot handle).
Moreover, to make the data overwrites and file truncation an atomic
operation, we add the file to an orphan list right before we begin to
overwrite and remove it from the orphan list after truncation has
finished.  The patch works in all journaling modes.

As far as the journal is concerned, we leave it untouched.  There are a
few reasons behind this approach.  First, performance will be noticeably
hindered.  This is because the journal will have to postpone all further
transactions until the necessary blocks are overwritten - which will
take time.  Secondly, by the time we want to overwrite the necessary
blocks, the journal will have already done this for us by committing all
further transactions, especially in full journaling mode.  That said, if
the community will appear to also want secure-deletion of journal
records, then we can add that (probably as a separate feature one can
turn on independently).

Secure deletion arguments during mount time are of the form:

mount -t ext4dev -o secdel="args" [dev] [mnt]

where args is a 6-way list delimited by colons as such:

secdel="N1:S1:N2:S2:N3:S3"

N1,N2,N3 denote the number of overwrites for data,meta-data and the
filename respectively.

S1,S2,S3 denote the character sequence used to overwrite data,meta-data
and the filename respectively. Random character sequences are denoted by
'R'.

Any item that is left empty is not securely deleted.

In addition, if one wants to secure-delete all portions of a file, an
abbreviated format can be used as such:

secdel="N:S"

N denotes the number of overwrites chosen
S denotes the character sequence to use for overwriting

For example, the mount option:

secdel="2:Rc0:::1:\0"

Means that data will be overwritten once using a random character,
then once using the ASCII character 'c', and finally once more using the
ASCII character 0.  Finally this whole sequence will be written 2 times.
Meta-data will not be touched and the filename will be overwritten 1
time with the value zero.

Any comments, help or feedback will be greatly appreciated.

Thank you,
Harry Papaxenopoulos, Nikolai Joukov, and Erez Zadok
--------------------------------------
File systems and Storage Laboratory
Stony Brook University
--------------------------------------

Signed-off-by: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Signed-off-by: Nikolai Joukov <kolya@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

Index: sdfs/src/linux-2.6.20-rc6-secdel/fs/Kconfig
diff -c sdfs/src/linux-2.6.20-rc6-secdel/fs/Kconfig:1.1
sdfs/src/linux-2.6.20-rc6-secdel/fs/Kconfig:1.2
*** sdfs/src/linux-2.6.20-rc6-secdel/fs/Kconfig:1.1	Fri Jan 26
16:31:53 2007
--- sdfs/src/linux-2.6.20-rc6-secdel/fs/Kconfig	Fri Jan 26 17:52:29 2007
***************
*** 201,206 ****
--- 201,218 ----
  	  If you are not using a security module that requires using
  	  extended attributes for file security labels, say N.

+ config EXT4DEV_FS_SECDEL
+ 	bool "Ext4dev Secure deletion functionality"
+ 	depends on EXT4DEV_FS
+ 	help
+ 	  Secure deletion adds the functionality of overwriting files with
+ 	  various characters during deletion, to disable any possible file
+ 	  recovery. With this option, various policies can be chosen such
+ 	  as multiple overwrites as well as data, meta-data and/or
filename
+ 	  overwriting.
+
+ 	  If you don't know what secure deletion is, say N.
+
  config JBD
  	tristate
  	help
Index: sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/inode.c
diff -c sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/inode.c:1.1
sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/inode.c:1.3
*** sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/inode.c:1.1	Fri Jan 26
16:31:53 2007
--- sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/inode.c	Fri Jan 26
17:52:30 2007
***************
*** 37,45 ****
--- 37,50 ----
  #include <linux/mpage.h>
  #include <linux/uio.h>
  #include <linux/bio.h>
+ #include <linux/random.h>
  #include "xattr.h"
  #include "acl.h"

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ static int ext4_secrm_metadata(struct inode *);
+ #endif
+
  /*
   * Test whether an inode is a fast symlink.
   */
***************
*** 201,208 ****
--- 206,222 ----
  	if (IS_SYNC(inode))
  		handle->h_sync = 1;
  	inode->i_size = 0;
+ #ifndef CONFIG_EXT4DEV_FS_SECDEL
+ 	if (inode->i_blocks)
+ 		ext4_truncate(inode);
+ #else
+ 	ext4_journal_stop(handle);
  	if (inode->i_blocks)
  		ext4_truncate(inode);
+ 	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
+ 		ext4_secrm_metadata(inode);
+ 	handle = start_transaction(inode);
+ #endif
  	/*
  	 * Kill off the orphan record which ext4_truncate created.
  	 * AKPM: I think this can be inside the above `if'.
***************
*** 1082,1087 ****
--- 1096,1368 ----
  	return NULL;
  }

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ static int ext4_ovwt_blocks(handle_t *handle, struct inode *inode, char
param,
+ 		sector_t first, sector_t last)
+ {
+ 	int retval = 0;
+ 	sector_t sector;
+ 	sector_t batch = DIO_CREDITS;
+ 	struct buffer_head *bh = NULL;
+ 	struct buffer_head tmp;
+ 	struct super_block *sb;
+ 	J_ASSERT(handle != NULL);
+
+ 	tmp.b_state = 0;
+ 	tmp.b_blocknr = 0;
+ 	sb = inode->i_sb;
+
+ 	J_ASSERT( last >= first );
+
+ 	if (IS_ERR(handle)) {
+ 		retval = PTR_ERR(handle);
+ 		goto out;
+ 	}
+
+ 	for (sector = first; sector <= last; sector++) {
+
+ 		if (handle->h_buffer_credits <= EXT4_RESERVE_TRANS_BLOCKS)
{
+ 			retval = ext4_journal_extend(handle, DIO_CREDITS);
+ 			if (retval)
+ 				retval = ext4_journal_restart(handle,
+ 							DIO_CREDITS);
+ 			if (retval)
+ 				goto out;
+ 		}
+
+ 		ext4_get_block(inode, sector, &tmp, 0);
+ 		bh = sb_getblk(sb, tmp.b_blocknr);
+ 		if (!bh)
+ 			continue;
+
+ 		if (ext4_should_journal_data(inode)) {
+ 			retval = ext4_journal_get_write_access(handle,
bh);
+ 			if (retval)
+ 				goto out;
+ 		}
+
+ 		lock_buffer(bh);
+ 		if (param == 'R')
+ 			get_random_bytes(bh->b_data, bh->b_size);
+ 		else
+ 			memset(bh->b_data, param, bh->b_size);
+ 		unlock_buffer(bh);
+
+ 		if (ext4_should_journal_data(inode)) {
+ 			set_buffer_uptodate(bh);
+ 			retval = ext4_journal_dirty_metadata(handle, bh);
+ 			if (retval)
+ 				goto out;
+ 		}
+ 		else {
+ 			if (ext4_should_order_data(inode)) {
+ 				retval = ext4_journal_dirty_data(handle,
bh);
+ 				if (retval)
+ 					goto out;
+ 			}
+ 			mark_buffer_dirty(bh);
+ 		}
+ 		brelse(bh);
+ 	}
+ 	bh = NULL;
+ out:
+ 	if (retval)
+ 		ext4_journal_abort_handle(NULL, NULL, bh, handle, retval);
+ 	if (bh)
+ 		brelse(bh);
+ 	return retval;
+ }
+
+ static int ext4_ovwt_metadata(handle_t *handle, struct inode *inode,
char param)
+ {
+         int retval = 0;
+ 	int param_int = 0;
+
+ 	if (param == 'R')
+ 		get_random_bytes( (char *)&param_int, sizeof(int));
+ 	else
+ 		param_int = param | param<<8 | param<<16 | param<<24;
+
+         inode->i_uid = param_int;
+         inode->i_gid = param_int;
+         inode->i_atime.tv_sec = param_int;
+         inode->i_atime.tv_nsec = param_int;
+         inode->i_mtime.tv_sec = param_int;
+         inode->i_mtime.tv_nsec = param_int;
+         inode->i_ctime.tv_sec = param_int;
+         inode->i_ctime.tv_nsec = param_int;
+
+         return retval;
+ }
+
+ static
+ int ext4_secure_truncate(struct inode *inode, sector_t first, sector_t
last)
+ {
+
+ 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+ 	int err = 0;
+ 	int num_ovwt = 0;
+ 	int char_pos = 0;
+ 	handle_t *handle;
+
+ 	/*
+ 	 * Copy all secure deletion options so I don't have to
de-reference
+ 	 * every time.
+ 	 */
+ 	int data_num = sbi->s_data_num_ovwt;
+ 	int data_size = sbi->s_data_char_size;
+ 	char *data_c = sbi->s_data_char;
+
+ 	/*
+ 	 * I'm adding the inode to the orphan in a dirty way (making it a
+ 	 * transaction of it's own), since I don't want to add it inside
the
+ 	 * loop. I should put it within the first transaction since
+ 	 * I'll probably have a performance hit if I keep it here.
+ 	 */
+ 	handle = ext4_journal_start(inode, DIO_CREDITS);
+
+ 	if (IS_ERR(handle)) {
+ 		err = PTR_ERR(handle);
+ 		goto out;
+ 	}
+
+ 	/*
+ 	 * Ok start secure truncation. Add the inode to the orhpan list
+ 	 * for any possible crashes during the operation.
+ 	 */
+ 	if ( ext4_orphan_add(handle, inode) )
+ 		goto out;
+
+ 	ext4_journal_stop(handle);
+
+ 	handle = NULL;
+
+ next_ovwt:
+ 	char_pos = 0;
+ 	while ( char_pos < data_size ) {
+
+ 		handle = ext4_journal_start(inode, DIO_CREDITS);
+
+ 		if (IS_ERR(handle)) {
+ 			err = PTR_ERR(handle);
+ 			goto del_orphan_out;
+ 		}
+ 		if ( char_pos < data_size && num_ovwt < data_num) {
+ 			err = ext4_ovwt_blocks(handle, inode,
+ 			*(data_c + char_pos), first, last);
+ 			if (err)
+ 				goto stop_out;
+ 		}
+
+ 		ext4_journal_stop(handle);
+
+
jbd2_journal_lock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		err = jbd2_journal_flush(EXT4_SB(inode->i_sb)->s_journal);
+
jbd2_journal_unlock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		if (err)
+ 			goto del_orphan_out;
+ 		err = sync_blockdev(inode->i_sb->s_bdev);
+ 		if (err)
+ 			goto del_orphan_out;
+
+ 		char_pos++;
+ 	}
+ 	num_ovwt++;
+
+ 	if (num_ovwt < data_num)
+ 		goto next_ovwt;
+
+ 	return err;
+ stop_out:
+ 	ext4_journal_stop(handle);
+ del_orphan_out:
+ 	ext4_orphan_del(handle, inode);
+ out:
+ 	return err;
+ }
+
+ int ext4_secrm_metadata(struct inode *inode)
+ {
+
+ 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+ 	int err = 0;
+ 	int num_ovwt = 0;
+ 	int char_pos = 0;
+ 	handle_t *handle;
+
+ 	/*
+ 	 * Copy all secure deletion options so I don't have to dereference
+ 	 * every time.
+ 	 */
+ 	int meta_num = sbi->s_meta_num_ovwt;
+ 	int meta_size = sbi->s_meta_char_size;
+ 	char *meta_c = sbi->s_meta_char;
+
+ 	/* I'm adding the inode to the orphan in a dirty way (making it a
+ 	 * transaction of it's own), since I don't want to add it inside
the
+ 	 * loop. Normally I should put it within the first transaction
since
+ 	 * I'll probably have a performance hit if I keep it here.
+ 	 */
+ 	handle = ext4_journal_start(inode, DIO_CREDITS);
+
+ 	if (IS_ERR(handle)) {
+ 		err = PTR_ERR(handle);
+ 		goto out;
+ 	}
+
+ 	if ( ext4_orphan_add(handle, inode) )
+ 		goto out;
+
+ 	ext4_journal_stop(handle);
+
+ 	handle = NULL;
+
+
+ next_ovwt:
+ 	char_pos = 0;
+ 	while (char_pos < meta_size ) {
+
+ 		handle = ext4_journal_start(inode, DIO_CREDITS);
+
+ 		if (IS_ERR(handle)) {
+ 			err = PTR_ERR(handle);
+ 			goto del_orphan_out;
+ 		}
+
+ 		if ( char_pos < meta_size && num_ovwt < meta_num) {
+ 			err = ext4_ovwt_metadata(handle, inode,
+ 							 *(meta_c +
char_pos));
+ 			if (err)
+ 				goto stop_out;
+ 			mark_inode_dirty(inode);
+ 		}
+
+ 		ext4_journal_stop(handle);
+
+
jbd2_journal_lock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		err = jbd2_journal_flush(EXT4_SB(inode->i_sb)->s_journal);
+
jbd2_journal_unlock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		if (err)
+ 			goto del_orphan_out;
+ 		err = sync_blockdev(inode->i_sb->s_bdev);
+ 		if (err)
+ 			goto del_orphan_out;
+ 		char_pos++;
+ 	}
+ 	num_ovwt++;
+
+ 	if (num_ovwt < meta_num)
+ 		goto next_ovwt;
+ 	return err;
+ stop_out:
+ 	ext4_journal_stop(handle);
+ del_orphan_out:
+ 	ext4_orphan_del(handle,inode);
+ out:
+ 	return err;
+ }
+ #endif
+
  static int walk_page_buffers(	handle_t *handle,
  				struct buffer_head *head,
  				unsigned from,
***************
*** 2304,2309 ****
--- 2585,2594 ----
  	long last_block;
  	unsigned blocksize = inode->i_sb->s_blocksize;
  	struct page *page;
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	sector_t first;
+ 	sector_t last;
+ #endif

  	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
  	    S_ISLNK(inode->i_mode)))
***************
*** 2327,2332 ****
--- 2612,2631 ----
  			return;
  	}

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	last_block = (inode->i_size + blocksize-1)
+ 					>>
EXT4_BLOCK_SIZE_BITS(inode->i_sb);
+
+ 	first = last_block;
+ 	last = (ei->i_disksize + blocksize-1)
+ 					>>
EXT4_BLOCK_SIZE_BITS(inode->i_sb);
+
+ 	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+ 		if (ext4_secure_truncate(inode, first, last))
+ 			return;
+ 	}
+ #endif
+
  	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
  		return ext4_ext_truncate(inode, page);

***************
*** 2341,2348 ****
--- 2640,2649 ----
  		return;		/* AKPM: return what? */
  	}

+ #ifndef CONFIG_EXT4DEV_FS_SECDEL
  	last_block = (inode->i_size + blocksize-1)
  					>>
EXT4_BLOCK_SIZE_BITS(inode->i_sb);
+ #endif

  	if (page)
  		ext4_block_truncate_page(handle, page, mapping,
inode->i_size);
***************
*** 2351,2356 ****
--- 2652,2670 ----
  	if (n == 0)
  		goto out_stop;	/* error */

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+  /*
+          * If secure removal is compiled in the file-system, we have
+          * already added the inode to the orphan list because we need to
+          * make the overwrites and the truncation an atomic operation.
+          * Otherwise under any system crash our inode will not be
correctly
+          * deleted.
+          */
+ 	if ( !(EXT4_I(inode)->i_flags & EXT4_SECRM_FL)) {
+ 		if (ext4_orphan_add(handle, inode))
+ 			goto out_stop;
+ 	}
+ #else
  	/*
  	 * OK.  This truncate is going to happen.  We add the inode to the
  	 * orphan list, so that if this truncate spans multiple
transactions,
***************
*** 2362,2367 ****
--- 2676,2682 ----
  	 */
  	if (ext4_orphan_add(handle, inode))
  		goto out_stop;
+ #endif

  	/*
  	 * The orphan list entry will now protect us from any crash which
Index: sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/namei.c
diff -c sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/namei.c:1.1
sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/namei.c:1.4
*** sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/namei.c:1.1	Fri Jan 26
16:31:53 2007
--- sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/namei.c	Sun Jan 28
19:05:14 2007
***************
*** 37,42 ****
--- 37,43 ----
  #include <linux/buffer_head.h>
  #include <linux/bio.h>
  #include <linux/smp_lock.h>
+ #include <linux/random.h>

  #include "namei.h"
  #include "xattr.h"
***************
*** 2070,2092 ****
  	return retval;
  }

  static int ext4_unlink(struct inode * dir, struct dentry *dentry)
  {
  	int retval;
  	struct inode * inode;
  	struct buffer_head * bh;
  	struct ext4_dir_entry_2 * de;
! 	handle_t *handle;

  	/* Initialize quotas before so that eventual writes go
  	 * in separate transaction */
  	DQUOT_INIT(dentry->d_inode);
  	handle = ext4_journal_start(dir,
EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
  	if (IS_ERR(handle))
  		return PTR_ERR(handle);

  	if (IS_DIRSYNC(dir))
  		handle->h_sync = 1;

  	retval = -ENOENT;
  	bh = ext4_find_entry (dentry, &de);
--- 2071,2180 ----
  	return retval;
  }

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ static int ext4_ovwt_dentry(handle_t *handle, struct buffer_head *bh,
+ 				struct ext4_dir_entry_2 *de, char param)
+ {
+ 	int retval = 0;
+ 	get_bh(bh);
+
+ 	if ( (retval = ext4_journal_get_write_access(handle, bh)) )
+ 		goto out;
+
+ 	if (test_set_buffer_locked(bh))
+ 		goto out;
+
+ 	if (param == 'R')
+ 		get_random_bytes(de->name, de->name_len);
+ 	else
+ 		memset(de->name, param, de->name_len);
+ 	unlock_buffer(bh);
+
+ 	retval = ext4_journal_dirty_data(handle, bh);
+ out:
+ 	return retval;
+ }
+
+ static int ext4_secrm_dentry(struct inode *inode, struct buffer_head
*bh,
+ 			struct ext4_dir_entry_2 *de)
+ {
+ 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+ 	int err = 0;
+ 	int num_ovwt = 0;
+ 	int char_pos = 0;
+ 	handle_t *handle;
+
+ 	/*
+ 	 * Copy secure removal options for the filename so I don't have to
+ 	 * dereference every time.
+ 	 */
+ 	int file_num = sbi->s_file_num_ovwt;
+ 	int file_size = sbi->s_file_char_size;
+ 	char *file_c = sbi->s_file_char;
+
+ next_ovwt:
+ 	char_pos = 0;
+ 	while ( char_pos < file_size ) {
+
+ 		handle = ext4_journal_start(inode, 1);
+
+ 		if (IS_ERR(handle)) {
+ 			err = PTR_ERR(handle);
+ 			goto out;
+ 		}
+
+ 		err = ext4_ovwt_dentry(handle, bh, de, *(file_c +
char_pos));
+ 		if (err)
+ 			goto stop_out;
+
+ 		ext4_journal_stop(handle);
+
+ 		/*
+ 		 * TODO: I don't think we need to explicitly flush the
+ 		 * journal. Since each transaction is atomic, the jbd
+ 		 * will take care of checkpointing the journal. Should
+ 		 * check this out. If we can we should get rid of this,
+ 		 * since it might be a performance hit for no reason.
+ 		 */
+
jbd2_journal_lock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		err = jbd2_journal_flush(EXT4_SB(inode->i_sb)->s_journal);
+
jbd2_journal_unlock_updates(EXT4_SB(inode->i_sb)->s_journal);
+ 		if (err)
+ 			goto out;
+ 		char_pos++;
+ 	}
+ 	num_ovwt++;
+
+ 	if (num_ovwt < file_num)
+ 		goto next_ovwt;
+ 	return err;
+ stop_out:
+ 	ext4_journal_stop(handle);
+ out:
+ 	return err;
+ }
+ #endif
+
  static int ext4_unlink(struct inode * dir, struct dentry *dentry)
  {
  	int retval;
  	struct inode * inode;
  	struct buffer_head * bh;
  	struct ext4_dir_entry_2 * de;
! 	handle_t *handle = NULL;

  	/* Initialize quotas before so that eventual writes go
  	 * in separate transaction */
  	DQUOT_INIT(dentry->d_inode);
+
+ #ifndef CONFIG_EXT4DEV_FS_SECDEL
  	handle = ext4_journal_start(dir,
EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
  	if (IS_ERR(handle))
  		return PTR_ERR(handle);

  	if (IS_DIRSYNC(dir))
  		handle->h_sync = 1;
+ #endif

  	retval = -ENOENT;
  	bh = ext4_find_entry (dentry, &de);
***************
*** 2105,2110 ****
--- 2193,2211 ----
  			      inode->i_ino, inode->i_nlink);
  		inode->i_nlink = 1;
  	}
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	if (EXT4_I(dentry->d_inode)->i_flags & EXT4_SECRM_FL) {
+ 		retval = ext4_secrm_dentry(inode, bh, de);
+ 		if (retval)
+ 			goto end_nostop;
+ 	}
+ 	handle = ext4_journal_start(dir,
EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+ 	if (IS_ERR(handle))
+ 		return PTR_ERR(handle);
+
+ 	if (IS_DIRSYNC(dir))
+ 		handle->h_sync = 1;
+ #endif
  	retval = ext4_delete_entry(handle, dir, de, bh);
  	if (retval)
  		goto end_unlink;
***************
*** 2120,2125 ****
--- 2221,2229 ----

  end_unlink:
  	ext4_journal_stop(handle);
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ end_nostop:
+ #endif
  	brelse (bh);
  	return retval;
  }
Index: sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/super.c
diff -c sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/super.c:1.1
sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/super.c:1.3
*** sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/super.c:1.1	Fri Jan 26
16:31:53 2007
--- sdfs/src/linux-2.6.20-rc6-secdel/fs/ext4/super.c	Fri Jan 26
17:52:30 2007
***************
*** 61,66 ****
--- 61,70 ----
  static void ext4_unlockfs(struct super_block *sb);
  static void ext4_write_super (struct super_block * sb);
  static void ext4_write_super_lockfs(struct super_block *sb);
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ static int ext4_store_secrm_options(struct ext4_sb_info *sbi, char
*args);
+ static void ext4_secrm_put_super(struct ext4_sb_info *sbi);
+ #endif


  ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
***************
*** 462,467 ****
--- 466,475 ----
  		kfree(sbi->s_qf_names[i]);
  #endif

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	ext4_secrm_put_super(sbi);
+ #endif
+
  	/* Debugging code just in case the in-memory inode orphan list
  	 * isn't empty.  The on-disk one can be non-empty if we've
  	 * detected an error and taken the fs readonly, but the
***************
*** 728,734 ****
  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
! 	Opt_grpquota, Opt_extents,
  };

  static match_table_t tokens = {
--- 736,742 ----
  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
! 	Opt_grpquota, Opt_extents, Opt_secrm,
  };

  static match_table_t tokens = {
***************
*** 779,784 ****
--- 787,793 ----
  	{Opt_usrquota, "usrquota"},
  	{Opt_barrier, "barrier=%u"},
  	{Opt_extents, "extents"},
+ 	{Opt_secrm, "secdel=%s"},
  	{Opt_err, NULL},
  	{Opt_resize, "resize"},
  };
***************
*** 817,822 ****
--- 826,834 ----
  	int qtype;
  	char *qname;
  #endif
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	char *sd_params;
+ #endif

  	if (!options)
  		return 1;
***************
*** 1114,1119 ****
--- 1126,1156 ----
  		case Opt_extents:
  			set_opt (sbi->s_mount_opt, EXTENTS);
  			break;
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 		case Opt_secrm:
+ 			sd_params = match_strdup(&args[0]);
+ 			if (!sd_params) {
+ 				printk(KERN_ERR
+ 					"EXT4-fs: not enough memory to "
+ 					"store secure removal
options.\n");
+ 					return 0;
+ 			}
+ 			if (ext4_store_secrm_options(sbi, sd_params)) {
+ 				printk(KERN_ERR
+ 					"EXT4-fs: invalid option(s) for "
+ 					"secure removal.\n");
+ 				kfree(sd_params);
+ 				return 0;
+ 			}
+ 			kfree(sd_params);
+ 			break;
+ #else
+ 			case Opt_secrm:
+ 			printk(KERN_ERR
+ 				"EXT3-fs: secure removal option not "
+ 				"supported.\n");
+ 			break;
+ #endif
  		default:
  			printk (KERN_ERR
  				"EXT4-fs: Unrecognized mount option \"%s\"
"
***************
*** 1539,1544 ****
--- 1576,1588 ----
  	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
  	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	/* Set default options for secure deletion. */
+ 	sbi->s_data_num_ovwt = 0;
+ 	sbi->s_meta_num_ovwt = 0;
+ 	sbi->s_file_num_ovwt = 0;
+ #endif
+
  	set_opt(sbi->s_mount_opt, RESERVATION);

  	if (!parse_options ((char *) data, sb, &journal_inum,
&journal_devnum,
***************
*** 2793,2798 ****
--- 2837,3040 ----

  #endif

+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ enum {
+ 	opt_num, opt_chars, opt_err,
+ };
+
+ enum {
+ 	/*
+ 	 * Ordering is important!
+ 	 */
+ 	data_num, data_str, meta_num, meta_str, file_num, file_str,
+ };
+
+ static match_table_t sd_tokens = {
+ 	{opt_num, "%u"},
+ 	{opt_chars, "%s"},
+ 	{opt_err, NULL},
+ };
+
+ static int ext4_store_secrm_options(struct ext4_sb_info *sbi, char
*options)
+ {
+ 	int err = 0;
+ 	int args_parsed = 0;
+ 	int token;
+ 	char * p;
+ 	substring_t args[MAX_OPT_ARGS];
+
+ 	u32 num_ovwt = 0;
+ 	u32 data_ovwt = 0;
+ 	u32 meta_ovwt = 0;
+ 	u32 file_ovwt = 0;
+ 	char *ovwt_chars = NULL;
+ 	char *data_chars = NULL;
+ 	char *meta_chars = NULL;
+ 	char *file_chars = NULL;
+
+ 	if (!options)
+ 		return 1;
+ 	while ((p = strsep (&options, ":")) != NULL) {
+
+ 		token = match_token(p, sd_tokens, args);
+ 		if (!*p) {
+ 			args_parsed++;
+ 			continue;
+ 		}
+
+ 		switch (token) {
+ 		case opt_num:
+ 			switch(args_parsed) {
+ 			case data_num:
+ 				err = match_int(&args[0], &data_ovwt);
+ 				if (err)
+ 					goto err_out;
+ 			break;
+ 			case meta_num:
+ 				err = match_int(&args[0], &meta_ovwt);
+ 				if (err)
+ 					goto err_out;
+ 			break;
+ 			case file_num:
+ 				err = match_int(&args[0], &file_ovwt);
+ 				if (err)
+ 					goto err_out;
+ 			break;
+ 			default:
+ 				err = -EINVAL;
+ 				goto err_out;
+ 			}
+ 		break;
+ 		case opt_chars:
+ 			switch(args_parsed) {
+ 			case data_str:
+ 				data_chars = match_strdup(&args[0]);
+ 				if (!data_chars) {
+ 					err = -ENOMEM;
+ 					goto err_out;
+ 				}
+ 			break;
+ 			case meta_str:
+ 				meta_chars = match_strdup(&args[0]);
+ 				if (!meta_chars) {
+ 					err = -ENOMEM;
+ 					goto err_out;
+ 				}
+ 			break;
+ 			case file_str:
+ 				file_chars = match_strdup(&args[0]);
+ 				if (!file_chars) {
+ 					err = -ENOMEM;
+ 					goto err_out;
+ 				}
+ 			break;
+ 			default:
+ 				err = -EINVAL;
+ 				goto err_out;
+ 			}
+ 		break;
+ 		default:
+ 			err = -EINVAL;
+ 			goto err_out;
+ 		}
+ 		args_parsed++;
+ 	}
+
+ 	if (args_parsed == 6) {
+ 		if ((!data_ovwt && data_chars) || (data_ovwt &&
!data_chars)) {
+ 			err = -EINVAL;
+ 			goto err_out;
+ 		}
+ 		if ((!meta_ovwt && meta_chars) || (meta_ovwt &&
!meta_chars)) {
+ 			err = -EINVAL;
+ 			goto err_out;
+ 		}
+ 		if ((!file_ovwt && file_chars) || (file_ovwt &&
!file_chars)) {
+ 			err = -EINVAL;
+ 			goto err_out;
+ 		}
+ 	}
+ 	else if (args_parsed == 2) {
+ 		if (data_ovwt < 1 || !data_chars) {
+ 			err = -EINVAL;
+ 			goto err_out;
+ 		}
+ 		num_ovwt = data_ovwt;
+ 		ovwt_chars = data_chars;
+ 	}
+ 	else {
+ 		err = -EINVAL;
+ 		goto err_out;
+ 	}
+
+ 	/* Now populate the sbi */
+ 	if (data_ovwt)
+ 		sbi->s_data_num_ovwt = data_ovwt;
+ 	else
+ 		sbi->s_data_num_ovwt = num_ovwt;
+
+ 	if (meta_ovwt)
+ 		sbi->s_meta_num_ovwt = meta_ovwt;
+ 	else
+ 		sbi->s_meta_num_ovwt = num_ovwt;
+
+ 	if (file_ovwt)
+ 		sbi->s_file_num_ovwt = file_ovwt;
+ 	else
+ 		sbi->s_file_num_ovwt = num_ovwt;
+
+ 	if (data_chars) {
+ 		sbi->s_data_char = data_chars;
+ 		sbi->s_data_char_size = strlen(data_chars);
+ 	}
+ 	else if (ovwt_chars) {
+ 		sbi->s_data_char = ovwt_chars;
+ 		sbi->s_data_char_size = strlen(ovwt_chars);
+ 	}
+
+ 	if (meta_chars) {
+ 		sbi->s_meta_char = meta_chars;
+ 		sbi->s_meta_char_size = strlen(meta_chars);
+ 	}
+ 	else if (ovwt_chars) {
+ 		sbi->s_meta_char = ovwt_chars;
+ 		sbi->s_meta_char_size = strlen(ovwt_chars);
+ 	}
+
+ 	if (file_chars) {
+ 		sbi->s_file_char = file_chars;
+ 		sbi->s_file_char_size = strlen(file_chars);
+ 	}
+ 	else if (ovwt_chars) {
+ 		sbi->s_file_char = ovwt_chars;
+ 		sbi->s_file_char_size = strlen(ovwt_chars);
+ 	}
+
+ 	return err;
+
+ err_out:
+ 	if (data_chars)
+ 		kfree(data_chars);
+ 	if (meta_chars)
+ 		kfree(meta_chars);
+ 	if (file_chars)
+ 		kfree(file_chars);
+ out:
+ 	return err;
+ }
+
+ static void ext4_secrm_put_super(struct ext4_sb_info *sbi)
+ {
+ 	if (sbi->s_data_char)
+ 		kfree(sbi->s_data_char);
+ 	if (sbi->s_meta_char &&  sbi->s_data_char != sbi->s_meta_char)
+ 		kfree(sbi->s_meta_char);
+ 	if (sbi->s_file_char && sbi->s_data_char != sbi->s_file_char &&
+ 	    sbi->s_meta_char != sbi->s_file_char)
+ 		kfree(sbi->s_file_char);
+ }
+ #endif
+
  static int ext4_get_sb(struct file_system_type *fs_type,
  	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
  {
Index: sdfs/src/linux-2.6.20-rc6-secdel/include/linux/ext4_fs_sb.h
diff -c sdfs/src/linux-2.6.20-rc6-secdel/include/linux/ext4_fs_sb.h:1.1
sdfs/src/linux-2.6.20-rc6-secdel/include/linux/ext4_fs_sb.h:1.2
*** sdfs/src/linux-2.6.20-rc6-secdel/include/linux/ext4_fs_sb.h:1.1
Fri Jan 26 16:31:53 2007
--- sdfs/src/linux-2.6.20-rc6-secdel/include/linux/ext4_fs_sb.h	Fri Jan 26
17:52:30 2007
***************
*** 89,94 ****
--- 89,111 ----
  	unsigned long s_ext_blocks;
  	unsigned long s_ext_extents;
  #endif
+
+ #ifdef CONFIG_EXT4DEV_FS_SECDEL
+ 	/* Number of overwrites for each field */
+ 	u32 s_data_num_ovwt;
+ 	u32 s_meta_num_ovwt;
+ 	u32 s_file_num_ovwt;
+
+ 	/* Characters to be written to each field */
+ 	char *s_data_char;
+ 	char *s_meta_char;
+ 	char *s_file_char;
+
+ 	/* Size of above character array for each field */
+ 	u32 s_data_char_size;
+ 	u32 s_meta_char_size;
+ 	u32 s_file_char_size;
+ #endif
  };

  #endif	/* _LINUX_EXT4_FS_SB */
