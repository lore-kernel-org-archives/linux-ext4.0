From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] ext4: Convert to private i_dquot field
Date: Fri, 10 Oct 2014 16:55:06 +0200
Message-ID: <1412952910-7142-9-git-send-email-jack@suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1412952910-7142-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225cdb52c..571a9f409e94 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -940,6 +940,10 @@ struct ext4_inode_info {
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
index 0b28b36e7915..ceac3c1b1552 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -895,6 +895,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
@@ -1143,6 +1144,13 @@ static const struct super_operations ext4_nojournal_sops = {
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
+static const int ext4_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = offsetof(struct ext4_inode_info, i_dquot) -
+		      offsetof(struct ext4_inode_info, vfs_inode),
+#endif
+};
+
 static const struct export_operations ext4_export_ops = {
 	.fh_to_dentry = ext4_fh_to_dentry,
 	.fh_to_parent = ext4_fh_to_parent,
@@ -3916,7 +3924,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
+	sb_init_inode_fields(sb, ext4_inode_fields);
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-- 
1.8.1.4

