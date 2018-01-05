From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 09/11] fscrypt: trim down fscrypt.h includes
Date: Fri,  5 Jan 2018 10:45:00 -0800
Message-ID: <20180105184502.48473-10-ebiggers3@gmail.com>
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

fscrypt.h included way too many other headers, given that it is included
by filesystems both with and without encryption support.  Trim down the
includes list by moving the needed includes into more appropriate
places, and removing the unneeded ones.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c           | 1 +
 fs/crypto/fname.c            | 1 +
 fs/crypto/keyinfo.c          | 1 +
 include/linux/fscrypt.h      | 6 ------
 include/linux/fscrypt_supp.h | 3 +++
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 732a786cce9d..ce654526c0fb 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -27,6 +27,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
 static unsigned int num_prealloc_crypto_pages = 32;
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index b8c5061553b1..52d4dbe1e8e7 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -13,6 +13,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
+#include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 5e6e846f5a24..c115eac4b4cf 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -14,6 +14,7 @@
 #include <linux/ratelimit.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
+#include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
 static struct crypto_shash *essiv_hash_tfm;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 3045fc49d3ca..071ebabfc287 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -14,13 +14,7 @@
 #ifndef _LINUX_FSCRYPT_H
 #define _LINUX_FSCRYPT_H
 
-#include <linux/key.h>
 #include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/bio.h>
-#include <linux/dcache.h>
-#include <crypto/skcipher.h>
-#include <uapi/linux/fs.h>
 
 #define FS_CRYPTO_BLOCK_SIZE		16
 
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index ce61caf26f40..562a9bc04560 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -11,6 +11,9 @@
 #ifndef _LINUX_FSCRYPT_SUPP_H
 #define _LINUX_FSCRYPT_SUPP_H
 
+#include <linux/mm.h>
+#include <linux/slab.h>
+
 /*
  * fscrypt superblock flags
  */
-- 
2.16.0.rc0.223.g4a4ac83678-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
