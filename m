From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/6] ubifs: Wire up NFS support
Date: Thu,  1 Dec 2016 23:02:21 +0100
Message-ID: <1480629741-18375-7-git-send-email-richard@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:46002 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760774AbcLAWCk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2016 17:02:40 -0500
In-Reply-To: <1480629741-18375-1-git-send-email-richard@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we have 64bit readdir cookies and export operations
we can finally enable NFS export support for UBIFS.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c   | 9 ++-------
 fs/ubifs/super.c | 3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 5485d836af21..13d13afd2976 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -289,11 +289,8 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 done:
 	kfree(dent);
 	fscrypt_free_filename(&nm);
-	/*
-	 * Note, d_splice_alias() would be required instead if we supported
-	 * NFS.
-	 */
-	d_add(dentry, inode);
+
+	d_splice_alias(inode, dentry);
 	return NULL;
 
 out_dent:
@@ -524,8 +521,6 @@ static unsigned int vfs_dent_type(uint8_t type)
  * properly by means of saving full directory entry name in the private field
  * of the file description object.
  *
- * This means that UBIFS cannot support NFS which requires full
- * 'seekdir()'/'telldir()' support.
  */
 static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 {
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index be5b697d8214..4cb7f641f35c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2092,6 +2092,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_unlock;
 	}
 
+	if (c->parent_pointer && c->double_hash)
+		sb->s_export_op = &ubifs_export_ops;
+
 	/* Read the root inode */
 	root = ubifs_iget(sb, UBIFS_ROOT_INO);
 	if (IS_ERR(root)) {
-- 
2.7.3

