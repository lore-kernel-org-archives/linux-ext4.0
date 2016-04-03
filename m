From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 09/13] fscrypto: make fname_encrypt() actually
	return length of ciphertext
Date: Sun,  3 Apr 2016 00:22:00 -0500
Message-ID: <1459660924-2960-10-git-send-email-ebiggers3@gmail.com>
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

This makes the return value match the comment.  Previously it would
actually return 0 if encryption was successful.  (No callers currently
care.)

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/fname.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index e5c6959..5b10b73 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -100,12 +100,13 @@ static int fname_encrypt(struct inode *inode,
 	}
 	kfree(alloc_buf);
 	skcipher_request_free(req);
-	if (res < 0)
+	if (res < 0) {
 		printk_ratelimited(KERN_ERR
 				"%s: Error (error code %d)\n", __func__, res);
-
+		return res;
+	}
 	oname->len = ciphertext_len;
-	return res;
+	return ciphertext_len;
 }
 
 /*
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
