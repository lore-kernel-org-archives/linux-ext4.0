From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] ubifs: Implement export_operations
Date: Sun, 21 May 2017 22:20:50 +0200
Message-ID: <1495398051-4604-6-git-send-email-richard@nod.at>
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
Received: from mail.sigma-star.at ([95.130.255.111]:46001 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757074AbdEUUVV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 May 2017 16:21:21 -0400
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/super.c | 35 +++++++++++++++++++++++++++++++++++
 fs/ubifs/ubifs.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 7560071534bf..4788420162b8 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2005,6 +2005,41 @@ const struct fscrypt_operations ubifs_crypt_operations = {
 };
 #endif
 
+static struct dentry *ubifs_get_parent(struct dentry *child)
+{
+	struct ubifs_inode *ui = ubifs_inode(d_inode(child));
+
+	return d_obtain_alias(ubifs_iget(child->d_sb, ui->parent_inum));
+}
+
+static struct inode *ubifs_nfs_get_inode(struct super_block *sb, uint64_t ino,
+					 uint32_t generation)
+{
+	return ubifs_iget(sb, ino);
+}
+
+static struct dentry *ubifs_fh_to_dentry(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ubifs_nfs_get_inode);
+}
+
+static struct dentry *ubifs_fh_to_parent(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ubifs_nfs_get_inode);
+}
+
+static const struct export_operations ubifs_export_ops = {
+	.get_parent = ubifs_get_parent,
+	.fh_to_dentry = ubifs_fh_to_dentry,
+	.fh_to_parent = ubifs_fh_to_parent,
+};
+
 static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ubifs_info *c = sb->s_fs_info;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 3c64481f4032..a728d6e3eb47 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -45,6 +45,7 @@
 #endif
 #include <linux/random.h>
 #include <linux/compat.h>
+#include <linux/exportfs.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
-- 
2.12.0
