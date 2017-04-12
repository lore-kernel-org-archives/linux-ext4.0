From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/11] jfs: Set flags on quota files directly
Date: Wed, 12 Apr 2017 09:26:04 +0200
Message-ID: <20170412072611.29017-5-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently immutable and noatime flags on quota files are set by quota
code which requires us to copy inode->i_flags to our on disk version
of quota flags in GETFLAGS ioctl and copy_to_dinode(). Move to
setting / clearing these on-disk flags directly to save that copying.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jfs/super.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index c64c2574a0aa..e8aad7d87b8c 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -45,6 +45,7 @@
 #include "jfs_acl.h"
 #include "jfs_debug.h"
 #include "jfs_xattr.h"
+#include "jfs_dinode.h"
 
 MODULE_DESCRIPTION("The Journaled Filesystem (JFS)");
 MODULE_AUTHOR("Steve Best/Dave Kleikamp/Barry Arndt, IBM");
@@ -181,6 +182,35 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+#ifdef CONFIG_QUOTA
+static int jfs_quota_off(struct super_block *sb, int type);
+static int jfs_quota_on(struct super_block *sb, int type, int format_id,
+			const struct path *path);
+
+static void jfs_quota_off_umount(struct super_block *sb)
+{
+	int type;
+
+	for (type = 0; type < MAXQUOTAS; type++)
+		jfs_quota_off(sb, type);
+}
+
+static const struct quotactl_ops jfs_quotactl_ops = {
+	.quota_on	= jfs_quota_on,
+	.quota_off	= jfs_quota_off,
+	.quota_sync	= dquot_quota_sync,
+	.get_state	= dquot_get_state,
+	.set_info	= dquot_set_dqinfo,
+	.get_dqblk	= dquot_get_dqblk,
+	.set_dqblk	= dquot_set_dqblk,
+	.get_nextdqblk	= dquot_get_next_dqblk,
+};
+#else
+static inline void jfs_quota_off_umount(struct super_block *sb)
+{
+}
+#endif
+
 static void jfs_put_super(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
@@ -188,7 +218,7 @@ static void jfs_put_super(struct super_block *sb)
 
 	jfs_info("In jfs_put_super");
 
-	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	jfs_quota_off_umount(sb);
 
 	rc = jfs_umount(sb);
 	if (rc)
@@ -536,7 +566,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = jfs_xattr_handlers;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
-	sb->s_qcop = &dquot_quotactl_ops;
+	sb->s_qcop = &jfs_quotactl_ops;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
@@ -840,6 +870,51 @@ static struct dquot **jfs_get_dquots(struct inode *inode)
 {
 	return JFS_IP(inode)->i_dquot;
 }
+
+static int jfs_quota_on(struct super_block *sb, int type, int format_id,
+			const struct path *path)
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
+	JFS_IP(inode)->mode2 |= JFS_NOATIME_FL | JFS_IMMUTABLE_FL;
+	inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
+			S_NOATIME | S_IMMUTABLE);
+	inode_unlock(inode);
+	mark_inode_dirty(inode);
+
+	return 0;
+}
+
+static int jfs_quota_off(struct super_block *sb, int type)
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
+	JFS_IP(inode)->mode2 &= ~(JFS_NOATIME_FL | JFS_IMMUTABLE_FL);
+	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
+	inode_unlock(inode);
+	mark_inode_dirty(inode);
+out_put:
+	iput(inode);
+	return err;
+out:
+	return dquot_quota_off(sb, type);
+}
 #endif
 
 static const struct super_operations jfs_super_operations = {
-- 
2.12.0

