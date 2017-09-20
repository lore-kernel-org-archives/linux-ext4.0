From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 22/25] ubifs: switch to fscrypt_prepare_link()
Date: Wed, 20 Sep 2017 15:46:02 -0700
Message-ID: <20170920224605.22030-23-ebiggers3@gmail.com>
References: <20170920224605.22030-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-f2fs-devel@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170920224605.22030-1-ebiggers3@gmail.com>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 417fe0b29f23..09e6c56b11bc 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -743,9 +743,9 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 	ubifs_assert(inode_is_locked(dir));
 	ubifs_assert(inode_is_locked(inode));
 
-	if (ubifs_crypt_is_encrypted(dir) &&
-	    !fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+	err = fscrypt_prepare_link(old_dentry, dir, dentry);
+	if (err)
+		return err;
 
 	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
 	if (err)
-- 
2.14.1.821.g8fa685d3b7-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
