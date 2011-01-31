From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 3/4] Update ext4 routines to use GFP_KERNEL for journal
 transaction allocation.
Date: Sun, 30 Jan 2011 17:25:49 -0800
Message-ID: <AANLkTi=OHxmPD=Yy9QJ6HHGF0-djBhnYVby_nfMVzS40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35903 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1AaB0L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 20:26:11 -0500
Received: by qyj19 with SMTP id 19so2856715qyj.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 17:26:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following patch updates ext4 routines to specify journal to pass
GFP_KERNEL while allocating
transaction.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/extents.c     |    2 +-
 fs/ext4/inode.c       |   20 ++++++++++++--------
 fs/ext4/ioctl.c       |    4 ++--
 fs/ext4/migrate.c     |    4 ++--
 fs/ext4/move_extent.c |    2 +-
 fs/ext4/namei.c       |   24 +++++++++++++++---------
 fs/ext4/resize.c      |    8 ++++----
 fs/ext4/xattr.c       |    3 ++-
 8 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4ebc6ac..5944b1c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3677,7 +3677,7 @@ retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
 		map.m_len = max_blocks = max_blocks - ret;
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start(inode, credits, true);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5f7b082..12a9b74 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1621,7 +1621,7 @@ static int ext4_write_begin(struct file *file,
struct address_space *mapping,
 	to = from + len;

 retry:
-	handle = ext4_journal_start(inode, needed_blocks);
+	handle = ext4_journal_start(inode, needed_blocks, true);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3205,7 +3205,7 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, true);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3554,7 +3554,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct
kiocb *iocb,

 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
-			handle = ext4_journal_start(inode, 2);
+			handle = ext4_journal_start(inode, 2, true);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
 				goto out;
@@ -3597,7 +3597,7 @@ retry:
 		int err;

 		/* Credits for sb + inode write */
-		handle = ext4_journal_start(inode, 2);
+		handle = ext4_journal_start(inode, 2, true);
 		if (IS_ERR(handle)) {
 			/* This is really bad luck. We've written the data
 			 * but cannot extend i_size. Bail out and pretend
@@ -5330,8 +5330,10 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)

 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle = ext4_journal_start(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
+					    true);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5366,7 +5368,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
 		handle_t *handle;

-		handle = ext4_journal_start(inode, 3);
+		handle = ext4_journal_start(inode, 3, true);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5422,7 +5424,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 		rc = ext4_acl_chmod(inode);

 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error != -ENOMEM) {
+		ext4_std_error(inode->i_sb, error);
+	}
 	if (!error)
 		error = rc;
 	return error;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index eb3bc2f..a357b9a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
cmd, unsigned long arg)
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
 			ext4_truncate(inode);

-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start(inode, 1, true);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto flags_out;
@@ -157,7 +157,7 @@ flags_out:
 			goto setversion_out;
 		}

-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start(inode, 1, true);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto setversion_out;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b0a126f..729dcbc 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -488,7 +488,7 @@ int ext4_ext_migrate(struct inode *inode)
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
-					+ 1);
+					+ 1, true);
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		return retval;
@@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
 	up_read((&EXT4_I(inode)->i_data_sem));

-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode, 1, true);
 	if (IS_ERR(handle)) {
 		/*
 		 * It is impossible to update on-disk structures without
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b9f3e78..d5aad4d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,7 +813,7 @@ move_extent_per_page(struct file *o_filp, struct
inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle = ext4_journal_start(orig_inode, jblocks);
+	handle = ext4_journal_start(orig_inode, jblocks, true);
 	if (IS_ERR(handle)) {
 		*err = PTR_ERR(handle);
 		return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5485390..a3ad11f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1739,7 +1739,8 @@ static int ext4_create(struct inode *dir, struct
dentry *dentry, int mode,
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -1775,7 +1776,8 @@ static int ext4_mknod(struct inode *dir, struct
dentry *dentry,
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -1814,7 +1816,8 @@ static int ext4_mkdir(struct inode *dir, struct
dentry *dentry, int mode)
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2127,7 +2130,8 @@ static int ext4_rmdir(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir,
+				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb), true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2188,7 +2192,8 @@ static int ext4_unlink(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start(dir,
+				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb), true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2246,8 +2251,9 @@ static int ext4_symlink(struct inode *dir,

 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+				    EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
+				    EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+				    true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2313,7 +2319,7 @@ static int ext4_link(struct dentry *old_dentry,

 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS, true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2365,7 +2371,7 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 		dquot_initialize(new_dentry->d_inode);
 	handle = ext4_journal_start(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2, true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3ecc6e4..e50d083 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -176,7 +176,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	int err = 0, err2;

 	/* This transaction may be extended/restarted along the way */
-	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, true);

 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -655,7 +655,7 @@ static void update_backups(struct super_block *sb,
 	handle_t *handle;
 	int err = 0, err2;

-	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, true);
 	if (IS_ERR(handle)) {
 		group = 1;
 		err = PTR_ERR(handle);
@@ -793,7 +793,7 @@ int ext4_group_add(struct super_block *sb, struct
ext4_new_group_data *input)
 	 */
 	handle = ext4_journal_start_sb(sb,
 				       ext4_bg_has_super(sb, input->group) ?
-				       3 + reserved_gdb : 4);
+				       3 + reserved_gdb : 4, true);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto exit_put;
@@ -1031,7 +1031,7 @@ int ext4_group_extend(struct super_block *sb,
struct ext4_super_block *es,
 	/* We will update the superblock, one block bitmap, and
 	 * one group descriptor via ext4_free_blocks().
 	 */
-	handle = ext4_journal_start_sb(sb, 3);
+	handle = ext4_journal_start_sb(sb, 3, true);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		ext4_warning(sb, "error %d on journal start", err);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index fc32176..0e39f57 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int
name_index, const char *name,
 	int error, retries = 0;

 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode,
+				    EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
-- 
1.6.0.4


-- 
Thanks -
Manish
