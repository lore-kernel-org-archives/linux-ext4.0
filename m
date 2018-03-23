From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 07/14] fscrypt: drop max_namelen check from
 fname_decrypt()
Date: Fri, 23 Mar 2018 12:23:51 -0700
Message-ID: <20180323192358.95691-8-ebiggers3@gmail.com>
References: <20180323192358.95691-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
 linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180323192358.95691-1-ebiggers3@gmail.com>
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

fname_decrypt() returns an error if the input filename is longer than
the inode's ->max_namelen() as given by the filesystem.  But, this
doesn't actually make sense because the filesystem provided the input
filename in the first place, where it was subject to the filesystem's
limits.  And fscrypt_decrypt() has no internal limit itself.

Thus, remove this unnecessary check.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 8088a606c0aa..cc9590b5f371 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -93,14 +93,11 @@ static int fname_decrypt(struct inode *inode,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
-	struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_ctfm;
+	struct crypto_skcipher *tfm = inode->i_crypt_info->ci_ctfm;
 	int res = 0;
 	char iv[FS_CRYPTO_BLOCK_SIZE];
-	unsigned lim;
 
-	lim = inode->i_sb->s_cop->max_namelen(inode);
-	if (iname->len <= 0 || iname->len > lim)
+	if (iname->len <= 0)
 		return -EIO;
 
 	/* Allocate request */
-- 
2.17.0.rc0.231.g781580f067-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
