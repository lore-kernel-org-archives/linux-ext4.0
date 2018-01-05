From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 08/11] fscrypt: move fscrypt_is_dot_dotdot()
 to fs/crypto/fname.c
Date: Fri,  5 Jan 2018 10:44:59 -0800
Message-ID: <20180105184502.48473-9-ebiggers3@gmail.com>
References: <20180105184502.48473-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>,
 linux-f2fs-devel@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180105184502.48473-1-ebiggers3@gmail.com>
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

Only fs/crypto/fname.c cares about treating the "." and ".." filenames
specially with regards to encryption, so move fscrypt_is_dot_dotdot()
from fscrypt.h to there.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c       | 11 +++++++++++
 include/linux/fscrypt.h | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 305541bcd108..b8c5061553b1 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -15,6 +15,17 @@
 #include <linux/ratelimit.h>
 #include "fscrypt_private.h"
 
+static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
+{
+	if (str->len == 1 && str->name[0] == '.')
+		return true;
+
+	if (str->len == 2 && str->name[0] == '.' && str->name[1] == '.')
+		return true;
+
+	return false;
+}
+
 /**
  * fname_encrypt() - encrypt a filename
  *
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 2e4dce0365cf..3045fc49d3ca 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -57,17 +57,6 @@ struct fscrypt_name {
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	28
 
-static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
-{
-	if (str->len == 1 && str->name[0] == '.')
-		return true;
-
-	if (str->len == 2 && str->name[0] == '.' && str->name[1] == '.')
-		return true;
-
-	return false;
-}
-
 #if __FS_HAS_ENCRYPTION
 #include <linux/fscrypt_supp.h>
 #else
-- 
2.16.0.rc0.223.g4a4ac83678-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
