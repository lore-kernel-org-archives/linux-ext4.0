From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/12] ocfs2: Convert to private i_dquot field
Date: Tue,  4 Nov 2014 12:19:50 +0100
Message-ID: <1415099993-18034-10-git-send-email-jack@suse.cz>
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
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.h | 2 ++
 fs/ocfs2/super.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a9b76de46047..ca3431ee7f24 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -80,6 +80,8 @@ struct ocfs2_inode_info
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+
+	struct dquot *i_dquot[MAXQUOTAS];
 };
 
 /*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 93c85bc745e1..0945814ddb7b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -143,6 +143,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
+static struct dquot **ocfs2_get_dquots(struct inode *inode)
+{
+	return OCFS2_I(inode)->i_dquot;
+}
+
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
@@ -155,6 +160,7 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+	.get_dquots	= ocfs2_get_dquots,
 };
 
 enum {
@@ -563,6 +569,7 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 
 	oi->i_sync_tid = 0;
 	oi->i_datasync_tid = 0;
+	memset(&oi->i_dquot, 0, sizeof(oi->i_dquot));
 
 	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
 	return &oi->vfs_inode;
@@ -2073,6 +2080,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_export_op = &ocfs2_export_ops;
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
-- 
1.8.1.4

