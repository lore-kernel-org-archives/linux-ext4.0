Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:52576 "EHLO
        dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728697AbeLSRcL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 12:32:11 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: force inode writes when nfsd calls commit_metadata()
Date: Wed, 19 Dec 2018 12:32:04 -0500
Message-Id: <20181219173204.716-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some time back, nfsd switched from calling vfs_fsync() to using a new
commit_metadata() hook in export_operations().  If the file system did
not provide a commit_metadata() hook, it fell back to using
sync_inode_metadata().  Unfortunately doesn't work on all file
systems.  In particular, it doesn't work on ext4 due to how the inode
gets journalled --- the VFS writeback code never ends up calling
ext4_write_inode().

So we need to provide our own ext4_nfs_commit_metdata() method which
calls ext4_write_inode() directly.

Google-Bug-Id: 121195940

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c             | 12 ++++++++++++
 include/trace/events/ext4.h | 20 ++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fc9071081600..378977cf8c19 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1202,6 +1202,17 @@ static struct dentry *ext4_fh_to_parent(struct super_block *sb, struct fid *fid,
 				    ext4_nfs_get_inode);
 }
 
+static int ext4_nfs_commit_metadata(struct inode *inode)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL
+	};
+
+	trace_ext4_nfs_commit_metadata(inode);
+	ext4_write_inode(inode, &wbc);
+	return 0;
+}
+
 /*
  * Try to release metadata pages (indirect blocks, directories) which are
  * mapped via the block device.  Since these pages could have journal heads
@@ -1406,6 +1417,7 @@ static const struct export_operations ext4_export_ops = {
 	.fh_to_dentry = ext4_fh_to_dentry,
 	.fh_to_parent = ext4_fh_to_parent,
 	.get_parent = ext4_get_parent,
+	.commit_metadata = ext4_nfs_commit_metadata,
 };
 
 enum {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 698e0d8a5ca4..d68e9e536814 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -226,6 +226,26 @@ TRACE_EVENT(ext4_drop_inode,
 		  (unsigned long) __entry->ino, __entry->drop)
 );
 
+TRACE_EVENT(ext4_nfs_commit_metadata,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
 TRACE_EVENT(ext4_mark_inode_dirty,
 	TP_PROTO(struct inode *inode, unsigned long IP),
 
-- 
2.19.1
