From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/6] ubifs: Wire up NFS support
Date: Sun, 21 May 2017 22:20:51 +0200
Message-ID: <1495398051-4604-7-git-send-email-richard@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:46002 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757089AbdEUUVW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 May 2017 16:21:22 -0400
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we have 64bit readdir cookies and export operations
we can finally enable NFS export support for UBIFS.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/ubifs/dir.c   | 10 ++--------
 fs/ubifs/super.c |  3 +++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a6eadb52a1a8..13b0db37be41 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -298,12 +298,8 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 done:
 	kfree(dent);
 	fscrypt_free_filename(&nm);
-	/*
-	 * Note, d_splice_alias() would be required instead if we supported
-	 * NFS.
-	 */
-	d_add(dentry, inode);
-	return NULL;
+
+	return d_splice_alias(inode, dentry);
 
 out_inode:
 	iput(inode);
@@ -525,8 +521,6 @@ static unsigned int vfs_dent_type(uint8_t type)
  * properly by means of saving full directory entry name in the private field
  * of the file description object.
  *
- * This means that UBIFS cannot support NFS which requires full
- * 'seekdir()'/'telldir()' support.
  */
 static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 {
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 4788420162b8..00ddde36e546 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2091,6 +2091,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_unlock;
 	}
 
+	if (c->parent_pointer && c->double_hash)
+		sb->s_export_op = &ubifs_export_ops;
+
 	/* Read the root inode */
 	root = ubifs_iget(sb, UBIFS_ROOT_INO);
 	if (IS_ERR(root)) {
-- 
2.12.0
