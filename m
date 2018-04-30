From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 09/15] fscrypt: drop empty name check from
 fname_decrypt()
Date: Mon, 30 Apr 2018 15:51:43 -0700
Message-ID: <20180430225149.183514-10-ebiggers3@gmail.com>
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

fname_decrypt() is validating that the encrypted filename is nonempty.
However, earlier a stronger precondition was already enforced: the
encrypted filename must be at least 16 (FS_CRYPTO_BLOCK_SIZE) bytes.

Drop the redundant check for an empty filename.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index cc9590b5f371..c4eb3a235ae4 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -97,9 +97,6 @@ static int fname_decrypt(struct inode *inode,
 	int res = 0;
 	char iv[FS_CRYPTO_BLOCK_SIZE];
 
-	if (iname->len <= 0)
-		return -EIO;
-
 	/* Allocate request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
 	if (!req)
-- 
2.17.0.441.gb46fe60e1d-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
