From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 3/3] ext4: Update ext4 code to call journal start routine
 which can fail with ENOMEM
Date: Wed, 25 May 2011 01:06:16 -0700
Message-ID: <4DDCB878.4060309@gmail.com>
References: <4DDCB2DD.8080506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55071 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1EYIGT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 04:06:19 -0400
Received: by pzk9 with SMTP id 9so3306478pzk.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 01:06:18 -0700 (PDT)
In-Reply-To: <4DDCB2DD.8080506@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2011 12:42 AM, Manish Katiyar wrote:
> Hi Jan,
>
> Posting this as a new mail for Ted's convenience. I have incorporated your
> feedback from the last patch
> (http://comments.gmane.org/gmane.comp.file-systems.ext4/24547) and updated
> the patch.
>
Please ignore the earlier patch. Here is the correct one.

a) Add a new API ext4_journal_start_failok for callers who are
  ok to handle ENOMEM cases.
b) Update ext4 routines with the new API which can fail.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c         |    5 +++--
 fs/ext4/ext4_jbd2.h   |   10 +++++++++-
 fs/ext4/extents.c     |    2 +-
 fs/ext4/inode.c       |   16 +++++++++-------
 fs/ext4/ioctl.c       |    4 ++--
 fs/ext4/migrate.c     |    2 +-
 fs/ext4/move_extent.c |    2 +-
 fs/ext4/namei.c       |   23 +++++++++++++++--------
 fs/ext4/super.c       |   17 ++++++++++++++---
 fs/ext4/xattr.c       |    3 ++-
 10 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 93dc9a6..371dbc9 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -350,7 +350,7 @@ ext4_acl_chmod(struct inode *inode)
 		int retries = 0;

 	retry:
-		handle = ext4_journal_start(inode,
+		handle = ext4_journal_start_failok(inode,
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
@@ -450,7 +450,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 		acl = NULL;

 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start_failok(inode,
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 		goto release_and_out;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 0abee1b..eae4c0a 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -161,6 +161,7 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))

+handle_t *ext4_journal_start_sb_failok(struct super_block *sb, int nblocks);
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);

@@ -202,7 +203,14 @@ static inline int ext4_handle_has_enough_credits(handle_t *handle, int needed)
 	return 1;
 }

-static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
+static inline handle_t *ext4_journal_start_failok(struct inode *inode,
+						  int nblocks)
+{
+	return ext4_journal_start_sb_failok(inode->i_sb, nblocks);
+}
+
+static inline handle_t *ext4_journal_start(struct inode *inode,
+						  int nblocks)
 {
 	return ext4_journal_start_sb(inode->i_sb, nblocks);
 }
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4890d6f..5cb3cb2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3685,7 +3685,7 @@ retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
 		map.m_len = max_blocks = max_blocks - ret;
-		handle = ext4_journal_start(inode, credits);
+		handle = ext4_journal_start_failok(inode, credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..6a58b04 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1624,7 +1624,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	to = from + len;

 retry:
-	handle = ext4_journal_start(inode, needed_blocks);
+	handle = ext4_journal_start_failok(inode, needed_blocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3126,7 +3126,7 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start_failok(inode, 1);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -3480,7 +3480,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,

 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
-			handle = ext4_journal_start(inode, 2);
+			handle = ext4_journal_start_failok(inode, 2);
 			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
 				goto out;
@@ -5279,8 +5279,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)

 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle = ext4_journal_start_failok(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5315,7 +5316,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
 		handle_t *handle;

-		handle = ext4_journal_start(inode, 3);
+		handle = ext4_journal_start_failok(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
@@ -5371,7 +5372,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		rc = ext4_acl_chmod(inode);

 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error != -ENOMEM)
+		ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
 	return error;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 808c554..4fc2630 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
 			ext4_truncate(inode);

-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start_failok(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto flags_out;
@@ -157,7 +157,7 @@ flags_out:
 			goto setversion_out;
 		}

-		handle = ext4_journal_start(inode, 1);
+		handle = ext4_journal_start_failok(inode, 1);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto setversion_out;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 92816b4..4ca0a3a 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -484,7 +484,7 @@ int ext4_ext_migrate(struct inode *inode)
 		 */
 		return retval;

-	handle = ext4_journal_start(inode,
+	handle = ext4_journal_start_failok(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b9f3e78..3afd60d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,7 +813,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle = ext4_journal_start(orig_inode, jblocks);
+	handle = ext4_journal_start_failok(orig_inode, jblocks);
 	if (IS_ERR(handle)) {
 		*err = PTR_ERR(handle);
 		return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67fd0b0..0ad321b5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1738,7 +1738,8 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, int mode,
 	dquot_initialize(dir);

 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -1774,7 +1775,8 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
 	dquot_initialize(dir);

 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -1813,7 +1815,8 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dquot_initialize(dir);

 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -2128,7 +2131,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2190,7 +2194,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2248,7 +2253,8 @@ static int ext4_symlink(struct inode *dir,
 	dquot_initialize(dir);

 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -2308,7 +2314,8 @@ static int ext4_link(struct dentry *old_dentry,
 	dquot_initialize(dir);

 retry:
-	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
+	handle = ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -2359,7 +2366,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * in separate transaction */
 	if (new_dentry->d_inode)
 		dquot_initialize(new_dentry->d_inode);
-	handle = ext4_journal_start(old_dir, 2 *
+	handle = ext4_journal_start_failok(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
 	if (IS_ERR(handle))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e4c17f..ba0776c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
  * ext4 prevents a new handle from being started by s_frozen, which
  * is in an upper layer.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+static handle_t *__ext4_journal_start_sb(struct super_block *sb,
+					 int nblocks, bool errok)
 {
 	journal_t *journal;
 	handle_t  *handle;
@@ -279,7 +280,17 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks, false);
+	return jbd2_journal_start(journal, nblocks, errok);
+}
+
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+{
+	return __ext4_journal_start_sb(sb, nblocks, false);
+}
+
+handle_t *ext4_journal_start_sb_failok(struct super_block *sb, int nblocks)
+{
+	return __ext4_journal_start_sb(sb, nblocks, true);
 }

 /*
@@ -4654,7 +4665,7 @@ static int ext4_quota_off(struct super_block *sb, int type)

 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start_failok(inode, 1);
 	if (IS_ERR(handle))
 		goto out;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b545ca1..a4be614 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	int error, retries = 0;

 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start_failok(inode,
+					EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
-- 
1.7.4.1

-- 
Thanks -
Manish
