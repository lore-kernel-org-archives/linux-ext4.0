From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 1/2] ext2:  Support large blocksize up to PAGESIZE
Date: Mon, 01 Oct 2007 17:35:35 -0700
Message-ID: <1191285335.11737.57.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, Jan Kara <jack@suse.cz>, clameter@sgi.com,
	akpm@osdl.org
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34022 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXJBArU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 20:47:20 -0400
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Support large blocksize up to PAGESIZE (max 64KB) for ext2

From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext2,
just enlarging the block size limit. But it is NOT possible to have 64kB
blocksize on ext2 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is treat 64k rec_len
with a an impossible value like rec_len = 0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext2: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext2: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext2, and able to handle empty directory block.

Please consider to include to mm tree.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---

 fs/ext2/super.c         |    3 ++-
 include/linux/ext2_fs.h |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 639a32c..765c805 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -775,7 +775,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
+			printk(KERN_ERR "EXT2-fs: bad blocksize %d.\n",
+				blocksize);
 			goto failed_sbi;
 		}
 
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 153d755..910a705 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -86,8 +86,8 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
  * Macro-instructions used to manage several block sizes
  */
 #define EXT2_MIN_BLOCK_SIZE		1024
-#define	EXT2_MAX_BLOCK_SIZE		4096
-#define EXT2_MIN_BLOCK_LOG_SIZE		  10
+#define EXT2_MAX_BLOCK_SIZE		65536
+#define EXT2_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
