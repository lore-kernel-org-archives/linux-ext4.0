From: akpm@linux-foundation.org
Subject: + ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch added to -mm tree
Date: Tue, 15 Apr 2008 01:18:46 -0700
Message-ID: <200804150818.m3F8Ik9s018764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: retry block allocation if new blocks are allocated from system zone.
has been added to the -mm tree.  Its filename is
     ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: retry block allocation if new blocks are allocated from system zone.
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

If the block allocator gets blocks out of system zone ext3 calls ext3_error. 
But if the file system is mounted with errors=continue retry block allocation.
 We need to mark the system zone blocks as in use to make sure retry don't
pick them again

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone
+++ a/fs/ext3/balloc.c
@@ -164,10 +164,11 @@ read_block_bitmap(struct super_block *sb
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (!ext3_valid_block_bitmap(sb, desc, block_group, bh)) {
-		brelse(bh);
-		return NULL;
-	}
+	ext3_valid_block_bitmap(sb, desc, block_group, bh);
+	/*
+	 * file system mounted not to panic on error,
+	 * continue with corrput bitmap
+	 */
 	return bh;
 }
 /*
@@ -1641,7 +1642,12 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
-		goto out;
+		/*
+		 * claim_block marked the blocks we allocated
+		 * as in use. So we may want to selectively
+		 * mark some of the blocks as free
+		 */
+		goto retry_alloc;
 	}
 
 	performed_allocation = 1;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch

