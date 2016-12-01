From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] ubifs: Implement export_operations
Date: Thu,  1 Dec 2016 23:02:20 +0100
Message-ID: <1480629741-18375-6-git-send-email-richard@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480629741-18375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/super.c | 31 +++++++++++++++++++++++++++++++
 fs/ubifs/ubifs.h |  1 +
 2 files changed, 32 insertions(+)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index c50952f43e36..be5b697d8214 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2006,6 +2006,37 @@ struct fscrypt_operations ubifs_crypt_operations = {
 };
 #endif
 
+static struct dentry *ubifs_get_parent(struct dentry *child)
+{
+	struct ubifs_inode *ui = ubifs_inode(d_inode(child));
+
+        return d_obtain_alias(ubifs_iget(child->d_sb, ui->parent_inum));
+}
+
+static struct inode *ubifs_nfs_get_inode(struct super_block *sb, uint64_t ino,
+					 uint32_t generation)
+{
+	return ubifs_iget(sb, ino);
+}
+
+static struct dentry *ubifs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+					 int fh_len, int fh_type)
+{
+        return generic_fh_to_dentry(sb, fid, fh_len, fh_type, ubifs_nfs_get_inode);
+}
+
+static struct dentry *ubifs_fh_to_parent(struct super_block *sb, struct fid *fid,
+					 int fh_len, int fh_type)
+{
+        return generic_fh_to_parent(sb, fid, fh_len, fh_type, ubifs_nfs_get_inode);
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
index e1b7531650af..8b0ac0a8afea 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -41,6 +41,7 @@
 #include <linux/fscrypto.h>
 #include <linux/random.h>
 #include <linux/compat.h>
+#include <linux/exportfs.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
-- 
2.7.3
