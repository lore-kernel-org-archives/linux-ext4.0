From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: make XTS tweak initialization
	endian-independent
Date: Fri, 30 Sep 2016 10:58:49 -0700
Message-ID: <1475258329-146528-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jaegeuk@kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	Eric Biggers <ebiggers@google.com>, linux-f2fs-devel@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

The XTS tweak (or IV) was initialized differently on little endian and
big endian systems.  Because the ciphertext depends on the XTS tweak, it
was not possible to use an encrypted filesystem created by a little
endian system on a big endian system and vice versa, even if they shared
the same PAGE_SIZE.  Fix this by always using little endian.

This will break hypothetical big endian users of ext4 or f2fs
encryption.  However, all users we are aware of are little endian, and
it's believed that "real" big endian users are unlikely to exist yet.
So this might as well be fixed now before it's too late.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 61057b7d..98f87fe 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -151,7 +151,10 @@ static int do_page_crypto(struct inode *inode,
 			struct page *src_page, struct page *dest_page,
 			gfp_t gfp_flags)
 {
-	u8 xts_tweak[FS_XTS_TWEAK_SIZE];
+	struct {
+		__le64 index;
+		u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
+	} xts_tweak;
 	struct skcipher_request *req = NULL;
 	DECLARE_FS_COMPLETION_RESULT(ecr);
 	struct scatterlist dst, src;
@@ -171,17 +174,15 @@ static int do_page_crypto(struct inode *inode,
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		page_crypt_complete, &ecr);
 
-	BUILD_BUG_ON(FS_XTS_TWEAK_SIZE < sizeof(index));
-	memcpy(xts_tweak, &index, sizeof(index));
-	memset(&xts_tweak[sizeof(index)], 0,
-			FS_XTS_TWEAK_SIZE - sizeof(index));
+	BUILD_BUG_ON(sizeof(xts_tweak) != FS_XTS_TWEAK_SIZE);
+	xts_tweak.index = cpu_to_le64(index);
+	memset(xts_tweak.padding, 0, sizeof(xts_tweak.padding));
 
 	sg_init_table(&dst, 1);
 	sg_set_page(&dst, dest_page, PAGE_SIZE, 0);
 	sg_init_table(&src, 1);
 	sg_set_page(&src, src_page, PAGE_SIZE, 0);
-	skcipher_request_set_crypt(req, &src, &dst, PAGE_SIZE,
-					xts_tweak);
+	skcipher_request_set_crypt(req, &src, &dst, PAGE_SIZE, &xts_tweak);
 	if (rw == FS_DECRYPT)
 		res = crypto_skcipher_decrypt(req);
 	else
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
