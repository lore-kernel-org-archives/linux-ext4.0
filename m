From: akpm@linux-foundation.org
Subject: + ext3-support-large-blocksize-up-to-pagesize.patch added to -mm tree
Date: Thu, 04 Oct 2007 13:13:24 -0700
Message-ID: <200710042013.l94KDPkK026725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: sho@tnes.nec.co.jp, clameter@sgi.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: support large blocksize up to PAGESIZE
has been added to the -mm tree.  Its filename is
     ext3-support-large-blocksize-up-to-pagesize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: support large blocksize up to PAGESIZE
From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext3 just enlarging
the block size limit.  But it is NOT possible to have 64kB blocksize on
ext3 without some changes to the directory handling code.  The reason is
that an empty 64kB directory block would have a rec_len == (__u16)2^16 ==
0, and this would cause an error to be hit in the filesystem.  The proposed
solution is treat 64k rec_len with a an impossible value like rec_len =
0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext3: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext3: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext3, and able to handle empty directory block.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ext3/super.c~ext3-support-large-blocksize-up-to-pagesize fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-support-large-blocksize-up-to-pagesize
+++ a/fs/ext3/super.c
@@ -1620,7 +1620,11 @@ static int ext3_fill_super (struct super
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT3-fs: bad blocksize %d.\n",
+				blocksize);
+			goto out_fail;
+		}
 		logic_sb_block = (sb_block * EXT3_MIN_BLOCK_SIZE) / blocksize;
 		offset = (sb_block * EXT3_MIN_BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
diff -puN include/linux/ext3_fs.h~ext3-support-large-blocksize-up-to-pagesize include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-support-large-blocksize-up-to-pagesize
+++ a/include/linux/ext3_fs.h
@@ -72,8 +72,8 @@
  * Macro-instructions used to manage several block sizes
  */
 #define EXT3_MIN_BLOCK_SIZE		1024
-#define	EXT3_MAX_BLOCK_SIZE		4096
-#define EXT3_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT3_MAX_BLOCK_SIZE		65536
+#define EXT3_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT3_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
_

Patches currently in -mm which might be from sho@tnes.nec.co.jp are

ext3-support-large-blocksize-up-to-pagesize.patch
ext2-support-large-blocksize-up-to-pagesize.patch
