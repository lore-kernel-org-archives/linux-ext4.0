From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/12] fs: Generic infrastructure for optional inode fields
Date: Fri, 10 Oct 2014 16:55:02 +0200
Message-ID: <1412952910-7142-5-git-send-email-jack@suse.cz>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbaJJOzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2014 10:55:19 -0400
In-Reply-To: <1412952910-7142-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are parts of struct inode which are used only by a few filesystems
(e.g. i_dquot pointers, i_mapping->private_list, ...). Thus all the
other filesystems are just wasting memory with these fields. On the
other hand it isn't simple to just move these fields to filesystem
specific part of inode because there is generic code which needs to peek
into the fields and it is cumbersome to provide helpers into which fs
has to stuff the field it is storing elsewhere.

We create a simple infrastructure which allows for optional inode fields
stored in the fs-specific part of the inode. Accessing these fields has
a slightly worse performance as we have to lookup their offset in the
offset table stored in the superblock but in most cases this is
acceptable. Notably, this offset-table mechanism is faster than having
fs-specific hook functions which would need to be called to provide
pointers to desired fields.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 94187721ad41..f2468786a36b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -615,6 +615,11 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 };
 
+/* Optional inode fields (stored in filesystems inode if the fs needs them) */
+enum inode_fields {
+	IF_FIELD_NR	/* Number of optional inode fields */
+};
+
 static inline int inode_unhashed(struct inode *inode)
 {
 	return hlist_unhashed(&inode->i_hash);
@@ -1236,6 +1241,11 @@ struct super_block {
 	void 			*s_fs_info;	/* Filesystem private info */
 	unsigned int		s_max_links;
 	fmode_t			s_mode;
+	/*
+	 * We could have here just a pointer to the offsets array but this
+	 * way we save one dereference when looking up field offsets
+	 */
+	int			s_inode_fields[IF_FIELD_NR];
 
 	/* Granularity of c/m/atime in ns.
 	   Cannot be worse than a second */
@@ -1286,6 +1296,24 @@ struct super_block {
 	struct rcu_head		rcu;
 };
 
+static inline void *inode_field(const struct inode *inode,
+				enum inode_fields field)
+{
+	int offset;
+
+	BUG_ON(field >= IF_FIELD_NR);
+	offset = inode->i_sb->s_inode_fields[field];
+	if (!offset)	/* Field not present? */
+		return NULL;
+	return ((char *)inode) + offset;
+}
+
+static inline void sb_init_inode_fields(struct super_block *sb,
+					const int *fields)
+{
+	memcpy(sb->s_inode_fields, fields, sizeof(int) * IF_FIELD_NR);
+}
+
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
-- 
1.8.1.4

