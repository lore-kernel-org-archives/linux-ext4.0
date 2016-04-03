From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 06/13] fscrypto: crypto_alloc_skcipher() always
	returns an ERR_PTR(), never NULL
Date: Sun,  3 Apr 2016 00:21:57 -0500
Message-ID: <1459660924-2960-7-git-send-email-ebiggers3@gmail.com>
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
 fs/crypto/keyinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 33296c0..cb06351 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -208,8 +208,8 @@ retry:
 		goto out;
 got_key:
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
-	if (!ctfm || IS_ERR(ctfm)) {
-		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
+	if (IS_ERR(ctfm)) {
+		res = PTR_ERR(ctfm);
 		printk(KERN_DEBUG
 		       "%s: error %d (inode %u) allocating crypto tfm\n",
 		       __func__, res, (unsigned) inode->i_ino);
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
