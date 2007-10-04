From: akpm@linux-foundation.org
Subject: - ext2-support-large-blocksize-up-to-pagesize.patch removed from -mm tree
Date: Thu, 04 Oct 2007 16:10:30 -0700
Message-ID: <200710042310.l94NAVcD000652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: sho@tnes.nec.co.jp, clameter@sgi.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: support large blocksize up to PAGESIZE
has been removed from the -mm tree.  Its filename was
     ext2-support-large-blocksize-up-to-pagesize.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ext2: support large blocksize up to PAGESIZE
From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext2, just
enlarging the block size limit.  But it is NOT possible to have 64kB
blocksize on ext2 without some changes to the directory handling code.  The
reason is that an empty 64kB directory block would have a rec_len ==
(__u16)2^16 == 0, and this would cause an error to be hit in the
filesystem.  The proposed solution is treat 64k rec_len with a an
impossible value like rec_len = 0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext2: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext2: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext2, and able to handle empty directory block.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ext2/super.c~ext2-support-large-blocksize-up-to-pagesize fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-support-large-blocksize-up-to-pagesize
+++ a/fs/ext2/super.c
@@ -852,7 +852,8 @@ static int ext2_fill_super(struct super_
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
+			printk(KERN_ERR "EXT2-fs: bad blocksize %d.\n",
+				blocksize);
 			goto failed_sbi;
 		}
 
diff -puN include/linux/ext2_fs.h~ext2-support-large-blocksize-up-to-pagesize include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~ext2-support-large-blocksize-up-to-pagesize
+++ a/include/linux/ext2_fs.h
@@ -87,8 +87,8 @@ static inline struct ext2_sb_info *EXT2_
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
_

Patches currently in -mm which might be from sho@tnes.nec.co.jp are

ext3-support-large-blocksize-up-to-pagesize.patch
ext2-support-large-blocksize-up-to-pagesize.patch
