From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: fix reading new encrypted symlinks on no-journal filesystems
Date: Wed, 16 Nov 2016 09:50:27 -0800
Message-ID: <1479318627-143193-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:35342 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbcKPRw5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2016 12:52:57 -0500
Received: by mail-pg0-f52.google.com with SMTP id p66so81380319pga.2
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2016 09:52:57 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a filesystem with no journal, a symlink longer than about 32
characters (exact length depending on padding for encryption) could not
be followed or read immediately after being created in an encrypted
directory.  This happened because when the symlink data went through the
delayed allocation path instead of the journaling path, the symlink was
incorrectly detected as a "fast" symlink rather than a "slow" symlink
until its data was written out.

To fix this, use different inode operations for fast and slow encrypted
symlinks.  This parallels how fast and slow unencrypted symlinks use
different inode operations.

I did not fix this by updating ext4_inode_is_fast_symlink() to account
for delayed allocation because there didn't seem to be a good way to do
that in a race-free way.  i_data_sem would need to be acquired to avoid
racing with ext4_da_update_reserve_space() updating
i_reserved_data_blocks and i_blocks, but i_data_sem did not seem
appropriate to take from the context of ext4_inode_is_fast_symlink().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/inode.c   | 28 +++++++++++++++++++---------
 fs/ext4/namei.c   | 10 +++++++---
 fs/ext4/symlink.c | 28 +++++++++++++++++++++++++---
 4 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 53d6d46..a0096af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3087,6 +3087,7 @@ extern int ext4_mpage_readpages(struct address_space *mapping,
 
 /* symlink.c */
 extern const struct inode_operations ext4_encrypted_symlink_inode_operations;
+extern const struct inode_operations ext4_encrypted_fast_symlink_inode_operations;
 extern const struct inode_operations ext4_symlink_inode_operations;
 extern const struct inode_operations ext4_fast_symlink_inode_operations;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b1b4c85..be9e369 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -144,6 +144,9 @@ static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 
 /*
  * Test whether an inode is a fast symlink.
+ *
+ * Careful: the result may be incorrect if the symlink was just created and is
+ * pending delayed allocation (only possible on no-journal filesystems).
  */
 int ext4_inode_is_fast_symlink(struct inode *inode)
 {
@@ -4646,16 +4649,23 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext4_dir_inode_operations;
 		inode->i_fop = &ext4_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext4_encrypted_inode(inode)) {
-			inode->i_op = &ext4_encrypted_symlink_inode_operations;
-			ext4_set_aops(inode);
-		} else if (ext4_inode_is_fast_symlink(inode)) {
-			inode->i_link = (char *)ei->i_data;
-			inode->i_op = &ext4_fast_symlink_inode_operations;
-			nd_terminate_link(ei->i_data, inode->i_size,
-				sizeof(ei->i_data) - 1);
+		if (ext4_inode_is_fast_symlink(inode)) {
+			if (ext4_encrypted_inode(inode)) {
+				inode->i_op =
+				  &ext4_encrypted_fast_symlink_inode_operations;
+			} else {
+				inode->i_op =
+					&ext4_fast_symlink_inode_operations;
+				inode->i_link = (char *)ei->i_data;
+				nd_terminate_link(ei->i_data, inode->i_size,
+						  sizeof(ei->i_data) - 1);
+			}
 		} else {
-			inode->i_op = &ext4_symlink_inode_operations;
+			if (ext4_encrypted_inode(inode))
+				inode->i_op =
+				       &ext4_encrypted_symlink_inode_operations;
+			else
+				inode->i_op = &ext4_symlink_inode_operations;
 			ext4_set_aops(inode);
 		}
 		inode_nohighmem(inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..acf1786 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3148,11 +3148,12 @@ static int ext4_symlink(struct inode *dir,
 			goto err_drop_inode;
 		sd->len = cpu_to_le16(ostr.len);
 		disk_link.name = (char *) sd;
-		inode->i_op = &ext4_encrypted_symlink_inode_operations;
 	}
 
 	if ((disk_link.len > EXT4_N_BLOCKS * 4)) {
-		if (!encryption_required)
+		if (encryption_required)
+			inode->i_op = &ext4_encrypted_symlink_inode_operations;
+		else
 			inode->i_op = &ext4_symlink_inode_operations;
 		inode_nohighmem(inode);
 		ext4_set_aops(inode);
@@ -3194,7 +3195,10 @@ static int ext4_symlink(struct inode *dir,
 	} else {
 		/* clear the extent format for fast symlink */
 		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
-		if (!encryption_required) {
+		if (encryption_required) {
+			inode->i_op =
+				&ext4_encrypted_fast_symlink_inode_operations;
+		} else {
 			inode->i_op = &ext4_fast_symlink_inode_operations;
 			inode->i_link = (char *)&EXT4_I(inode)->i_data;
 		}
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 557b3b0..684bb78 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -24,7 +24,8 @@
 
 static const char *ext4_encrypted_get_link(struct dentry *dentry,
 					   struct inode *inode,
-					   struct delayed_call *done)
+					   struct delayed_call *done,
+					   bool fast)
 {
 	struct page *cpage = NULL;
 	char *caddr, *paddr = NULL;
@@ -40,7 +41,7 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	if (res)
 		return ERR_PTR(res);
 
-	if (ext4_inode_is_fast_symlink(inode)) {
+	if (fast) {
 		caddr = (char *) EXT4_I(inode)->i_data;
 		max_size = sizeof(EXT4_I(inode)->i_data);
 	} else {
@@ -82,9 +83,30 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return ERR_PTR(res);
 }
 
+static const char *ext4_encrypted_get_link_slow(struct dentry *dentry,
+						struct inode *inode,
+						struct delayed_call *done)
+{
+	return ext4_encrypted_get_link(dentry, inode, done, false);
+}
+
+static const char *ext4_encrypted_get_link_fast(struct dentry *dentry,
+						struct inode *inode,
+						struct delayed_call *done)
+{
+	return ext4_encrypted_get_link(dentry, inode, done, true);
+}
+
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.readlink	= generic_readlink,
-	.get_link	= ext4_encrypted_get_link,
+	.get_link	= ext4_encrypted_get_link_slow,
+	.setattr	= ext4_setattr,
+	.listxattr	= ext4_listxattr,
+};
+
+const struct inode_operations ext4_encrypted_fast_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.get_link	= ext4_encrypted_get_link_fast,
 	.setattr	= ext4_setattr,
 	.listxattr	= ext4_listxattr,
 };
-- 
2.8.0.rc3.226.g39d4020

