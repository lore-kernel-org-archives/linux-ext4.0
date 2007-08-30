From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC 1/4] Large Blocksize support for Ext2/3/4
Date: Wed, 29 Aug 2007 17:47:37 -0700
Message-ID: <1188434857.3799.76.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: clameter@sgi.com, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1188432669.3799.35.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The next 4 patches support large block size (up to PAGESIZE, max 64KB)
for ext2/3/4, originally from Takashi Sato.
http://marc.info/?l=linux-ext4&m=115768873518400&w=2


It's quite simple to support large block size in ext2/3/4, mostly just
enlarge the block size limit.  But it is NOT possible to have 64kB
blocksize on ext2/3/4 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is to put 2 empty records in such
a directory, or to special-case an impossible value like rec_len =
0xffff to handle this. 


The Patch-set consists of the following 4 patches.
  [1/4]  ext2/3/4: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/4]  ext2: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

  [3/4]  ext3: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

  [4/4]  ext4: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Just rebase to 2.6.23-rc4 and against the ext4 patch queue. Compile tested only. 

Next steps:
Need a e2fsprogs changes to able test this feature. As mkfs needs to be
educated not assuming rec_len to be blocksize all the time.
Will try it with Christoph Lameter's large block patch next.


Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
---
 fs/ext2/super.c         |    2 +-
 fs/ext3/super.c         |    5 ++++-
 fs/ext4/super.c         |    5 +++++
 include/linux/ext2_fs.h |    4 ++--
 include/linux/ext3_fs.h |    4 ++--
 include/linux/ext4_fs.h |    4 ++--
 6 files changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6.23-rc3/fs/ext2/super.c
===================================================================
--- linux-2.6.23-rc3.orig/fs/ext2/super.c	2007-08-12 21:25:24.000000000 -0700
+++ linux-2.6.23-rc3/fs/ext2/super.c	2007-08-29 15:22:29.000000000 -0700
@@ -775,7 +775,7 @@ static int ext2_fill_super(struct super_
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
+			printk(KERN_ERR "EXT2-fs: bad blocksize %d.\n", blocksize);
 			goto failed_sbi;
 		}
 
Index: linux-2.6.23-rc3/fs/ext3/super.c
===================================================================
--- linux-2.6.23-rc3.orig/fs/ext3/super.c	2007-08-12 21:25:24.000000000 -0700
+++ linux-2.6.23-rc3/fs/ext3/super.c	2007-08-29 15:22:29.000000000 -0700
@@ -1549,7 +1549,10 @@ static int ext3_fill_super (struct super
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT3-fs: bad blocksize %d.\n", blocksize);
+			goto out_fail;
+		}
 		logic_sb_block = (sb_block * EXT3_MIN_BLOCK_SIZE) / blocksize;
 		offset = (sb_block * EXT3_MIN_BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
Index: linux-2.6.23-rc3/fs/ext4/super.c
===================================================================
--- linux-2.6.23-rc3.orig/fs/ext4/super.c	2007-08-28 11:09:40.000000000 -0700
+++ linux-2.6.23-rc3/fs/ext4/super.c	2007-08-29 15:24:08.000000000 -0700
@@ -1626,6 +1626,11 @@ static int ext4_fill_super (struct super
 		goto out_fail;
 	}
 
+	if (!sb_set_blocksize(sb, blocksize)) {
+		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
+		goto out_fail;
+	}
+
 	/*
 	 * The ext4 superblock will not be buffer aligned for other than 1kB
 	 * block sizes.  We need to calculate the offset from buffer start.
Index: linux-2.6.23-rc3/include/linux/ext2_fs.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/ext2_fs.h	2007-08-12 21:25:24.000000000 -0700
+++ linux-2.6.23-rc3/include/linux/ext2_fs.h	2007-08-29 15:22:29.000000000 -0700
@@ -86,8 +86,8 @@ static inline struct ext2_sb_info *EXT2_
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
Index: linux-2.6.23-rc3/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/ext3_fs.h	2007-08-12 21:25:24.000000000 -0700
+++ linux-2.6.23-rc3/include/linux/ext3_fs.h	2007-08-29 15:22:29.000000000 -0700
@@ -76,8 +76,8 @@
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
Index: linux-2.6.23-rc3/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/ext4_fs.h	2007-08-28 11:09:40.000000000 -0700
+++ linux-2.6.23-rc3/include/linux/ext4_fs.h	2007-08-29 15:22:29.000000000 -0700
@@ -104,8 +104,8 @@ struct ext4_allocation_request {
  * Macro-instructions used to manage several block sizes
  */
 #define EXT4_MIN_BLOCK_SIZE		1024
-#define	EXT4_MAX_BLOCK_SIZE		4096
-#define EXT4_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT4_MAX_BLOCK_SIZE		65536
+#define EXT4_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else


