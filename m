From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Sun, 21 May 2017 22:20:48 +0200
Message-ID: <1495398051-4604-4-git-send-email-richard@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is the first step to support proper telldir/seekdir()
in UBIFS.
Let's report 64bit cookies in readdir(). The cookie is a combination
of the entry key plus the double hash value.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/ubifs/dir.c   | 46 +++++++++++++++++++++++++++++++-----------
 fs/ubifs/key.h   | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/ubifs.h |  1 +
 3 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index cada60690c22..e79b529df9c3 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -540,7 +540,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 
 	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, ctx->pos);
 
-	if (ctx->pos > UBIFS_S_KEY_HASH_MASK || ctx->pos == 2)
+	if (ctx->pos == 2)
 		/*
 		 * The directory was seek'ed to a senseless position or there
 		 * are no more entries.
@@ -595,7 +595,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 
-		ctx->pos = key_hash_flash(c, &dent->key);
+		ctx->pos = key_get_dir_pos(c, file, dent);
 		file->private_data = dent;
 	}
 
@@ -605,21 +605,43 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 		 * The directory was seek'ed to and is now readdir'ed.
 		 * Find the entry corresponding to @ctx->pos or the closest one.
 		 */
-		dent_key_init_hash(c, &key, dir->i_ino, ctx->pos);
-		fname_len(&nm) = 0;
-		dent = ubifs_tnc_next_ent(c, &key, &nm);
-		if (IS_ERR(dent)) {
-			err = PTR_ERR(dent);
-			goto out;
+		dent_key_init_hash(c, &key, dir->i_ino,
+				   key_get_hash_from_dir_pos(c, file, ctx->pos));
+
+		if (key_want_short_hash(file)) {
+			err = -ENOENT;
+		} else {
+			dent = kmalloc(UBIFS_MAX_DENT_NODE_SZ, GFP_NOFS);
+			if (!dent) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			err = ubifs_tnc_lookup_dh(c, &key, dent,
+				key_get_cookie_from_dir_pos(c, ctx->pos));
+		}
+
+		if (err) {
+			kfree(dent);
+			if (err < 0 && err != -ENOENT && err != -EOPNOTSUPP)
+				goto out;
+
+			fname_len(&nm) = 0;
+			dent = ubifs_tnc_next_ent(c, &key, &nm);
+			if (IS_ERR(dent)) {
+				err = PTR_ERR(dent);
+				goto out;
+			}
 		}
-		ctx->pos = key_hash_flash(c, &dent->key);
+
+		ctx->pos = key_get_dir_pos(c, file, dent);
 		file->private_data = dent;
 	}
 
 	while (1) {
-		dbg_gen("ino %llu, new f_pos %#x",
+		dbg_gen("ino %llu, new f_pos %#lx",
 			(unsigned long long)le64_to_cpu(dent->inum),
-			key_hash_flash(c, &dent->key));
+			(unsigned long)key_get_dir_pos(c, file, dent));
 		ubifs_assert(le64_to_cpu(dent->ch.sqnum) >
 			     ubifs_inode(dir)->creat_sqnum);
 
@@ -657,7 +679,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		kfree(file->private_data);
-		ctx->pos = key_hash_flash(c, &dent->key);
+		ctx->pos = key_get_dir_pos(c, file, dent);
 		file->private_data = dent;
 		cond_resched();
 	}
diff --git a/fs/ubifs/key.h b/fs/ubifs/key.h
index 7547be512db2..763188649133 100644
--- a/fs/ubifs/key.h
+++ b/fs/ubifs/key.h
@@ -397,6 +397,67 @@ static inline uint32_t key_hash_flash(const struct ubifs_info *c, const void *k)
 }
 
 /**
+ * key_want_short_hash - tests whether we can emit a 64bit hash or not.
+ * @file: the file handle of the directory
+ */
+static inline bool key_want_short_hash(struct file *file)
+{
+	if (file->f_mode & FMODE_32BITHASH)
+		return true;
+
+	if (!(file->f_mode & FMODE_64BITHASH) && is_32bit_api())
+		return true;
+
+	return false;
+}
+
+/**
+ * key_dir_pos - compute a 64bit directory cookie for readdir()
+ * @c: UBIFS file-system description object
+ * @file: the file handle of the directory
+ * @dent: the directory entry
+ */
+static inline loff_t key_get_dir_pos(const struct ubifs_info *c,
+				     struct file *file,
+				     struct ubifs_dent_node *dent)
+{
+	BUILD_BUG_ON(sizeof(loff_t) < 8);
+
+	if (key_want_short_hash(file))
+		return key_hash_flash(c, &dent->key);
+
+	return ((loff_t)key_hash_flash(c, &dent->key)) << UBIFS_DH_BITS |
+		le32_to_cpu(dent->cookie);
+}
+
+/**
+ * key_get_hash_from_dir_pos - extracts the flash key from a directory offset.
+ * @c: UBIFS file-system description object
+ * @file: the file handle of the directory
+ * @pos: the directory offset provied by VFS
+ */
+static inline uint32_t key_get_hash_from_dir_pos(const struct ubifs_info *c,
+						 struct file *file, loff_t pos)
+{
+	if (key_want_short_hash(file))
+		return pos & UBIFS_S_KEY_HASH_MASK;
+
+	return (pos >> UBIFS_DH_BITS) & UBIFS_S_KEY_HASH_MASK;
+}
+
+/**
+ * key_get_cookie_from_dir_pos - extracts the double hash cookie from a
+ * directory offset.
+ * @c: UBIFS file-system description object
+ * @pos: the directory offset provied by VFS
+ */
+static inline uint32_t key_get_cookie_from_dir_pos(const struct ubifs_info *c,
+						   loff_t pos)
+{
+	return pos & UBIFS_DH_MASK;
+}
+
+/**
  * key_block - get data block number.
  * @c: UBIFS file-system description object
  * @key: the key to get the block number from
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 298b4d89eee9..f14dcc890e47 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -44,6 +44,7 @@
 #include <linux/fscrypt_notsupp.h>
 #endif
 #include <linux/random.h>
+#include <linux/compat.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
-- 
2.12.0
