From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 03/15] fscrypt: remove unnecessary NULL check
 when allocating skcipher
Date: Mon, 30 Apr 2018 15:51:37 -0700
Message-ID: <20180430225149.183514-4-ebiggers3@gmail.com>
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

crypto_alloc_skcipher() returns an ERR_PTR() on failure, not NULL.
Remove the unnecessary check for NULL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 05f5ee1f0705..d09df8f751df 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -318,8 +318,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		goto out;
 	}
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
-	if (!ctfm || IS_ERR(ctfm)) {
-		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
+	if (IS_ERR(ctfm)) {
+		res = PTR_ERR(ctfm);
 		pr_debug("%s: error %d (inode %lu) allocating crypto tfm\n",
 			 __func__, res, inode->i_ino);
 		goto out;
-- 
2.17.0.441.gb46fe60e1d-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
