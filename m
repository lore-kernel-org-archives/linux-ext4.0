From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 01/15] fs,
 fscrypt: only define ->s_cop when FS_ENCRYPTION is enabled
Date: Mon, 30 Apr 2018 15:51:35 -0700
Message-ID: <20180430225149.183514-2-ebiggers3@gmail.com>
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

Now that filesystems only set and use their fscrypt_operations when they
are built with encryption support, we can remove ->s_cop from
'struct super_block' when FS_ENCRYPTION is disabled.  This saves a few
bytes on some kernels and also makes it consistent with ->i_crypt_info.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 760d8da1b6c7..8e2460694c3a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1364,9 +1364,9 @@ struct super_block {
 	void                    *s_security;
 #endif
 	const struct xattr_handler **s_xattr;
-
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 	const struct fscrypt_operations	*s_cop;
-
+#endif
 	struct hlist_bl_head	s_roots;	/* alternate root dentries for NFS */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device	*s_bdev;
-- 
2.17.0.441.gb46fe60e1d-goog


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
