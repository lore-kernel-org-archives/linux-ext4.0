From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH v2 3/3] ext4: Fix ext4 to use pass jbd allocation flags if they can handle ENOMEM.
Date: Fri, 27 May 2011 23:21:54 -0700
Message-ID: <1306563714-4393-1-git-send-email-mkatiyar@gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
Cc: Manish Katiyar <mkatiyar@gmail.com>
To: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57922 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1E1GWF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2011 02:22:05 -0400
Received: by pzk9 with SMTP id 9so1036114pzk.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 May 2011 23:22:03 -0700 (PDT)
In-Reply-To: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch updates ext4 code to pass appropriate transaction
allocation flags to callers who are safe to deal with ENOMEM.
Pass JBD2_TOPLEVEL from the callers who are safe to do allocations
with GFP_KERNEL instead of GFP_NOFS.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c         |    6 ++++--
 fs/ext4/ext4_jbd2.h   |    8 +++++---
 fs/ext4/extents.c     |   11 ++++++-----
 fs/ext4/ialloc.c      |    2 +-
 fs/ext4/inode.c       |   40 ++++++++++++++++++++++++----------------
 fs/ext4/ioctl.c       |    6 ++++--
 fs/ext4/migrate.c     |   10 +++++-----
 fs/ext4/move_extent.c |    3 ++-
 fs/ext4/namei.c       |   47 ++++++++++++++++++++++++++++++-----------------
 fs/ext4/resize.c      |    8 ++++----
 fs/ext4/super.c       |   18 +++++++++++-------
 fs/ext4/xattr.c       |    3 ++-
 12 files changed, 98 insertions(+), 64 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 93dc9a6..95db569 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -351,7 +351,8 @@ ext4_acl_chmod(struct inode *inode)
 
 	retry:
 		handle = ext4_journal_start(inode,
-				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			if (error != -ENOMEM)
@@ -450,7 +451,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 		acl = NULL;
 
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
+				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 		goto release_and_out;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 14e6599..55084c2 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -156,7 +156,8 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
 
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
+handle_t *ext4_journal_start_sb(struct super_block *sb,
+				int nblocks, int jbd_alloc_flags);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
 
 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
@@ -197,9 +198,10 @@ static inline int ext4_handle_has_enough_credits(handle_t *handle, int needed)
 	return 1;
 }
 
-static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
+static inline handle_t *ext4_journal_start(struct inode *inode,
+					   int nblocks, int jbd_alloc_flags)
 {
-	return ext4_journal_start_sb(inode->i_sb, nblocks);
+	return ext4_journal_start_sb(inode->i_sb, nblocks, jbd_alloc_flags);
 }
 
 #define ext4_journal_stop(handle) \
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..b610294 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2546,7 +2546,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 	ext_debug("truncate since %u\n", start);
 
 	/* probably first extent we're gonna free will be last in block */
-	handle = ext4_journal_start(inode, depth + 1);
+	handle = ext4_journal_start(inode, depth + 1, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -3672,7 +3672,7 @@ void ext4_ext_truncate(struct inode *inode)
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
-	handle = ext4_journal_start(inode, err);
+	handle = ext4_journal_start(inode, err, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return;
 
@@ -3811,7 +3811,8 @@ retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
 		map.m_len = max_blocks = max_blocks - ret;
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start(inode, credits,
+					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
@@ -3889,7 +3890,7 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk += ret;
 		map.m_len = (max_blocks -= ret);
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start(inode, credits, JBD2_NO_FAIL);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
@@ -4215,7 +4216,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	ext4_flush_completed_IO(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
-	handle = ext4_journal_start(inode, credits);
+	handle = ext4_journal_start(inode, credits, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..09b73d7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1263,7 +1263,7 @@ extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
 		goto out;
 
-	handle = ext4_journal_start_sb(sb, 1);
+	handle = ext4_journal_start_sb(sb, 1, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 50d0e9c..0355858 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -129,7 +129,8 @@ static handle_t *start_transaction(struct inode *inode)
 {
 	handle_t *result;
 
-	result = ext4_journal_start(inode, blocks_for_truncate(inode));
+	result = ext4_journal_start(inode,
+				    blocks_for_truncate(inode), JBD2_NO_FAIL);
 	if (!IS_ERR(result))
 		return result;
 
@@ -204,7 +205,8 @@ void ext4_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto no_delete;
 
-	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3);
+	handle = ext4_journal_start(inode,
+				    blocks_for_truncate(inode)+3, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
@@ -1401,7 +1403,7 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 		if (map.m_len > DIO_MAX_BLOCKS)
 			map.m_len = DIO_MAX_BLOCKS;
 		dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
-		handle = ext4_journal_start(inode, dio_credits);
+		handle = ext4_journal_start(inode, dio_credits, JBD2_NO_FAIL);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			return ret;
@@ -1624,7 +1626,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	to = from + len;
 
 retry:
-	handle = ext4_journal_start(inode, needed_blocks);
+	handle = ext4_journal_start(inode, needed_blocks, JBD2_FAIL_OK);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -2558,7 +2560,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	 * references to buffers so we are safe */
 	unlock_page(page);
 
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode),
+				    JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -2988,7 +2991,7 @@ retry:
 		needed_blocks = ext4_da_writepages_trans_blocks(inode);
 
 		/* start a new transaction*/
-		handle = ext4_journal_start(inode, needed_blocks);
+		handle = ext4_journal_start(inode, needed_blocks, JBD2_NO_FAIL);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
@@ -3124,7 +3127,7 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, JBD2_FAIL_OK);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3478,7 +3481,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
-			handle = ext4_journal_start(inode, 2);
+			handle = ext4_journal_start(inode, 2, JBD2_FAIL_OK);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
 				goto out;
@@ -3521,7 +3524,7 @@ retry:
 		int err;
 
 		/* Credits for sb + inode write */
-		handle = ext4_journal_start(inode, 2);
+		handle = ext4_journal_start(inode, 2, JBD2_NO_FAIL);
 		if (IS_ERR(handle)) {
 			/* This is really bad luck. We've written the data
 			 * but cannot extend i_size. Bail out and pretend
@@ -5329,8 +5332,10 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle = ext4_journal_start(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
+					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5364,7 +5369,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	    (attr->ia_size < inode->i_size)) {
 		handle_t *handle;
 
-		handle = ext4_journal_start(inode, 3);
+		handle = ext4_journal_start(inode, 3,
+					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5384,7 +5390,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 							    attr->ia_size);
 			if (error) {
 				/* Do as much error cleanup as possible */
-				handle = ext4_journal_start(inode, 3);
+				handle = ext4_journal_start(inode, 3,
+							    JBD2_NO_FAIL);
 				if (IS_ERR(handle)) {
 					ext4_orphan_del(NULL, inode);
 					goto err_out;
@@ -5421,7 +5428,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		rc = ext4_acl_chmod(inode);
 
 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error != -ENOMEM)
+		ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
 	return error;
@@ -5737,7 +5745,7 @@ void ext4_dirty_inode(struct inode *inode)
 {
 	handle_t *handle;
 
-	handle = ext4_journal_start(inode, 2);
+	handle = ext4_journal_start(inode, 2, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		goto out;
 
@@ -5821,7 +5829,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 	/* Finally we can mark the inode as dirty. */
 
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 808c554..b88e295 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -101,7 +101,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
 			ext4_truncate(inode);
 
-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start(inode, 1,
+					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto flags_out;
@@ -157,7 +158,8 @@ flags_out:
 			goto setversion_out;
 		}
 
-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start(inode, 1,
+					    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto setversion_out;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b57b98f..f233f12 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -485,10 +485,10 @@ int ext4_ext_migrate(struct inode *inode)
 		return retval;
 
 	handle = ext4_journal_start(inode,
-					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
-					+ 1);
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+				EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
+				+ 1, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		return retval;
@@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
 	up_read((&EXT4_I(inode)->i_data_sem));
 
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		/*
 		 * It is impossible to update on-disk structures without
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 2b8304b..ff4289f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,7 +813,8 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle = ext4_journal_start(orig_inode, jblocks);
+	handle = ext4_journal_start(orig_inode, jblocks,
+				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle)) {
 		*err = PTR_ERR(handle);
 		return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..101d5d5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1750,9 +1750,11 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, int mode,
 	dquot_initialize(dir);
 
 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir,
+				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -1786,9 +1788,11 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
 	dquot_initialize(dir);
 
 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir,
+				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -1825,9 +1829,11 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dquot_initialize(dir);
 
 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir,
+				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+				EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2140,7 +2146,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);
 
-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb),
+				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2202,7 +2209,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);
 
-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb),
+				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2279,7 +2287,8 @@ static int ext4_symlink(struct inode *dir,
 			  EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb);
 	}
 retry:
-	handle = ext4_journal_start(dir, credits);
+	handle = ext4_journal_start(dir,
+				    credits, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2319,7 +2328,8 @@ retry:
 		 */
 		handle = ext4_journal_start(dir,
 				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 1);
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 1,
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto err_drop_inode;
@@ -2364,8 +2374,10 @@ static int ext4_link(struct dentry *old_dentry,
 	dquot_initialize(dir);
 
 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+	handle = ext4_journal_start(dir,
+				EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS,
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2416,8 +2428,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new_dentry->d_inode)
 		dquot_initialize(new_dentry->d_inode);
 	handle = ext4_journal_start(old_dir, 2 *
-					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+				EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
+				EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2,
+				(JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 80bbc9c..6bc36ec 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -176,7 +176,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	int err = 0, err2;
 
 	/* This transaction may be extended/restarted along the way */
-	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, JBD2_NO_FAIL);
 
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -655,7 +655,7 @@ static void update_backups(struct super_block *sb,
 	handle_t *handle;
 	int err = 0, err2;
 
-	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		group = 1;
 		err = PTR_ERR(handle);
@@ -793,7 +793,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	 */
 	handle = ext4_journal_start_sb(sb,
 				       ext4_bg_has_super(sb, input->group) ?
-				       3 + reserved_gdb : 4);
+				       3 + reserved_gdb : 4, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto exit_put;
@@ -1031,7 +1031,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	/* We will update the superblock, one block bitmap, and
 	 * one group descriptor via ext4_free_blocks().
 	 */
-	handle = ext4_journal_start_sb(sb, 3);
+	handle = ext4_journal_start_sb(sb, 3, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		ext4_warning(sb, "error %d on journal start", err);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa842f3..8beb687 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -263,7 +263,8 @@ static void ext4_put_nojournal(handle_t *handle)
  * ext4 prevents a new handle from being started by s_frozen, which
  * is in an upper layer.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+handle_t *ext4_journal_start_sb(struct super_block *sb,
+				 int nblocks, int jbd_alloc_flags)
 {
 	journal_t *journal;
 	handle_t  *handle;
@@ -295,7 +296,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks, JBD2_NO_FAIL);
+	return jbd2_journal_start(journal, nblocks, jbd_alloc_flags);
 }
 
 /*
@@ -4561,7 +4562,8 @@ static int ext4_write_dquot(struct dquot *dquot)
 
 	inode = dquot_to_inode(dquot);
 	handle = ext4_journal_start(inode,
-				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb),
+				    JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit(dquot);
@@ -4577,7 +4579,8 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	handle_t *handle;
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb),
+				    JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_acquire(dquot);
@@ -4593,7 +4596,8 @@ static int ext4_release_dquot(struct dquot *dquot)
 	handle_t *handle;
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb),
+				    JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
@@ -4624,7 +4628,7 @@ static int ext4_write_info(struct super_block *sb, int type)
 	handle_t *handle;
 
 	/* Data block + inode block */
-	handle = ext4_journal_start(sb->s_root->d_inode, 2);
+	handle = ext4_journal_start(sb->s_root->d_inode, 2, JBD2_NO_FAIL);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
@@ -4702,7 +4706,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
 
 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle))
 		goto out;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..e27b289 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	int error, retries = 0;
 
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb),
+				    (JBD2_FAIL_OK | JBD2_TOPLEVEL));
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
-- 
1.7.4.1

