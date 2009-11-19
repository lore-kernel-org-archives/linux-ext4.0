From: scjody@sun.com
Subject: [patch 4/5] [ext3] Add journal guided resync (data=declared mode)
Date: Thu, 19 Nov 2009 16:22:45 -0500
Message-ID: <20091119212405.119227377@sun.com>
References: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''ext3-journal-guided-resync.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline; filename=ext3-journal-guided-resync.patch
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We introduce a new data write mode known as declared mode.  This is based on
ordered mode except that a list of blocks to be written during the current
transaction is added to the journal before the blocks themselves are written to
the disk.  Then, if the system crashes, we can resync only those blocks during
journal replay and skip the rest of the resync of the RAID array.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6.18-128.7.1/fs/ext3/file.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/ext3/file.c
+++ linux-2.6.18-128.7.1/fs/ext3/file.c
@@ -78,7 +78,8 @@ ext3_file_write(struct kiocb *iocb, cons
 		 * Open question --- do we care about flushing timestamps too
 		 * if the inode is IS_SYNC?
 		 */
-		if (!ext3_should_journal_data(inode))
+		if (!ext3_should_journal_data(inode) &&
+		    !ext3_should_declare_data(inode))
 			return ret;
 
 		goto force_commit;
Index: linux-2.6.18-128.7.1/fs/ext3/fsync.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/ext3/fsync.c
+++ linux-2.6.18-128.7.1/fs/ext3/fsync.c
@@ -66,8 +66,13 @@ int ext3_sync_file(struct file * file, s
 	 *  filemap_fdatawait() will encounter a ton of newly-dirtied pages
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
+	 *
+	 * data=declared:
+	 *  Declare blocks are written before data blocks, then the
+	 *  sync proceeds as for data=ordered.
 	 */
-	if (ext3_should_journal_data(inode)) {
+	if (ext3_should_journal_data(inode) ||
+	    ext3_should_declare_data(inode)) {
 		ret = ext3_force_commit(inode->i_sb);
 		goto out;
 	}
Index: linux-2.6.18-128.7.1/fs/ext3/inode.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/ext3/inode.c
+++ linux-2.6.18-128.7.1/fs/ext3/inode.c
@@ -1105,6 +1105,12 @@ static int walk_page_buffers(	handle_t *
 	return ret;
 }
 
+static int do_set_fs_raidsync(handle_t *handle, struct buffer_head *bh)
+{
+	set_buffer_fs_raidsync(bh);
+	return 0;
+}
+
 /*
  * To preserve ordering, it is essential that the hole instantiation and
  * the data write be encapsulated in a single transaction.  We cannot
@@ -1163,6 +1169,10 @@ retry:
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
+	if (ext3_should_declare_data(inode)) {
+		ret = walk_page_buffers(handle, page_buffers(page),
+				from, to, NULL, do_set_fs_raidsync);
+	}
 prepare_write_failed:
 	if (ret)
 		ext3_journal_stop(handle);
@@ -1190,6 +1200,15 @@ static int commit_write_fn(handle_t *han
 	return ext3_journal_dirty_metadata(handle, bh);
 }
 
+/* For commit_write() in data=declared mode */
+static int declared_commit_write_fn(handle_t *handle, struct buffer_head *bh)
+{
+	if (!buffer_mapped(bh) || buffer_freed(bh))
+		return 0;
+	set_buffer_uptodate(bh);
+	return ext3_journal_dirty_data(handle, bh);
+}
+
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `file' can be NULL - eg, when called from page_symlink().
@@ -1220,6 +1239,37 @@ static int ext3_ordered_commit_write(str
 			EXT3_I(inode)->i_disksize = new_i_size;
 		ret = generic_commit_write(file, page, from, to);
 	}
+
+	ret2 = ext3_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	return ret;
+}
+
+static int ext3_declared_commit_write(struct file *file, struct page *page,
+			     unsigned from, unsigned to)
+{
+	handle_t *handle = ext3_journal_current_handle();
+	struct inode *inode = page->mapping->host;
+	int ret = 0, ret2;
+	int partial = 0;
+	loff_t pos;
+
+	ret = walk_page_buffers(handle, page_buffers(page),
+				from, to, &partial, declared_commit_write_fn);
+
+	if (ret == 0) {
+		pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		if (pos > EXT3_I(inode)->i_disksize)
+			EXT3_I(inode)->i_disksize = pos;
+		if (!partial)
+			SetPageUptodate(page);
+		if (pos > inode->i_size) {
+			i_size_write(inode, pos);
+			mark_inode_dirty(inode);
+		}
+	}
+
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
@@ -1348,6 +1398,7 @@ static int bput_one(handle_t *handle, st
 
 static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 {
+	sector_t s = bh->b_blocknr * (bh->b_size >> 9);
 	if (buffer_mapped(bh))
 		return ext3_journal_dirty_data(handle, bh);
 	return 0;
@@ -1471,6 +1522,78 @@ out_fail:
 	return ret;
 }
 
+/*
+ * Based on ext3_ordered_writepage but adds do_set_fs_raidsync().  TODO: We
+ * should probably find a way to share this code.
+ */
+static int ext3_declared_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct buffer_head *page_bufs;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	J_ASSERT(PageLocked(page));
+
+	/*
+	 * We give up here if we're reentered, because it might be for a
+	 * different filesystem.
+	 */
+	if (ext3_journal_current_handle())
+		goto out_fail;
+
+	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				(1 << BH_Dirty)|(1 << BH_Uptodate));
+	}
+	page_bufs = page_buffers(page);
+	walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, do_set_fs_raidsync);
+
+	ret = block_write_full_page(page, ext3_get_block, wbc);
+
+	/*
+	 * The page can become unlocked at any point now, and
+	 * truncate can then come in and change things.  So we
+	 * can't touch *page from now on.  But *page_bufs is
+	 * safe due to elevated refcount.
+	 */
+
+	/*
+	 * And attach them to the current transaction.  But only if
+	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
+	 * and generally junk.
+	 */
+	if (ret == 0) {
+		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+					NULL, journal_dirty_data_fn);
+		if (!ret)
+			ret = err;
+	}
+	walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, bput_one);
+	err = ext3_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
+
+out_fail:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return ret;
+}
+
 static int ext3_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -1741,14 +1864,30 @@ static const struct address_space_operat
 	.releasepage	= ext3_releasepage,
 };
 
+static const struct address_space_operations ext3_declared_aops = {
+	.readpage	= ext3_readpage,
+	.readpages	= ext3_readpages,
+	.writepage	= ext3_declared_writepage,
+	.sync_page	= block_sync_page,
+	.prepare_write	= ext3_prepare_write,
+	.commit_write	= ext3_declared_commit_write,
+	.bmap		= ext3_bmap,
+	.invalidatepage	= ext3_invalidatepage,
+	.releasepage	= ext3_releasepage,
+	.direct_IO	= ext3_direct_IO,
+	.migratepage	= buffer_migrate_page,
+};
+
 void ext3_set_aops(struct inode *inode)
 {
 	if (ext3_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext3_ordered_aops;
 	else if (ext3_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext3_writeback_aops;
-	else
+	else if (ext3_should_journal_data(inode))
 		inode->i_mapping->a_ops = &ext3_journalled_aops;
+	else
+		inode->i_mapping->a_ops = &ext3_declared_aops;
 }
 
 /*
@@ -1845,9 +1984,12 @@ static int ext3_block_truncate_page(hand
 	if (ext3_should_journal_data(inode)) {
 		err = ext3_journal_dirty_metadata(handle, bh);
 	} else {
-		if (ext3_should_order_data(inode))
+		if (ext3_should_order_data(inode) ||
+		    ext3_should_declare_data(inode))
 			err = ext3_journal_dirty_data(handle, bh);
-		mark_buffer_dirty(bh);
+
+		if (!ext3_should_declare_data(inode))
+			mark_buffer_dirty(bh);
 	}
 
 unlock:
Index: linux-2.6.18-128.7.1/fs/ext3/super.c
===================================================================
--- linux-2.6.18-128.7.1.orig/fs/ext3/super.c
+++ linux-2.6.18-128.7.1/fs/ext3/super.c
@@ -391,6 +391,9 @@ static void ext3_put_super (struct super
 	int i, err;
 
 	ext3_xattr_put_super(sb);
+	journal_clear_features(sbi->s_journal, 0, 0,
+			       JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS);
+	journal_update_superblock(sbi->s_journal, 1);
 	err = journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
 	if (err < 0)
@@ -553,6 +556,8 @@ static int ext3_show_options(struct seq_
 		seq_puts(seq, ",data=ordered");
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");
+	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_DECLARED_DATA)
+		seq_puts(seq, ",data=declared");
 
 	ext3_show_quota_options(seq, sb);
 
@@ -682,7 +687,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_data_declared
 };
 
 static match_table_t tokens = {
@@ -721,6 +726,7 @@ static match_table_t tokens = {
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
+	{Opt_data_declared, "data=declared"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -922,6 +928,9 @@ static int parse_options (char *options,
 			goto datacheck;
 		case Opt_data_writeback:
 			data_opt = EXT3_MOUNT_WRITEBACK_DATA;
+			goto datacheck;
+		case Opt_data_declared:
+			data_opt = EXT3_MOUNT_DECLARED_DATA;
 		datacheck:
 			if (is_remount) {
 				if ((sbi->s_mount_opt & EXT3_MOUNT_DATA_FLAGS)
@@ -1740,7 +1749,21 @@ static int ext3_fill_super (struct super
 		else
 			set_opt(sbi->s_mount_opt, JOURNAL_DATA);
 		break;
-
+	case EXT3_MOUNT_DECLARED_DATA:
+		if (!journal_check_available_features(sbi->s_journal, 0, 0,
+					JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+			printk(KERN_ERR "EXT3-fs: Journal does not support "
+			       "declared data journaling mode\n");
+			goto failed_mount4;
+		}
+		spin_lock(&sbi->s_journal->j_state_lock);
+		sbi->s_journal->j_flags |= JFS_DECLARE;
+		spin_unlock(&sbi->s_journal->j_state_lock);
+		if (!journal_set_features(sbi->s_journal, 0, 0,
+					 JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+			printk(KERN_ERR "EXT3-fs: Cannot set declared mode.\n");
+			goto failed_mount4;
+		}
 	case EXT3_MOUNT_ORDERED_DATA:
 	case EXT3_MOUNT_WRITEBACK_DATA:
 		if (!journal_check_available_features
@@ -1795,9 +1818,10 @@ static int ext3_fill_super (struct super
 		printk (KERN_INFO "EXT3-fs: recovery complete.\n");
 	ext3_mark_recovery_complete(sb, es);
 	printk (KERN_INFO "EXT3-fs: mounted filesystem with %s data mode.\n",
-		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
-		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
-		"writeback");
+		test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal" :
+		test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered" :
+		test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_DECLARED_DATA ?
+			"declared" : "writeback");
 
 	lock_kernel();
 	return 0;
Index: linux-2.6.18-128.7.1/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/ext3_fs.h
+++ linux-2.6.18-128.7.1/include/linux/ext3_fs.h
@@ -357,11 +357,11 @@ struct ext3_inode {
 #define EXT3_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT3_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
 #define EXT3_MOUNT_ABORT		0x00200	/* Fatal error detected */
-#define EXT3_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
+#define EXT3_MOUNT_DATA_FLAGS		0x01C00	/* Mode for data writes: */
 #define EXT3_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT3_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
 #define EXT3_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
-#define EXT3_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
+#define EXT3_MOUNT_DECLARED_DATA	0x01000	/* Declare data blocks before writing */
 #define EXT3_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
 #define EXT3_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
 #define EXT3_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
@@ -383,6 +383,7 @@ struct ext3_inode {
 #define EXT2_MOUNT_ABORT		EXT3_MOUNT_ABORT
 #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
 #endif
+#define EXT3_MOUNT_UPDATE_JOURNAL	0x40000000 /* Update the journal format */
 
 #define ext3_set_bit			ext2_set_bit
 #define ext3_set_bit_atomic		ext2_set_bit_atomic
Index: linux-2.6.18-128.7.1/include/linux/ext3_jbd.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/ext3_jbd.h
+++ linux-2.6.18-128.7.1/include/linux/ext3_jbd.h
@@ -265,4 +265,15 @@ static inline int ext3_should_writeback_
 	return 0;
 }
 
+static inline int ext3_should_declare_data(struct inode *inode)
+{
+	if (!S_ISREG(inode->i_mode))
+		return 0;
+	if (EXT3_I(inode)->i_flags & EXT3_JOURNAL_DATA_FL)
+		return 0;
+	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT3_MOUNT_DECLARED_DATA)
+		return 1;
+	return 0;
+}
+
 #endif	/* _LINUX_EXT3_JBD_H */

-- 
