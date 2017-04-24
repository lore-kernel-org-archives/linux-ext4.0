From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 5/6] f2fs: switch to using fscrypt_match_name()
Date: Mon, 24 Apr 2017 10:00:12 -0700
Message-ID: <20170424170013.85175-6-ebiggers3@gmail.com>
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

Switch f2fs directory searches to use the fscrypt_match_name() helper
function.  There should be no functional change.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/dir.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5df3596a667a..c7ed25fb3003 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -111,8 +111,6 @@ struct f2fs_dir_entry *find_target_dentry(struct fscrypt_name *fname,
 	struct f2fs_dir_entry *de;
 	unsigned long bit_pos = 0;
 	int max_len = 0;
-	struct fscrypt_str de_name = FSTR_INIT(NULL, 0);
-	struct fscrypt_str *name = &fname->disk_name;
 
 	if (max_slots)
 		*max_slots = 0;
@@ -130,29 +128,11 @@ struct f2fs_dir_entry *find_target_dentry(struct fscrypt_name *fname,
 			continue;
 		}
 
-		if (de->hash_code != namehash)
-			goto not_match;
-
-		de_name.name = d->filename[bit_pos];
-		de_name.len = le16_to_cpu(de->name_len);
-
-#ifdef CONFIG_F2FS_FS_ENCRYPTION
-		if (unlikely(!name->name)) {
-			if (fname->usr_fname->name[0] == '_') {
-				if (de_name.len > 32 &&
-					!memcmp(de_name.name + ((de_name.len - 17) & ~15),
-						fname->crypto_buf.name + 8, 16))
-					goto found;
-				goto not_match;
-			}
-			name->name = fname->crypto_buf.name;
-			name->len = fname->crypto_buf.len;
-		}
-#endif
-		if (de_name.len == name->len &&
-				!memcmp(de_name.name, name->name, name->len))
+		if (de->hash_code == namehash &&
+		    fscrypt_match_name(fname, d->filename[bit_pos],
+				       le16_to_cpu(de->name_len)))
 			goto found;
-not_match:
+
 		if (max_slots && max_len > *max_slots)
 			*max_slots = max_len;
 		max_len = 0;
-- 
2.12.2.816.g2cccc81164-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
