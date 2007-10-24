From: akpm@linux-foundation.org
Subject: + ext2-fix-the-max-file-size-for-ext2-file-system.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:24:20 -0700
Message-ID: <200710242224.l9OMOKut015648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: fix the max file size for ext2 file system
has been added to the -mm tree.  Its filename is
     ext2-fix-the-max-file-size-for-ext2-file-system.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2: fix the max file size for ext2 file system
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

The max file size for ext2 file system is now calculated with hardcoded 4K
block size.  The patch fixes it to be calculated with the right block size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff -puN fs/ext2/super.c~ext2-fix-the-max-file-size-for-ext2-file-system fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-fix-the-max-file-size-for-ext2-file-system
+++ a/fs/ext2/super.c
@@ -680,11 +680,31 @@ static int ext2_check_descriptors (struc
 static loff_t ext2_max_size(int bits)
 {
 	loff_t res = EXT2_NDIR_BLOCKS;
-	/* This constant is calculated to be the largest file size for a
-	 * dense, 4k-blocksize file such that the total number of
+	int meta_blocks;
+	loff_t upper_limit;
+
+	/* This is calculated to be the largest file size for a
+	 * dense, file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
-	 * does not exceed 2^32. */
-	const loff_t upper_limit = 0x1ff7fffd000LL;
+	 * does not exceed 2^32 -1
+	 * __u32 i_blocks representing the total number of
+	 * 512 bytes blocks of the file
+	 */
+	upper_limit = (1LL << 32) - 1;
+
+	/* total blocks in file system block size */
+	upper_limit >>= (bits - 9);
+
+
+	/* indirect blocks */
+	meta_blocks = 1;
+	/* double indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2));
+	/* tripple indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
+
+	upper_limit -= meta_blocks;
+	upper_limit <<= bits;
 
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
@@ -692,6 +712,10 @@ static loff_t ext2_max_size(int bits)
 	res <<= bits;
 	if (res > upper_limit)
 		res = upper_limit;
+
+	if (res > MAX_LFS_FILESIZE)
+		res = MAX_LFS_FILESIZE;
+
 	return res;
 }
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-fix-the-max-file-size-for-ext2-file-system.patch
ext3-fix-the-max-file-size-for-ext3-file-system.patch
ext4-return-after-ext4_error-in-case-of-failures.patch
