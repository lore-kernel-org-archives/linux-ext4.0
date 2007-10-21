From: akpm@linux-foundation.org
Subject: [patch 28/41] ext4: new export ops
Date: Sun, 21 Oct 2007 16:42:08 -0700
Message-ID: <200710212342.l9LNg8QL000420@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hch@lst.de, bfields@fieldses.org,
	linux-ext4@vger.kernel.org, neilb@suse.de
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbXJUXs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Oct 2007 19:48:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN fs/ext4/super.c~ext4-new-export-ops fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-new-export-ops
+++ a/fs/ext4/super.c
@@ -686,13 +686,10 @@ static int ext4_show_options(struct seq_
 }
 
 
-static struct dentry *ext4_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *ext4_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
 		return ERR_PTR(-ESTALE);
@@ -715,15 +712,22 @@ static struct dentry *ext4_get_dentry(st
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-	/* now to find a dentry.
-	 * If possible, get a well-connected one
-	 */
-	result = d_alloc_anon(inode);
-	if (!result) {
-		iput(inode);
-		return ERR_PTR(-ENOMEM);
-	}
-	return result;
+
+	return inode;
+}
+
+static struct dentry *ext4_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ext4_nfs_get_inode);
+}
+
+static struct dentry *ext4_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ext4_nfs_get_inode);
 }
 
 #ifdef CONFIG_QUOTA
@@ -793,8 +797,9 @@ static const struct super_operations ext
 };
 
 static struct export_operations ext4_export_ops = {
+	.fh_to_dentry = ext4_fh_to_dentry,
+	.fh_to_parent = ext4_fh_to_parent,
 	.get_parent = ext4_get_parent,
-	.get_dentry = ext4_get_dentry,
 };
 
 enum {
_
