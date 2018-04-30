From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 08/15] fscrypt: drop max_namelen check from fname_decrypt()
Date: Mon, 30 Apr 2018 15:51:42 -0700
Message-ID: <20180430225149.183514-9-ebiggers3@gmail.com>
References: <20180430225149.183514-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
 linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20180430225149.183514-1-ebiggers3@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fname_decrypt() returns an error if the input filename is longer than
the inode's ->max_namelen() as given by the filesystem.  But, this
doesn't actually make sense because the filesystem provided the input
filename in the first place, where it was subject to the filesystem's
limits.  And fname_decrypt() has no internal limit itself.

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
2.17.0.441.gb46fe60e1d-goog


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
