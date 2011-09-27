From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/3] libcrc32c: Expose big-endian version of crc32c
Date: Tue, 27 Sep 2011 15:12:53 -0700
Message-ID: <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com>
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Provide a big-endian version of crc32c for modules that want it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 include/linux/crc32c.h |    5 +++--
 lib/libcrc32c.c        |   43 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 37 insertions(+), 11 deletions(-)


diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
index bd8b44d..33320e1 100644
--- a/include/linux/crc32c.h
+++ b/include/linux/crc32c.h
@@ -3,9 +3,10 @@
 
 #include <linux/types.h>
 
-extern u32 crc32c(u32 crc, const void *address, unsigned int length);
+extern u32 crc32c_le(u32 crc, const void *address, unsigned int length);
+extern u32 crc32c_be(u32 crc, const void *address, unsigned int length);
 
 /* This macro exists for backwards-compatibility. */
-#define crc32c_le crc32c
+#define crc32c crc32c_le
 
 #endif	/* _LINUX_CRC32C_H */
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..e421ff5 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -37,17 +37,17 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-static struct crypto_shash *tfm;
+static struct crypto_shash *tfm_le, *tfm_be;
 
-u32 crc32c(u32 crc, const void *address, unsigned int length)
+u32 crc32c_le(u32 crc, const void *address, unsigned int length)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
+		char ctx[crypto_shash_descsize(tfm_le)];
 	} desc;
 	int err;
 
-	desc.shash.tfm = tfm;
+	desc.shash.tfm = tfm_le;
 	desc.shash.flags = 0;
 	*(u32 *)desc.ctx = crc;
 
@@ -56,21 +56,46 @@ u32 crc32c(u32 crc, const void *address, unsigned int length)
 
 	return *(u32 *)desc.ctx;
 }
+EXPORT_SYMBOL(crc32c_le);
 
-EXPORT_SYMBOL(crc32c);
+u32 crc32c_be(u32 crc, const void *address, unsigned int length)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(tfm_be)];
+	} desc;
+	int err;
+
+	desc.shash.tfm = tfm_be;
+	desc.shash.flags = 0;
+	*(u32 *)desc.ctx = crc;
+
+	err = crypto_shash_update(&desc.shash, address, length);
+	BUG_ON(err);
+
+	return *(u32 *)desc.ctx;
+}
+EXPORT_SYMBOL(crc32c_be);
 
 static int __init libcrc32c_mod_init(void)
 {
-	tfm = crypto_alloc_shash("crc32c", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
+	tfm_le = crypto_alloc_shash("crc32c", 0, 0);
+	if (IS_ERR(tfm_le))
+		return PTR_ERR(tfm_le);
+
+	tfm_be = crypto_alloc_shash("crc32c-be", 0, 0);
+	if (IS_ERR(tfm_be)) {
+		crypto_free_shash(tfm_le);
+		return PTR_ERR(tfm_be);
+	}
 
 	return 0;
 }
 
 static void __exit libcrc32c_mod_fini(void)
 {
-	crypto_free_shash(tfm);
+	crypto_free_shash(tfm_be);
+	crypto_free_shash(tfm_le);
 }
 
 module_init(libcrc32c_mod_init);
