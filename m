From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 01/11] fscrypt: move
 fscrypt_has_encryption_key() to supp/notsupp headers
Date: Fri,  5 Jan 2018 10:44:52 -0800
Message-ID: <20180105184502.48473-2-ebiggers3@gmail.com>
References: <20180105184502.48473-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180105184502.48473-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_has_encryption_key() is already split into two versions
depending on whether the filesystem is being built with encryption
support or not.  Move them into the appropriate headers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/fscrypt.h         | 10 ----------
 include/linux/fscrypt_notsupp.h |  5 +++++
 include/linux/fscrypt_supp.h    |  5 +++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 08b4b40c5aa8..d1c891b5bd9c 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -129,11 +129,6 @@ static inline struct page *fscrypt_control_page(struct page *page)
 	return ((struct fscrypt_ctx *)page_private(page))->w.control_page;
 }
 
-static inline bool fscrypt_has_encryption_key(const struct inode *inode)
-{
-	return (inode->i_crypt_info != NULL);
-}
-
 #include <linux/fscrypt_supp.h>
 
 #else /* !__FS_HAS_ENCRYPTION */
@@ -144,11 +139,6 @@ static inline struct page *fscrypt_control_page(struct page *page)
 	return ERR_PTR(-EINVAL);
 }
 
-static inline bool fscrypt_has_encryption_key(const struct inode *inode)
-{
-	return 0;
-}
-
 #include <linux/fscrypt_notsupp.h>
 #endif /* __FS_HAS_ENCRYPTION */
 
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 63e58808519a..52e330285457 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -14,6 +14,11 @@
 #ifndef _LINUX_FSCRYPT_NOTSUPP_H
 #define _LINUX_FSCRYPT_NOTSUPP_H
 
+static inline bool fscrypt_has_encryption_key(const struct inode *inode)
+{
+	return false;
+}
+
 /* crypto.c */
 static inline struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *inode,
 						  gfp_t gfp_flags)
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index cf9e9fc02f0a..79bb8beae018 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -11,6 +11,11 @@
 #ifndef _LINUX_FSCRYPT_SUPP_H
 #define _LINUX_FSCRYPT_SUPP_H
 
+static inline bool fscrypt_has_encryption_key(const struct inode *inode)
+{
+	return (inode->i_crypt_info != NULL);
+}
+
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
-- 
2.16.0.rc0.223.g4a4ac83678-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
