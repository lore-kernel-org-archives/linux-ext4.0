From: akpm@linux-foundation.org
Subject: [patch 27/41] ext3: new export ops
Date: Sun, 21 Oct 2007 16:42:07 -0700
Message-ID: <200710212342.l9LNg75j000416@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hch@lst.de, bfields@fieldses.org,
	linux-ext4@vger.kernel.org, neilb@suse.de
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbXJUXsA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Oct 2007 19:48:00 -0400
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

 fs/ext3/super.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN fs/ext3/super.c~ext3-new-export-ops fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-new-export-ops
+++ a/fs/ext3/super.c
@@ -631,13 +631,10 @@ static int ext3_show_options(struct seq_
 }
 
 
-static struct dentry *ext3_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *ext3_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino < EXT3_FIRST_INO(sb) && ino != EXT3_ROOT_INO)
 		return ERR_PTR(-ESTALE);
@@ -660,15 +657,22 @@ static struct dentry *ext3_get_dentry(st
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
+static struct dentry *ext3_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ext3_nfs_get_inode);
+}
+
+static struct dentry *ext3_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ext3_nfs_get_inode);
 }
 
 #ifdef CONFIG_QUOTA
@@ -738,8 +742,9 @@ static const struct super_operations ext
 };
 
 static struct export_operations ext3_export_ops = {
+	.fh_to_dentry = ext3_fh_to_dentry,
+	.fh_to_parent = ext3_fh_to_parent,
 	.get_parent = ext3_get_parent,
-	.get_dentry = ext3_get_dentry,
 };
 
 enum {
_
