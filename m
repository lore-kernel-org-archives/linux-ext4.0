From: Adrian Bunk <bunk@kernel.org>
Subject: [-mm patch] remove fs/ext2/balloc.c:reserve_blocks()
Date: Tue, 14 Aug 2007 23:25:56 +0200
Message-ID: <20070814212556.GV18945@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	Valerie Henson <val_henson@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758108AbXHNV0M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Aug 2007 17:26:12 -0400
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

reserve_blocks() is no longer used.

Spotted by the GNU C compiler.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ext2/balloc.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

4b64502ecee91af41888261d7392688c9283792f 
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 1c57a3f..b63f6a4 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -133,41 +133,6 @@ error_out:
 	return NULL;
 }
 
-/*
- * Set sb->s_dirt here because the superblock was "logically" altered.  We
- * need to recalculate its free blocks count and flush it out.
- */
-static int reserve_blocks(struct super_block *sb, int count)
-{
-	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	struct ext2_super_block *es = sbi->s_es;
-	unsigned free_blocks;
-	unsigned root_blocks;
-
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-	root_blocks = le32_to_cpu(es->s_r_blocks_count);
-
-	if (free_blocks < count)
-		count = free_blocks;
-
-	if (free_blocks < root_blocks + count && !capable(CAP_SYS_RESOURCE) &&
-	    sbi->s_resuid != current->fsuid &&
-	    (sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
-		/*
-		 * We are too close to reserve and we are not privileged.
-		 * Can we allocate anything at all?
-		 */
-		if (free_blocks > root_blocks)
-			count = free_blocks - root_blocks;
-		else
-			return 0;
-	}
-
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -count);
-	sb->s_dirt = 1;
-	return count;
-}
-
 static void release_blocks(struct super_block *sb, int count)
 {
 	if (count) {
