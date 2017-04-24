From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/6] ext4: switch to using fscrypt_match_name()
Date: Mon, 24 Apr 2017 10:00:11 -0700
Message-ID: <20170424170013.85175-5-ebiggers3@gmail.com>
References: <20170424170013.85175-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: hashimoto@chromium.org, Gwendal Grignou <gwendal@chromium.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-ext4@vger.kernel.org, kinaba@chromium.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170424170013.85175-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Switch ext4 directory searches to use the fscrypt_match_name() helper
function.  There should be no functional change.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/namei.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e6301b6933fc..6ecc3ae87a79 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1245,29 +1245,17 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 static inline int ext4_match(struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 *de)
 {
-	const void *name = fname_name(fname);
-	u32 len = fname_len(fname);
+	struct fscrypt_name f;
 
 	if (!de->inode)
 		return 0;
 
+	f.usr_fname = fname->usr_fname;
+	f.disk_name = fname->disk_name;
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-	if (unlikely(!name)) {
-		if (fname->usr_fname->name[0] == '_') {
-			int ret;
-			if (de->name_len <= 32)
-				return 0;
-			ret = memcmp(de->name + ((de->name_len - 17) & ~15),
-				     fname->crypto_buf.name + 8, 16);
-			return (ret == 0) ? 1 : 0;
-		}
-		name = fname->crypto_buf.name;
-		len = fname->crypto_buf.len;
-	}
+	f.crypto_buf = fname->crypto_buf;
 #endif
-	if (de->name_len != len)
-		return 0;
-	return (memcmp(de->name, name, len) == 0) ? 1 : 0;
+	return fscrypt_match_name(&f, de->name, de->name_len);
 }
 
 /*
-- 
2.12.2.816.g2cccc81164-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
