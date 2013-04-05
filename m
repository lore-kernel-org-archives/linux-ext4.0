From: Todd Poynor <toddpoynor@google.com>
Subject: [PATCH RESEND] ext4: fixup 64-bit divides in 3.0-stable backport of upstream fix
Date: Fri,  5 Apr 2013 16:38:53 -0700
Message-ID: <1365205133-28456-1-git-send-email-toddpoynor@google.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>, linux-ext4@vger.kernel.org,
	Todd Poynor <toddpoynor@google.com>
To: <tytso@mit.edu>, stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replace C division operators with div64_u64 for divides introduced in:
commit 503f4bdcc078e7abee273a85ce322de81b18a224
ext4: use atomic64_t for the per-flexbg free_clusters count

Specific to the 3.0-stable backport of the upstream patch.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
Re-send with linux-ext4 list cc'ed

3.0-stable backport has additional changes, including converting
blocks_per_flex and flexbg_free_blocks from int to ext4_fsblk_t (a
64-bit type), probably as a part of these additional changes mentioned
in the commit message:

   [Backported for 3.0-stable. Renamed free_clusters back to free_blocks;
    fixed a few more atomic_read's of free_blocks left in 3.0.]

Perhaps the better fix is to revert those additional changes and let
the ext4 folks figure out what to do about the remaining atomic_reads.


 fs/ext4/ialloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index dd732c7..443ffb8 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -22,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
+#include <linux/math64.h>
 #include <asm/byteorder.h>
 
 #include "ext4.h"
@@ -356,7 +357,7 @@ static int find_group_flex(struct super_block *sb, struct inode *parent,
 
 find_close_to_parent:
 	flexbg_free_blocks = atomic64_read(&flex_group[best_flex].free_blocks);
-	flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
+	flex_freeb_ratio = div64_u64(flexbg_free_blocks * 100, blocks_per_flex);
 	if (atomic_read(&flex_group[best_flex].free_inodes) &&
 	    flex_freeb_ratio > free_block_ratio)
 		goto found_flexbg;
@@ -371,7 +372,7 @@ find_close_to_parent:
 			continue;
 
 		flexbg_free_blocks = atomic64_read(&flex_group[i].free_blocks);
-		flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
+		flex_freeb_ratio = div64_u64(flexbg_free_blocks * 100, blocks_per_flex);
 
 		if (flex_freeb_ratio > free_block_ratio &&
 		    (atomic_read(&flex_group[i].free_inodes))) {
-- 
1.8.1.3
