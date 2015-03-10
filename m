From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 5/6] ext4: add shortcut for moving files across
 projects
Date: Tue, 10 Mar 2015 20:22:11 +0300
Message-ID: <20150310172210.23081.28245.stgit@buzz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds useful optimization for most common case of moving files
across projects: non-directory inode without extra hardlinks (i_nlink == 1)
can be moved into different project without making a copy. We just have to
change project in and reaccount disk usage in one transaction with rename.

As a result simple recursive 'mv' works much faster: it creates new
directories but files are moved without copying.

Flag DQUOT_TRANSFER_NOFAIL tells dquot_transfer_project() to move inode
regardless of quota limits. This is required for moving inode back into
the old project if rename had failed. This error-path little-bit racy
(user could use more that quota allows) but there are not so much errors
which might trigger this path: filesystem corruption or disk failure.
They seem bigger problem than potential quota abuse.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/ext4/namei.c          |   93 +++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c          |    2 -
 fs/quota/dquot.c         |   16 +++++---
 include/linux/quotaops.h |   10 ++++-
 4 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 094f7096a41c..2c738bae7c36 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3029,6 +3029,7 @@ struct ext4_renament {
 	struct inode *inode;
 	bool is_dir;
 	int dir_nlink_delta;
+	bool transfer_project;
 
 	/* entry for "dentry" */
 	struct buffer_head *bh;
@@ -3274,13 +3275,23 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_alloc_da_blocks(old.inode);
 
+	credits = (2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+
 	if (!ext4_check_project(new.dir, old.inode)) {
-		retval = -EXDEV;
-		goto end_rename;
+		/*
+		 * Shortcut for moving files across projects: inode with one
+		 * hardlink can be tranferred as is without making a copy.
+		 */
+		if (!S_ISDIR(old.inode->i_mode) && old.inode->i_nlink == 1) {
+			credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(old.dir->i_sb);
+			old.transfer_project = true;
+		} else {
+			retval = -EXDEV;
+			goto end_rename;
+		}
 	}
 
-	credits = (2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
 	if (!(flags & RENAME_WHITEOUT)) {
 		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
 		if (IS_ERR(handle)) {
@@ -3297,6 +3308,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	if (old.transfer_project) {
+		retval = dquot_transfer_project(old.inode,
+				EXT4_I(new.dir)->i_project, 0);
+		if (retval) {
+			old.transfer_project = false;
+			goto end_rename;
+		}
+	}
+
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
 
@@ -3355,6 +3375,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * rename.
 	 */
 	old.inode->i_ctime = ext4_current_time(old.inode);
+	if (old.transfer_project)
+		EXT4_I(old.inode)->i_project = EXT4_I(new.dir)->i_project;
 	ext4_mark_inode_dirty(handle, old.inode);
 
 	if (!whiteout) {
@@ -3395,6 +3417,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	if (retval && old.transfer_project)
+		dquot_transfer_project(old.inode, EXT4_I(old.inode)->i_project,
+				       DQUOT_TRANSFER_NOFAIL);
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
@@ -3425,6 +3450,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	};
 	u8 new_file_type;
 	int retval;
+	int credits;
 
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
@@ -3455,21 +3481,56 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino)
 		goto end_rename;
 
-	if (!ext4_check_project(new.dir, old.inode) ||
-	    !ext4_check_project(old.dir, new.inode)) {
-		retval = -EXDEV;
-		goto end_rename;
+	credits = 2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+		  2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2;
+
+	if (!ext4_check_project(new.dir, old.inode)) {
+		if (!S_ISDIR(old.inode->i_mode) && old.inode->i_nlink == 1) {
+			credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(old.dir->i_sb);
+			old.transfer_project = true;
+		} else {
+			retval = -EXDEV;
+			goto end_rename;
+		}
+	}
+
+	if (!ext4_check_project(old.dir, new.inode)) {
+		if (!S_ISDIR(new.inode->i_mode) && new.inode->i_nlink == 1) {
+			credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(old.dir->i_sb);
+			new.transfer_project = true;
+		} else {
+			old.transfer_project = false;
+			retval = -EXDEV;
+			goto end_rename;
+		}
 	}
 
-	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
-		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
+	handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		handle = NULL;
 		goto end_rename;
 	}
 
+	if (old.transfer_project) {
+		retval = dquot_transfer_project(old.inode,
+				EXT4_I(new.dir)->i_project, 0);
+		if (retval) {
+			old.transfer_project = false;
+			new.transfer_project = false;
+			goto end_rename;
+		}
+	}
+
+	if (new.transfer_project) {
+		retval = dquot_transfer_project(new.inode,
+				EXT4_I(old.dir)->i_project, 0);
+		if (retval) {
+			new.transfer_project = false;
+			goto end_rename;
+		}
+	}
+
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
 
@@ -3514,6 +3575,10 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	new.inode->i_ctime = ext4_current_time(new.inode);
+	if (old.transfer_project)
+		EXT4_I(old.inode)->i_project = EXT4_I(new.dir)->i_project;
+	if (new.transfer_project)
+		EXT4_I(new.inode)->i_project = EXT4_I(old.dir)->i_project;
 	ext4_mark_inode_dirty(handle, old.inode);
 	ext4_mark_inode_dirty(handle, new.inode);
 
@@ -3532,6 +3597,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	if (retval && old.transfer_project)
+		dquot_transfer_project(old.inode, EXT4_I(old.inode)->i_project,
+				       DQUOT_TRANSFER_NOFAIL);
+	if (retval && new.transfer_project)
+		dquot_transfer_project(new.inode, EXT4_I(new.inode)->i_project,
+				       DQUOT_TRANSFER_NOFAIL);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c62ed5b554ae..6a6506bce53c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1062,7 +1062,7 @@ static int ext4_set_project(struct inode *inode, kprojid_t project)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	ret = dquot_transfer_project(inode, project);
+	ret = dquot_transfer_project(inode, project, 0);
 	if (ret)
 		goto out;
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 04c27cdeca05..0b61357554ed 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1838,7 +1838,8 @@ EXPORT_SYMBOL(dquot_free_inode);
  * We are holding reference on transfer_from & transfer_to, no need to
  * protect them by srcu_read_lock().
  */
-int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
+static int do_dquot_transfer(struct inode *inode,
+		struct dquot **transfer_to, int flags)
 {
 	qsize_t space, cur_space;
 	qsize_t rsv_space = 0;
@@ -1879,10 +1880,10 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 		is_valid[cnt] = 1;
 		transfer_from[cnt] = i_dquot(inode)[cnt];
 		ret = check_idq(transfer_to[cnt], 1, &warn_to[cnt]);
-		if (ret)
+		if (ret && !(flags & DQUOT_TRANSFER_NOFAIL))
 			goto over_quota;
 		ret = check_bdq(transfer_to[cnt], space, 0, &warn_to[cnt]);
-		if (ret)
+		if (ret && !(flags & DQUOT_TRANSFER_NOFAIL))
 			goto over_quota;
 	}
 
@@ -1932,6 +1933,11 @@ over_quota:
 	flush_warnings(warn_to);
 	return ret;
 }
+
+int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
+{
+	return do_dquot_transfer(inode, transfer_to, 0);
+}
 EXPORT_SYMBOL(__dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode for uid/gid only
@@ -1960,7 +1966,7 @@ EXPORT_SYMBOL(dquot_transfer);
 /*
  * Helper function for transferring inode into another project.
  */
-int dquot_transfer_project(struct inode *inode, kprojid_t projid)
+int dquot_transfer_project(struct inode *inode, kprojid_t projid, int flags)
 {
 	struct dquot *transfer_to[MAXQUOTAS] = {};
 	struct super_block *sb = inode->i_sb;
@@ -1969,7 +1975,7 @@ int dquot_transfer_project(struct inode *inode, kprojid_t projid)
 	if (!sb_has_quota_active(sb, PRJQUOTA))
 		return 0;
 	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(projid));
-	ret = __dquot_transfer(inode, transfer_to);
+	ret = do_dquot_transfer(inode, transfer_to, flags);
 	dqput_all(transfer_to);
 	return ret;
 }
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index ba54745fe408..810b88c69c5b 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -9,10 +9,18 @@
 
 #include <linux/fs.h>
 
+/*
+ * Flags for functions __dquot_alloc_space() and __dquot_free_space()
+ */
 #define DQUOT_SPACE_WARN	0x1
 #define DQUOT_SPACE_RESERVE	0x2
 #define DQUOT_SPACE_NOFAIL	0x4
 
+/*
+ * Flags for functions dquot_transfer_*
+ */
+#define DQUOT_TRANSFER_NOFAIL	0x1
+
 static inline struct quota_info *sb_dqopt(struct super_block *sb)
 {
 	return &sb->s_dquot;
@@ -104,7 +112,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid id,
 
 int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
 int dquot_transfer(struct inode *inode, struct iattr *iattr);
-int dquot_transfer_project(struct inode *inode, kprojid_t projid);
+int dquot_transfer_project(struct inode *inode, kprojid_t projid, int flags);
 
 static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 {
