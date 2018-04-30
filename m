From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 04/15] fscrypt: remove error messages for
 skcipher_request_alloc() failure
Date: Mon, 30 Apr 2018 15:51:38 -0700
Message-ID: <20180430225149.183514-5-ebiggers3@gmail.com>
References: <20180430225149.183514-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
 linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180430225149.183514-1-ebiggers3@gmail.com>
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

skcipher_request_alloc() can only fail due to lack of memory, and in
that case the memory allocator will have already printed a detailed
error message.  Thus, remove the redundant error messages from fscrypt.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c |  6 +-----
 fs/crypto/fname.c  | 10 ++--------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index f2b2d8408a01..58761d816751 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -156,12 +156,8 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 	}
 
 	req = skcipher_request_alloc(tfm, gfp_flags);
-	if (!req) {
-		printk_ratelimited(KERN_ERR
-				"%s: crypto_request_alloc() failed\n",
-				__func__);
+	if (!req)
 		return -ENOMEM;
-	}
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index e33f3d3c5ade..3b5164b159cb 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -59,11 +59,8 @@ int fname_encrypt(struct inode *inode, const struct qstr *iname,
 
 	/* Set up the encryption request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
-	if (!req) {
-		printk_ratelimited(KERN_ERR
-			"%s: skcipher_request_alloc() failed\n", __func__);
+	if (!req)
 		return -ENOMEM;
-	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 			crypto_req_done, &wait);
@@ -108,11 +105,8 @@ static int fname_decrypt(struct inode *inode,
 
 	/* Allocate request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
-	if (!req) {
-		printk_ratelimited(KERN_ERR
-			"%s: crypto_request_alloc() failed\n",  __func__);
+	if (!req)
 		return -ENOMEM;
-	}
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		crypto_req_done, &wait);
-- 
2.17.0.441.gb46fe60e1d-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
