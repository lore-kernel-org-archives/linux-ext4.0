From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/12] ext2: Convert to private i_dquot field
Date: Tue,  4 Nov 2014 12:19:47 +0100
Message-ID: <1415099993-18034-7-git-send-email-jack@suse.cz>
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
Received: from cantor2.suse.de ([195.135.220.15]:44355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaKDL63 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:29 -0500
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  3 +++
 fs/ext2/super.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index d9a17d0b124d..e4279ead4a05 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -689,6 +689,9 @@ struct ext2_inode_info {
 	struct mutex truncate_mutex;
 	struct inode	vfs_inode;
 	struct list_head i_orphan;	/* unlinked but open inodes */
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
 };
 
 /*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 170dc41e8bf4..ae55fddc26a9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -166,6 +166,10 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+#ifdef CONFIG_QUOTA
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -303,6 +307,10 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 #ifdef CONFIG_QUOTA
 static ssize_t ext2_quota_read(struct super_block *sb, int type, char *data, size_t len, loff_t off);
 static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *data, size_t len, loff_t off);
+static struct dquot **ext2_get_dquots(struct inode *inode)
+{
+	return EXT2_I(inode)->i_dquot;
+}
 #endif
 
 static const struct super_operations ext2_sops = {
@@ -320,6 +328,7 @@ static const struct super_operations ext2_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext2_quota_read,
 	.quota_write	= ext2_quota_write,
+	.get_dquots	= ext2_get_dquots,
 #endif
 };
 
@@ -1090,6 +1099,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
 	root = ext2_iget(sb, EXT2_ROOT_INO);
-- 
1.8.1.4

