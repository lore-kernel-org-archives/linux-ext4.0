From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 02/13] fscrypto: rename some functions for clarity
Date: Sun,  3 Apr 2016 00:21:53 -0500
Message-ID: <1459660924-2960-3-git-send-email-ebiggers3@gmail.com>
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

Rename fscrypt_complete() to page_crypt_complete().  This callback is
specifically for data pages; fscrypto also performs filename encryption.

Rename dir_crypt_complete() to fname_crypt_complete().  This callback is
also used for symlink targets, not just directory entries.

Rename fscrypt_process_policy() to fscrypt_set_policy().  The new name
better matches the ioctl, and it goes along with fscrypt_get_policy().

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/crypto.c       | 11 ++++++-----
 fs/crypto/fname.c        | 11 +++++++----
 fs/crypto/policy.c       |  5 ++---
 fs/f2fs/f2fs.h           |  2 +-
 fs/f2fs/file.c           |  2 +-
 include/linux/fscrypto.h |  5 ++---
 6 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 2c7923d..6e550ec 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -125,11 +125,12 @@ struct fscrypt_ctx *fscrypt_get_ctx(struct inode *inode)
 EXPORT_SYMBOL(fscrypt_get_ctx);
 
 /**
- * fscrypt_complete() - The completion callback for page encryption
- * @req: The asynchronous encryption request context
- * @res: The result of the encryption operation
+ * page_crypt_complete() - The completion callback for page encryption and
+ *			   decryption
+ * @req: The asynchronous cipher request context
+ * @res: The result of the cipher operation
  */
-static void fscrypt_complete(struct crypto_async_request *req, int res)
+static void page_crypt_complete(struct crypto_async_request *req, int res)
 {
 	struct fscrypt_completion_result *ecr = req->data;
 
@@ -166,7 +167,7 @@ static int do_page_crypto(struct inode *inode,
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		fscrypt_complete, &ecr);
+		page_crypt_complete, &ecr);
 
 	BUILD_BUG_ON(FS_XTS_TWEAK_SIZE < sizeof(index));
 	memcpy(xts_tweak, &index, sizeof(index));
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 3108806..c3e3554 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -20,9 +20,12 @@ static u32 size_round_up(size_t size, size_t blksize)
 }
 
 /**
- * dir_crypt_complete() -
+ * fname_crypt_complete() - The completion callback for filename encryption and
+ *			    decryption
+ * @req: The asynchronous cipher request context
+ * @res: The result of the cipher operation
  */
-static void dir_crypt_complete(struct crypto_async_request *req, int res)
+static void fname_crypt_complete(struct crypto_async_request *req, int res)
 {
 	struct fscrypt_completion_result *ecr = req->data;
 
@@ -82,7 +85,7 @@ static int fname_encrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			dir_crypt_complete, &ecr);
+			fname_crypt_complete, &ecr);
 
 	/* Copy the input */
 	memcpy(workbuf, iname->name, iname->len);
@@ -144,7 +147,7 @@ static int fname_decrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		dir_crypt_complete, &ecr);
+		fname_crypt_complete, &ecr);
 
 	/* Initialize IV */
 	memset(iv, 0, FS_CRYPTO_BLOCK_SIZE);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 0f9961e..e1d263d 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -92,8 +92,7 @@ static int create_encryption_context_from_policy(struct inode *inode,
 	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
 }
 
-int fscrypt_process_policy(struct inode *inode,
-				const struct fscrypt_policy *policy)
+int fscrypt_set_policy(struct inode *inode, const struct fscrypt_policy *policy)
 {
 	if (policy->version != 0)
 		return -EINVAL;
@@ -113,7 +112,7 @@ int fscrypt_process_policy(struct inode *inode,
 	       __func__);
 	return -EINVAL;
 }
-EXPORT_SYMBOL(fscrypt_process_policy);
+EXPORT_SYMBOL(fscrypt_set_policy);
 
 int fscrypt_get_policy(struct inode *inode, struct fscrypt_policy *policy)
 {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bbe2cd1..970678d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2172,7 +2172,7 @@ static inline bool f2fs_may_encrypt(struct inode *inode)
 #define fscrypt_pullback_bio_page	fscrypt_notsupp_pullback_bio_page
 #define fscrypt_restore_control_page	fscrypt_notsupp_restore_control_page
 #define fscrypt_zeroout_range		fscrypt_notsupp_zeroout_range
-#define fscrypt_process_policy		fscrypt_notsupp_process_policy
+#define fscrypt_set_policy		fscrypt_notsupp_set_policy
 #define fscrypt_get_policy		fscrypt_notsupp_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b41c357..ea2c9a9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1542,7 +1542,7 @@ static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 		return -EFAULT;
 
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	return fscrypt_process_policy(inode, &policy);
+	return fscrypt_set_policy(inode, &policy);
 }
 
 static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index cd91f75..4e7bc69 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -273,8 +273,7 @@ extern void fscrypt_restore_control_page(struct page *);
 extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 						unsigned int);
 /* policy.c */
-extern int fscrypt_process_policy(struct inode *,
-					const struct fscrypt_policy *);
+extern int fscrypt_set_policy(struct inode *, const struct fscrypt_policy *);
 extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
@@ -343,7 +342,7 @@ static inline int fscrypt_notsupp_zeroout_range(struct inode *i, pgoff_t p,
 }
 
 /* policy.c */
-static inline int fscrypt_notsupp_process_policy(struct inode *i,
+static inline int fscrypt_notsupp_set_policy(struct inode *i,
 				const struct fscrypt_policy *p)
 {
 	return -EOPNOTSUPP;
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
