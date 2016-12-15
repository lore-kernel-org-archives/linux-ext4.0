From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/3] fscrypt: fix renaming and linking special
	files
Date: Thu, 15 Dec 2016 11:19:43 -0800
Message-ID: <1481829584-50218-2-git-send-email-ebiggers3@gmail.com>
References: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>, "Theodore Y . Ts'o" <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>, Richard Weinberger <richard@nod.at>,
	linux-f2fs-devel@lists.sourceforge.net,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
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

Attempting to link a device node, named pipe, or socket file into an
encrypted directory through rename(2) or link(2) always failed with
EPERM.  This happened because fscrypt_permitted_context() saw that the
file was unencrypted and forbid creating the link.  This behavior was
unexpected because such files are never encrypted; only regular files,
directories, and symlinks can be encrypted.

To fix this, make fscrypt_has_permitted_context() always return true on
special files.

This will be covered by a test in my encryption xfstests patchset.

Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 5de0633..2e50cbc 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -198,6 +198,11 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 	if (!cops->is_encrypted(parent))
 		return 1;
 
+	/* No restrictions on file types which are never encrypted */
+	if (!S_ISREG(child->i_mode) && !S_ISDIR(child->i_mode) &&
+	    !S_ISLNK(child->i_mode))
+		return 1;
+
 	/* Encrypted directories must not contain unencrypted files */
 	if (!cops->is_encrypted(child))
 		return 0;
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
