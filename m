From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/11] ext2: Set flags on quota files directly
Date: Wed, 12 Apr 2017 09:26:03 +0200
Message-ID: <20170412072611.29017-4-jack@suse.cz>
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
quota flags in GETFLAGS ioctl and __ext2_write_inode().  Move to setting
/ clearing these on-disk flags directly to save that copying.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 9e25a71fe1a2..ca9ad24441cb 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -123,13 +123,29 @@ void ext2_update_dynamic_rev(struct super_block *sb)
 	 */
 }
 
+#ifdef CONFIG_QUOTA
+static int ext2_quota_off(struct super_block *sb, int type);
+
+static void ext2_quota_off_umount(struct super_block *sb)
+{
+	int type;
+
+	for (type = 0; type < MAXQUOTAS; type++)
+		ext2_quota_off(sb, type);
+}
+#else
+static inline void ext2_quota_off_umount(struct super_block *sb)
+{
+}
+#endif
+
 static void ext2_put_super (struct super_block * sb)
 {
 	int db_count;
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	ext2_quota_off_umount(sb);
 
 	if (sbi->s_mb_cache) {
 		ext2_xattr_destroy_cache(sbi->s_mb_cache);
@@ -314,10 +330,23 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 #ifdef CONFIG_QUOTA
 static ssize_t ext2_quota_read(struct super_block *sb, int type, char *data, size_t len, loff_t off);
 static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *data, size_t len, loff_t off);
+static int ext2_quota_on(struct super_block *sb, int type, int format_id,
+			 const struct path *path);
 static struct dquot **ext2_get_dquots(struct inode *inode)
 {
 	return EXT2_I(inode)->i_dquot;
 }
+
+static const struct quotactl_ops ext2_quotactl_ops = {
+	.quota_on	= ext2_quota_on,
+	.quota_off	= ext2_quota_off,
+	.quota_sync	= dquot_quota_sync,
+	.get_state	= dquot_get_state,
+	.set_info	= dquot_set_dqinfo,
+	.get_dqblk	= dquot_get_dqblk,
+	.set_dqblk	= dquot_set_dqblk,
+	.get_nextdqblk	= dquot_get_next_dqblk,
+};
 #endif
 
 static const struct super_operations ext2_sops = {
@@ -1117,7 +1146,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
-	sb->s_qcop = &dquot_quotactl_ops;
+	sb->s_qcop = &ext2_quotactl_ops;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
@@ -1548,6 +1577,51 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 	return len - towrite;
 }
 
+static int ext2_quota_on(struct super_block *sb, int type, int format_id,
+			 const struct path *path)
+{
+	int err;
+	struct inode *inode;
+
+	err = dquot_quota_on(sb, type, format_id, path);
+	if (err)
+		return err;
+
+	inode = d_inode(path->dentry);
+	inode_lock(inode);
+	EXT2_I(inode)->i_flags |= EXT2_NOATIME_FL | EXT2_IMMUTABLE_FL;
+	inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
+			S_NOATIME | S_IMMUTABLE);
+	inode_unlock(inode);
+	mark_inode_dirty(inode);
+
+	return 0;
+}
+
+static int ext2_quota_off(struct super_block *sb, int type)
+{
+	struct inode *inode = sb_dqopt(sb)->files[type];
+	int err;
+
+	if (!inode || !igrab(inode))
+		goto out;
+
+	err = dquot_quota_off(sb, type);
+	if (err)
+		goto out_put;
+
+	inode_lock(inode);
+	EXT2_I(inode)->i_flags &= ~(EXT2_NOATIME_FL | EXT2_IMMUTABLE_FL);
+	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
+	inode_unlock(inode);
+	mark_inode_dirty(inode);
+out_put:
+	iput(inode);
+	return err;
+out:
+	return dquot_quota_off(sb, type);
+}
+
 #endif
 
 static struct file_system_type ext2_fs_type = {
-- 
2.12.0
