From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/11] ext4: Set flags on quota files directly
Date: Wed, 12 Apr 2017 09:26:01 +0200
Message-ID: <20170412072611.29017-2-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently immutable and noatime flags on quota files are set by quota
code which requires us to copy inode->i_flags to our on disk version of
quota flags in GETFLAGS ioctl and ext4_do_update_inode(). Move to
setting / clearing these on-disk flags directly to save that copying.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9448db1cf7e..480cbbebdc57 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -839,6 +839,28 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 	}
 }
 
+#ifdef CONFIG_QUOTA
+static int ext4_quota_off(struct super_block *sb, int type);
+
+static inline void ext4_quota_off_umount(struct super_block *sb)
+{
+	int type;
+
+	if (ext4_has_feature_quota(sb)) {
+		dquot_disable(sb, -1,
+			      DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	} else {
+		/* Use our quota_off function to clear inode flags etc. */
+		for (type = 0; type < EXT4_MAXQUOTAS; type++)
+			ext4_quota_off(sb, type);
+	}
+}
+#else
+static inline void ext4_quota_off_umount(struct super_block *sb)
+{
+}
+#endif
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -847,7 +869,7 @@ static void ext4_put_super(struct super_block *sb)
 	int i, err;
 
 	ext4_unregister_li_request(sb);
-	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	ext4_quota_off_umount(sb);
 
 	flush_workqueue(sbi->rsv_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
@@ -1218,7 +1240,6 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 			 const struct path *path);
-static int ext4_quota_off(struct super_block *sb, int type);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -5344,11 +5365,28 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		if (err)
 			return err;
 	}
+
 	lockdep_set_quota_inode(path->dentry->d_inode, I_DATA_SEM_QUOTA);
 	err = dquot_quota_on(sb, type, format_id, path);
-	if (err)
+	if (err) {
 		lockdep_set_quota_inode(path->dentry->d_inode,
 					     I_DATA_SEM_NORMAL);
+	} else {
+		struct inode *inode = d_inode(path->dentry);
+		handle_t *handle;
+
+		inode_lock(inode);
+		handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
+		if (IS_ERR(handle))
+			goto unlock_inode;
+		EXT4_I(inode)->i_flags |= EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL;
+		inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
+				S_NOATIME | S_IMMUTABLE);
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
+	unlock_inode:
+		inode_unlock(inode);
+	}
 	return err;
 }
 
@@ -5422,24 +5460,36 @@ static int ext4_quota_off(struct super_block *sb, int type)
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	handle_t *handle;
+	int err;
 
 	/* Force all delayed allocation blocks to be allocated.
 	 * Caller already holds s_umount sem */
 	if (test_opt(sb, DELALLOC))
 		sync_filesystem(sb);
 
-	if (!inode)
+	if (!inode || !igrab(inode))
 		goto out;
 
+	err = dquot_quota_off(sb, type);
+	if (err)
+		goto out_put;
+
+	inode_lock(inode);
 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
 	if (IS_ERR(handle))
-		goto out;
+		goto out_unlock;
+	EXT4_I(inode)->i_flags &= ~(EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL);
+	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
-
+out_unlock:
+	inode_unlock(inode);
+out_put:
+	iput(inode);
+	return err;
 out:
 	return dquot_quota_off(sb, type);
 }
-- 
2.12.0
