From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 03/13] fscrypto: rename functions to load and
	unload inode encryption info
Date: Sun,  3 Apr 2016 00:21:54 -0500
Message-ID: <1459660924-2960-4-git-send-email-ebiggers3@gmail.com>
References: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Eric Biggers <ebiggers3@gmail.com>, mhalcrow@google.com,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Perform the following renamings:

	fscrypt_get_encryption_info() => fscrypt_load_encryption_info()
	fscrypt_put_encryption_info() => fscrypt_unload_encryption_info()
	get_crypt_info => load_crypt_info()
	put_crypt_info() => free_crypt_info()

The new names better reflect the actual behavior where the "load"
function just loads the fscrypt_info into i_crypto_info; it doesn't
actually return it to the caller.  There is also no reference counting
involved, as might be suggested by the verbs "get" and "put".

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/fname.c        |  2 +-
 fs/crypto/keyinfo.c      | 23 ++++++++++++-----------
 fs/crypto/policy.c       |  8 ++++----
 fs/f2fs/dir.c            |  4 ++--
 fs/f2fs/f2fs.h           |  4 ++--
 fs/f2fs/file.c           |  8 ++++----
 fs/f2fs/inode.c          |  2 +-
 fs/f2fs/namei.c          | 10 +++++-----
 fs/f2fs/super.c          |  2 +-
 include/linux/fscrypto.h | 11 ++++++-----
 10 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index c3e3554..ceaa815 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -361,7 +361,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 		fname->disk_name.len = iname->len;
 		return 0;
 	}
-	ret = get_crypt_info(dir);
+	ret = load_crypt_info(dir);
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 03d2b0d..e0b3281 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -75,7 +75,7 @@ out:
 	return res;
 }
 
-static void put_crypt_info(struct fscrypt_info *ci)
+static void free_crypt_info(struct fscrypt_info *ci)
 {
 	if (!ci)
 		return;
@@ -85,7 +85,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
-int get_crypt_info(struct inode *inode)
+int load_crypt_info(struct inode *inode)
 {
 	struct fscrypt_info *crypt_info;
 	u8 full_key_descriptor[FS_KEY_DESC_PREFIX_SIZE +
@@ -112,7 +112,7 @@ retry:
 		if (!crypt_info->ci_keyring_key ||
 				key_validate(crypt_info->ci_keyring_key) == 0)
 			return 0;
-		fscrypt_put_encryption_info(inode, crypt_info);
+		fscrypt_unload_encryption_info(inode, crypt_info);
 		goto retry;
 	}
 
@@ -224,7 +224,7 @@ got_key:
 
 	memzero_explicit(raw_key, sizeof(raw_key));
 	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) != NULL) {
-		put_crypt_info(crypt_info);
+		free_crypt_info(crypt_info);
 		goto retry;
 	}
 	return 0;
@@ -232,12 +232,13 @@ got_key:
 out:
 	if (res == -ENOKEY)
 		res = 0;
-	put_crypt_info(crypt_info);
+	free_crypt_info(crypt_info);
 	memzero_explicit(raw_key, sizeof(raw_key));
 	return res;
 }
 
-void fscrypt_put_encryption_info(struct inode *inode, struct fscrypt_info *ci)
+void fscrypt_unload_encryption_info(struct inode *inode,
+				    struct fscrypt_info *ci)
 {
 	struct fscrypt_info *prev;
 
@@ -250,11 +251,11 @@ void fscrypt_put_encryption_info(struct inode *inode, struct fscrypt_info *ci)
 	if (prev != ci)
 		return;
 
-	put_crypt_info(ci);
+	free_crypt_info(ci);
 }
-EXPORT_SYMBOL(fscrypt_put_encryption_info);
+EXPORT_SYMBOL(fscrypt_unload_encryption_info);
 
-int fscrypt_get_encryption_info(struct inode *inode)
+int fscrypt_load_encryption_info(struct inode *inode)
 {
 	struct fscrypt_info *ci = inode->i_crypt_info;
 
@@ -263,7 +264,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		 (ci->ci_keyring_key->flags & ((1 << KEY_FLAG_INVALIDATED) |
 					       (1 << KEY_FLAG_REVOKED) |
 					       (1 << KEY_FLAG_DEAD)))))
-		return get_crypt_info(inode);
+		return load_crypt_info(inode);
 	return 0;
 }
-EXPORT_SYMBOL(fscrypt_get_encryption_info);
+EXPORT_SYMBOL(fscrypt_load_encryption_info);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index e1d263d..03a2f50 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -155,10 +155,10 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 	/* if the child directory is not encrypted, this is always a problem */
 	if (!parent->i_sb->s_cop->is_encrypted(child))
 		return 0;
-	res = fscrypt_get_encryption_info(parent);
+	res = fscrypt_load_encryption_info(parent);
 	if (res)
 		return 0;
-	res = fscrypt_get_encryption_info(child);
+	res = fscrypt_load_encryption_info(child);
 	if (res)
 		return 0;
 	parent_ci = parent->i_crypt_info;
@@ -196,7 +196,7 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 	if (!parent->i_sb->s_cop->set_context)
 		return -EOPNOTSUPP;
 
-	res = fscrypt_get_encryption_info(parent);
+	res = fscrypt_load_encryption_info(parent);
 	if (res < 0)
 		return res;
 
@@ -223,6 +223,6 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 						sizeof(ctx), fs_data);
 	if (res)
 		return res;
-	return preload ? fscrypt_get_encryption_info(child): 0;
+	return preload ? fscrypt_load_encryption_info(child) : 0;
 }
 EXPORT_SYMBOL(fscrypt_inherit_context);
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 80641ad..5f77455 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -844,7 +844,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	int err = 0;
 
 	if (f2fs_encrypted_inode(inode)) {
-		err = fscrypt_get_encryption_info(inode);
+		err = fscrypt_load_encryption_info(inode);
 		if (err && err != -ENOKEY)
 			return err;
 
@@ -895,7 +895,7 @@ out:
 static int f2fs_dir_open(struct inode *inode, struct file *filp)
 {
 	if (f2fs_encrypted_inode(inode))
-		return fscrypt_get_encryption_info(inode) ? -EACCES : 0;
+		return fscrypt_load_encryption_info(inode) ? -EACCES : 0;
 	return 0;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 970678d..2956440 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2176,8 +2176,8 @@ static inline bool f2fs_may_encrypt(struct inode *inode)
 #define fscrypt_get_policy		fscrypt_notsupp_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
-#define fscrypt_get_encryption_info	fscrypt_notsupp_get_encryption_info
-#define fscrypt_put_encryption_info	fscrypt_notsupp_put_encryption_info
+#define fscrypt_load_encryption_info	fscrypt_notsupp_load_encryption_info
+#define fscrypt_unload_encryption_info	fscrypt_notsupp_unload_encryption_info
 #define fscrypt_setup_filename		fscrypt_notsupp_setup_filename
 #define fscrypt_free_filename		fscrypt_notsupp_free_filename
 #define fscrypt_fname_encrypted_size	fscrypt_notsupp_fname_encrypted_size
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ea2c9a9..cf691ae 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -421,7 +421,7 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	int err;
 
 	if (f2fs_encrypted_inode(inode)) {
-		err = fscrypt_get_encryption_info(inode);
+		err = fscrypt_load_encryption_info(inode);
 		if (err)
 			return 0;
 		if (!f2fs_encrypted_inode(inode))
@@ -444,7 +444,7 @@ static int f2fs_file_open(struct inode *inode, struct file *filp)
 	struct inode *dir = filp->f_path.dentry->d_parent->d_inode;
 
 	if (!ret && f2fs_encrypted_inode(inode)) {
-		ret = fscrypt_get_encryption_info(inode);
+		ret = fscrypt_load_encryption_info(inode);
 		if (ret)
 			return -EACCES;
 		if (!fscrypt_has_encryption_key(inode))
@@ -679,7 +679,7 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (f2fs_encrypted_inode(inode) &&
-				fscrypt_get_encryption_info(inode))
+				fscrypt_load_encryption_info(inode))
 			return -EACCES;
 
 		if (attr->ia_size <= i_size_read(inode)) {
@@ -1870,7 +1870,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (f2fs_encrypted_inode(inode) &&
 				!fscrypt_has_encryption_key(inode) &&
-				fscrypt_get_encryption_info(inode))
+				fscrypt_load_encryption_info(inode))
 		return -EACCES;
 
 	inode_lock(inode);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index cb269c4..cc3fe60 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -389,7 +389,7 @@ no_delete:
 		}
 	}
 out_clear:
-	fscrypt_put_encryption_info(inode, NULL);
+	fscrypt_unload_encryption_info(inode, NULL);
 	clear_inode(inode);
 }
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 7876f10..bd42674 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -263,7 +263,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	unsigned int root_ino = F2FS_ROOT_INO(F2FS_I_SB(dir));
 
 	if (f2fs_encrypted_inode(dir)) {
-		int res = fscrypt_get_encryption_info(dir);
+		int res = fscrypt_load_encryption_info(dir);
 
 		/*
 		 * DCACHE_ENCRYPTED_WITH_KEY is set if the dentry is
@@ -380,7 +380,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 	int err;
 
 	if (f2fs_encrypted_inode(dir)) {
-		err = fscrypt_get_encryption_info(dir);
+		err = fscrypt_load_encryption_info(dir);
 		if (err)
 			return err;
 
@@ -424,7 +424,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 			goto err_out;
 		}
 
-		err = fscrypt_get_encryption_info(inode);
+		err = fscrypt_load_encryption_info(inode);
 		if (err)
 			goto err_out;
 
@@ -616,7 +616,7 @@ out:
 static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	if (f2fs_encrypted_inode(dir)) {
-		int err = fscrypt_get_encryption_info(dir);
+		int err = fscrypt_load_encryption_info(dir);
 		if (err)
 			return err;
 	}
@@ -1006,7 +1006,7 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
-	res = fscrypt_get_encryption_info(inode);
+	res = fscrypt_load_encryption_info(inode);
 	if (res)
 		return ERR_PTR(res);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 15bb81f..72126cc 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -503,7 +503,7 @@ static int f2fs_drop_inode(struct inode *inode)
 
 			sb_end_intwrite(inode->i_sb);
 
-			fscrypt_put_encryption_info(inode, NULL);
+			fscrypt_unload_encryption_info(inode, NULL);
 			spin_lock(&inode->i_lock);
 			atomic_dec(&inode->i_count);
 		}
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 4e7bc69..1bf00a5 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -279,9 +279,10 @@ extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyinfo.c */
-extern int get_crypt_info(struct inode *);
-extern int fscrypt_get_encryption_info(struct inode *);
-extern void fscrypt_put_encryption_info(struct inode *, struct fscrypt_info *);
+extern int load_crypt_info(struct inode *);
+extern int fscrypt_load_encryption_info(struct inode *);
+extern void fscrypt_unload_encryption_info(struct inode *,
+					   struct fscrypt_info *);
 
 /* fname.c */
 extern int fscrypt_setup_filename(struct inode *, const struct qstr *,
@@ -367,12 +368,12 @@ static inline int fscrypt_notsupp_inherit_context(struct inode *p,
 }
 
 /* keyinfo.c */
-static inline int fscrypt_notsupp_get_encryption_info(struct inode *i)
+static inline int fscrypt_notsupp_load_encryption_info(struct inode *i)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void fscrypt_notsupp_put_encryption_info(struct inode *i,
+static inline void fscrypt_notsupp_unload_encryption_info(struct inode *i,
 					struct fscrypt_info *f)
 {
 	return;
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
