From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/12] ext3: Convert to private i_dquot field
Date: Tue, 21 Oct 2014 16:38:31 +0200
Message-ID: <1413902316-17997-8-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
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
Received: from cantor2.suse.de ([195.135.220.15]:51309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbaJUOiy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2014 10:38:54 -0400
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ext3.h  |  4 ++++
 fs/ext3/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index fc3cdcf24aed..f483a80b3fe7 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -615,6 +615,10 @@ struct ext3_inode_info {
 	atomic_t i_sync_tid;
 	atomic_t i_datasync_tid;
 
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7015db0bafd1..cfb338cc0263 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -485,6 +485,10 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	atomic_set(&ei->i_datasync_tid, 0);
 	atomic_set(&ei->i_sync_tid, 0);
+#ifdef CONFIG_QUOTA
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -764,6 +768,10 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
+static struct dquot **ext3_get_dquots(struct inode *inode)
+{
+	return EXT3_I(inode)->i_dquot;
+}
 
 static const struct dquot_operations ext3_quota_operations = {
 	.write_dquot	= ext3_write_dquot,
@@ -803,6 +811,7 @@ static const struct super_operations ext3_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext3_quota_read,
 	.quota_write	= ext3_quota_write,
+	.get_dquots	= ext3_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
@@ -2008,6 +2017,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->s_qcop = &ext3_qctl_operations;
 	sb->dq_op = &ext3_quota_operations;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-- 
1.8.1.4

