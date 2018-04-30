From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 06/15] fscrypt: don't clear flags on crypto transform
Date: Mon, 30 Apr 2018 15:51:40 -0700
Message-ID: <20180430225149.183514-7-ebiggers3@gmail.com>
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
index d09df8f751df..0f6a65c6483b 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -325,7 +325,6 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		goto out;
 	}
 	crypt_info->ci_ctfm = ctfm;
-	crypto_skcipher_clear_flags(ctfm, ~0);
 	crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_REQ_WEAK_KEY);
 	/*
 	 * if the provided key is longer than keysize, we use the first
-- 
2.17.0.441.gb46fe60e1d-goog


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
