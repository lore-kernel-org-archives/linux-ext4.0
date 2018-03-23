From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 05/14] fscrypt: don't clear flags on crypto
 transform
Date: Fri, 23 Mar 2018 12:23:49 -0700
Message-ID: <20180323192358.95691-6-ebiggers3@gmail.com>
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

fscrypt is clearing the flags on the crypto_skcipher it allocates for
each inode.  But, this is unnecessary and may cause problems in the
future because it will even clear flags that are meant to be internal to
the crypto API, e.g. CRYPTO_TFM_NEED_KEY.

Remove the unnecessary flag clearing.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 8099388f5581..1435a1c81010 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -327,7 +327,6 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		goto out;
 	}
 	crypt_info->ci_ctfm = ctfm;
-	crypto_skcipher_clear_flags(ctfm, ~0);
 	crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_REQ_WEAK_KEY);
 	/*
 	 * if the provided key is longer than keysize, we use the first
-- 
2.17.0.rc0.231.g781580f067-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
