From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 01/13] fscrypto: remove unnecessary includes
Date: Sun,  3 Apr 2016 00:21:52 -0500
Message-ID: <1459660924-2960-2-git-send-email-ebiggers3@gmail.com>
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
 fs/crypto/crypto.c  | 1 -
 fs/crypto/fname.c   | 2 --
 fs/crypto/keyinfo.c | 3 ---
 3 files changed, 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 06cd1a2..2c7923d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -27,7 +27,6 @@
 #include <linux/bio.h>
 #include <linux/dcache.h>
 #include <linux/fscrypto.h>
-#include <linux/ecryptfs.h>
 
 static unsigned int num_prealloc_crypto_pages = 32;
 static unsigned int num_prealloc_crypto_ctxs = 128;
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 5d6d491..3108806 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -10,8 +10,6 @@
  * This has not yet undergone a rigorous security audit.
  */
 
-#include <keys/encrypted-type.h>
-#include <keys/user-type.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
 #include <linux/fscrypto.h>
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 06f5aa4..03d2b0d 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -8,11 +8,8 @@
  * Written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar, 2015.
  */
 
-#include <keys/encrypted-type.h>
 #include <keys/user-type.h>
-#include <linux/random.h>
 #include <linux/scatterlist.h>
-#include <uapi/linux/keyctl.h>
 #include <linux/fscrypto.h>
 
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
