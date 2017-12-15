From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 20/24] fscrypt: move fscrypt_symlink_data to
 fscrypt_private.h
Date: Fri, 15 Dec 2017 09:42:21 -0800
Message-ID: <20171215174225.31583-21-ebiggers3@gmail.com>
References: <20171215174225.31583-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171215174225.31583-1-ebiggers3@gmail.com>
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

Now that all filesystems have been converted to use the symlink helper
functions, they no longer need the declaration of 'struct
fscrypt_symlink_data'.  Move it from fscrypt.h to fscrypt_private.h.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 9 +++++++++
 include/linux/fscrypt.h     | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 6995bca5006b..cec9ce309f41 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -50,6 +50,15 @@ struct fscrypt_context {
 
 #define FS_ENCRYPTION_CONTEXT_FORMAT_V1		1
 
+/**
+ * For encrypted symlinks, the ciphertext length is stored at the beginning
+ * of the string in little-endian format.
+ */
+struct fscrypt_symlink_data {
+	__le16 len;
+	char encrypted_path[1];
+} __packed;
+
 /*
  * A pointer to this structure is stored in the file system's in-core
  * representation of an inode.
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 6a678d0e956a..952ab97af325 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -21,15 +21,6 @@
 struct fscrypt_ctx;
 struct fscrypt_info;
 
-/**
- * For encrypted symlinks, the ciphertext length is stored at the beginning
- * of the string in little-endian format.
- */
-struct fscrypt_symlink_data {
-	__le16 len;
-	char encrypted_path[1];
-} __packed;
-
 struct fscrypt_str {
 	unsigned char *name;
 	u32 len;
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
