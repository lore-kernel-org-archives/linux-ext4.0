From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] reiserfs: Set flags on quota files directly
Date: Wed, 12 Apr 2017 09:26:02 +0200
Message-ID: <20170412072611.29017-3-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753209AbdDLHen (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Apr 2017 03:34:43 -0400
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently immutable and noatime flags on quota files are set by quota
code which requires us to copy inode->i_flags to our on disk version of
quota flags in GETFLAGS ioctl and when writing stat item. Move to
setting / clearing these on-disk flags directly to save that copying.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index feabcde0290d..1fbb687fb83e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -547,12 +547,28 @@ static void reiserfs_kill_sb(struct super_block *s)
 	kill_block_super(s);
 }
 
+#ifdef CONFIG_QUOTA
+static int reiserfs_quota_off(struct super_block *sb, int type);
+
+static void reiserfs_quota_off_umount(struct super_block *s)
+{
+	int type;
+
+	for (type = 0; type < REISERFS_MAXQUOTAS; type++)
+		reiserfs_quota_off(s, type);
+}
+#else
+static inline void reiserfs_quota_off_umount(struct super_block *s)
+{
+}
+#endif
+
 static void reiserfs_put_super(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	th.t_trans_id = 0;
 
-	dquot_disable(s, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
+	reiserfs_quota_off_umount(s);
 
 	reiserfs_write_lock(s);
 
@@ -817,7 +833,7 @@ static const struct dquot_operations reiserfs_quota_operations = {
 
 static const struct quotactl_ops reiserfs_qctl_operations = {
 	.quota_on = reiserfs_quota_on,
-	.quota_off = dquot_quota_off,
+	.quota_off = reiserfs_quota_off,
 	.quota_sync = dquot_quota_sync,
 	.get_state = dquot_get_state,
 	.set_info = dquot_set_dqinfo,
@@ -2405,12 +2421,47 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 			goto out;
 	}
 	reiserfs_write_unlock(sb);
-	return dquot_quota_on(sb, type, format_id, path);
+	err = dquot_quota_on(sb, type, format_id, path);
+	if (!err) {
+		inode_lock(inode);
+		REISERFS_I(inode)->i_attrs |= REISERFS_IMMUTABLE_FL |
+					      REISERFS_NOATIME_FL;
+		inode_set_flags(inode, S_IMMUTABLE | S_NOATIME,
+				S_IMMUTABLE | S_NOATIME);
+		inode_unlock(inode);
+		mark_inode_dirty(inode);
+	}
+	return err;
 out:
 	reiserfs_write_unlock(sb);
 	return err;
 }
 
+static int reiserfs_quota_off(struct super_block *sb, int type)
+{
+	int err;
+	struct inode *inode = sb_dqopt(sb)->files[type];
+
+	if (!inode || !igrab(inode))
+		goto out;
+
+	err = dquot_quota_off(sb, type);
+	if (err)
+		goto out_put;
+
+	inode_lock(inode);
+	REISERFS_I(inode)->i_attrs &= ~(REISERFS_IMMUTABLE_FL |
+					REISERFS_NOATIME_FL);
+	inode_set_flags(inode, 0, S_IMMUTABLE | S_NOATIME);
+	inode_unlock(inode);
+	mark_inode_dirty(inode);
+out_put:
+	iput(inode);
+	return err;
+out:
+	return dquot_quota_off(sb, type);
+}
+
 /*
  * Read data from quotafile - avoid pagecache and such because we cannot afford
  * acquiring the locks... As quota files are never truncated and quota code
-- 
2.12.0
