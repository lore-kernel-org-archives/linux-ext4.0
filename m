From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 08/13] fscrypto: use standard macros from kernel.h
Date: Sun,  3 Apr 2016 00:21:59 -0500
Message-ID: <1459660924-2960-9-git-send-email-ebiggers3@gmail.com>
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

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/fname.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index cd0eae8..e5c6959 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -14,11 +14,6 @@
 #include <linux/ratelimit.h>
 #include <linux/fscrypto.h>
 
-static u32 size_round_up(size_t size, size_t blksize)
-{
-	return ((size + blksize - 1) / blksize) * blksize;
-}
-
 /**
  * fname_crypt_complete() - The completion callback for filename encryption and
  *			    decryption
@@ -61,10 +56,9 @@ static int fname_encrypt(struct inode *inode,
 	if (iname->len <= 0 || iname->len > lim)
 		return -EIO;
 
-	ciphertext_len = (iname->len < FS_CRYPTO_BLOCK_SIZE) ?
-					FS_CRYPTO_BLOCK_SIZE : iname->len;
-	ciphertext_len = size_round_up(ciphertext_len, padding);
-	ciphertext_len = (ciphertext_len > lim) ? lim : ciphertext_len;
+	ciphertext_len = max_t(u32, iname->len, FS_CRYPTO_BLOCK_SIZE);
+	ciphertext_len = round_up(ciphertext_len, padding);
+	ciphertext_len = min(ciphertext_len, lim);
 
 	if (ciphertext_len <= sizeof(buf)) {
 		workbuf = buf;
@@ -235,9 +229,8 @@ u32 fscrypt_fname_encrypted_size(struct inode *inode, u32 ilen)
 
 	if (ci)
 		padding = 4 << (ci->ci_flags & FS_POLICY_FLAGS_PAD_MASK);
-	if (ilen < FS_CRYPTO_BLOCK_SIZE)
-		ilen = FS_CRYPTO_BLOCK_SIZE;
-	return size_round_up(ilen, padding);
+	ilen = max_t(u32, ilen, FS_CRYPTO_BLOCK_SIZE);
+	return round_up(ilen, padding);
 }
 EXPORT_SYMBOL(fscrypt_fname_encrypted_size);
 
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
