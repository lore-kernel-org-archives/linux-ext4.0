From: akpm@linux-foundation.org
Subject: - ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:39:07 -0800
Message-ID: <200712202339.lBKNd7Hj019105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: check for the correct error return from ext4_ext_get_blocks
has been removed from the -mm tree.  Its filename was
     ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: check for the correct error return from ext4_ext_get_blocks
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

ext4_ext_get_blocks returns negative values on error. We should
check for  <= 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/extents.c~ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks
+++ a/fs/ext4/extents.c
@@ -2628,8 +2628,8 @@ retry:
 		ret = ext4_ext_get_blocks(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
-		WARN_ON(!ret);
-		if (!ret) {
+		WARN_ON(ret <= 0);
+		if (ret <= 0) {
 			ext4_error(inode->i_sb, "ext4_fallocate",
 				   "ext4_ext_get_blocks returned 0! inode#%lu"
 				   ", block=%lu, max_blocks=%lu",
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
add-buffer-head-related-helper-functions.patch
ext2-add-block-bitmap-validation.patch
ext3-add-block-bitmap-validation.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
