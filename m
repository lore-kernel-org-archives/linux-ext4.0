From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 28/28] ext4: Make fsync sync new parent directories in no-journal mode
Date: Tue,  1 Jun 2010 12:13:15 -0400
Message-ID: <1275408795-17487-28-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frank Mayhar <fmayhar@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56878 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab0FAQNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:22 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frank Mayhar <fmayhar@google.com>

commit 14ece1028b3ed53ffec1b1213ffc6acaf79ad77c upstream (as of v2.6.34-git13)

Add a new ext4 state to tell us when a file has been newly created; use
that state in ext4_sync_file in no-journal mode to tell us when we need
to sync the parent directory as well as the inode and data itself.  This
fixes a problem in which a panic or power failure may lose the entire
file even when using fsync, since the parent directory entry is lost.

Addresses-Google-Bug: #2480057

Signed-off-by: Frank Mayhar <fmayhar@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/fsync.c |   31 +++++++++++++++++++++++++++++--
 fs/ext4/namei.c |    2 ++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2e31640..650ef37 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1157,6 +1157,7 @@ enum {
 	EXT4_STATE_DA_ALLOC_CLOSE,	/* Alloc DA blks on close */
 	EXT4_STATE_EXT_MIGRATE,		/* Inode is migrating */
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
+	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field)					\
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 42bd94a..61da601 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -35,6 +35,29 @@
 #include <trace/events/ext4.h>
 
 /*
+ * If we're not journaling and this is a just-created file, we have to
+ * sync our parent directory (if it was freshly created) since
+ * otherwise it will only be written by writeback, leaving a huge
+ * window during which a crash may lose the file.  This may apply for
+ * the parent directory's parent as well, and so on recursively, if
+ * they are also freshly created.
+ */
+static void ext4_sync_parent(struct inode *inode)
+{
+	struct dentry *dentry = NULL;
+
+	while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
+		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
+		dentry = list_entry(inode->i_dentry.next,
+				    struct dentry, d_alias);
+		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
+			break;
+		inode = dentry->d_parent->d_inode;
+		sync_mapping_buffers(inode->i_mapping);
+	}
+}
+
+/*
  * akpm: A new design for ext4_sync_file().
  *
  * This is only called from sys_fsync(), sys_fdatasync() and sys_msync().
@@ -67,8 +90,12 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	if (ret < 0)
 		return ret;
 	
-	if (!journal)
-		return simple_fsync(file, dentry, datasync);
+	if (!journal) {
+		ret = simple_fsync(file, dentry, datasync);
+ 		if (!ret && !list_empty(&inode->i_dentry))
+ 			ext4_sync_parent(inode);
+		return ret;
+	}
 
 	/*
 	 * data=writeback,ordered:
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index efab592..2f31631 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1519,6 +1519,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	de->rec_len = ext4_rec_len_to_disk(blocksize, blocksize);
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
+	if (retval == 0)
+		ext4_set_inode_state(inode, EXT4_STATE_NEWENTRY);
 	return retval;
 }
 
-- 
1.6.6.1.1.g974db.dirty

