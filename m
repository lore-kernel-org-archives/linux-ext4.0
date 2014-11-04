From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] ext4: Convert to private i_dquot field
Date: Tue,  4 Nov 2014 12:19:49 +0100
Message-ID: <1415099993-18034-9-git-send-email-jack@suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, hch@lst.de, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaKDL62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:28 -0500
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 4 ++++
 fs/ext4/super.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c55a1faaed58..db3f772e57ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -941,6 +941,10 @@ struct ext4_inode_info {
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1eda6ab0ef9d..07ca5711cbce 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -892,6 +892,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
@@ -1068,6 +1069,11 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags);
 static int ext4_enable_quotas(struct super_block *sb);
 
+static struct dquot **ext4_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static const struct dquot_operations ext4_quota_operations = {
 	.get_reserved_space = ext4_get_reserved_space,
 	.write_dquot	= ext4_write_dquot,
@@ -1117,6 +1123,7 @@ static const struct super_operations ext4_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext4_quota_read,
 	.quota_write	= ext4_quota_write,
+	.get_dquots	= ext4_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
@@ -3928,6 +3935,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
-- 
1.8.1.4

