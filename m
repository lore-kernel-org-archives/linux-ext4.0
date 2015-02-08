From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3] ext4: fix indirect punch hole corruption
Date: Sun,  8 Feb 2015 04:15:49 -0800
Message-ID: <2f10494037d06107efa0e545c814b5a8b4a3710c.1423397569.git.osandov@osandov.com>
References: <c1b3048d1afd6d30946bd036292ec3e94f7f8cea.1423345772.git.osandov@osandov.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Omar Sandoval <osandov@osandov.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
	Chris J Arges <chris.j.arges@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c1b3048d1afd6d30946bd036292ec3e94f7f8cea.1423345772.git.osandov@osandov.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
mapping. However, there are a bugs in a few cases.

In the case where the punch happens within one level of indirection, we
expect the start and end shared branches to converge on an indirect
block. However, because the branches returned from ext4_find_shared do
not necessarily start at the same level (e.g., the partial2 chain will
be shallower if the last block occurs at the beginning of an indirect
group), the walk of the two chains can end up "missing" each other and
freeing a bunch of extra blocks in the process. This mismatch can be
handled by first making sure that the chains are at the same level, then
walking them together until they converge.

In the case that a punch spans different levels of indirection, the
original code skips freeing the intermediate indirect trees if the last
block is the first triply-indirected block because it returns instead of
jumping to do_indirects. Additionally, a non-zero nr2 does not mean that
there's nothing else to free at the level of partial2: consider the case
where the all_zeroes in ext4_find_shared backed up the shared branch.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Here's a couple more fixes folded in. Still applies to v3.19-rc7.

Changes from v2:
Handle skipped do_indirects when n < 4, n2 == 4, and partial2 == chain2
and skipped ext4_free_branches when nr2 != 0

Changes from v1:
Handle partial == chain || partial2 == chain2 cases.
 fs/ext4/indirect.c | 62 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 36b3696..279d9ba 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1393,10 +1393,7 @@ end_range:
 				 * to free. Everything was covered by the start
 				 * of the range.
 				 */
-				return 0;
-			} else {
-				/* Shared branch grows from an indirect block */
-				partial2--;
+				goto do_indirects;
 			}
 		} else {
 			/*
@@ -1434,49 +1431,54 @@ end_range:
 	 * in punch_hole so we need to point to the next element
 	 */
 	partial2->p++;
-	while ((partial > chain) || (partial2 > chain2)) {
-		/* We're at the same block, so we're almost finished */
-		if ((partial->bh && partial2->bh) &&
-		    (partial->bh->b_blocknr == partial2->bh->b_blocknr)) {
-			if ((partial > chain) && (partial2 > chain2)) {
-				ext4_free_branches(handle, inode, partial->bh,
-						   partial->p + 1,
-						   partial2->p,
-						   (chain+n-1) - partial);
-				BUFFER_TRACE(partial->bh, "call brelse");
-				brelse(partial->bh);
-				BUFFER_TRACE(partial2->bh, "call brelse");
-				brelse(partial2->bh);
-			}
+	while (partial > chain || partial2 > chain2) {
+		int depth = (chain+n-1) - partial;
+		int depth2 = (chain2+n2-1) - partial2;
+
+		if (partial > chain && partial2 > chain2 &&
+		    partial->bh->b_blocknr == partial2->bh->b_blocknr) {
+			/*
+			 * We've converged on the same block. Clear the range,
+			 * then we're done.
+			 */
+			ext4_free_branches(handle, inode, partial->bh,
+					   partial->p + 1,
+					   partial2->p,
+					   (chain+n-1) - partial);
+			BUFFER_TRACE(partial->bh, "call brelse");
+			brelse(partial->bh);
+			BUFFER_TRACE(partial2->bh, "call brelse");
+			brelse(partial2->bh);
 			return 0;
 		}
+
 		/*
-		 * Clear the ends of indirect blocks on the shared branch
-		 * at the start of the range
+		 * The start and end partial branches may not be at the same
+		 * level even though the punch happened within one level. So, we
+		 * give them a chance to arrive at the same level, then walk
+		 * them in step with each other until we converge on the same
+		 * block.
 		 */
-		if (partial > chain) {
+		if (partial > chain && depth <= depth2) {
 			ext4_free_branches(handle, inode, partial->bh,
-				   partial->p + 1,
-				   (__le32 *)partial->bh->b_data+addr_per_block,
-				   (chain+n-1) - partial);
+					   partial->p + 1,
+					   (__le32 *)partial->bh->b_data+addr_per_block,
+					   (chain+n-1) - partial);
 			BUFFER_TRACE(partial->bh, "call brelse");
 			brelse(partial->bh);
 			partial--;
 		}
-		/*
-		 * Clear the ends of indirect blocks on the shared branch
-		 * at the end of the range
-		 */
-		if (partial2 > chain2) {
+		if (partial2 > chain2 && depth2 <= depth) {
 			ext4_free_branches(handle, inode, partial2->bh,
 					   (__le32 *)partial2->bh->b_data,
 					   partial2->p,
-					   (chain2+n-1) - partial2);
+					   (chain2+n2-1) - partial2);
 			BUFFER_TRACE(partial2->bh, "call brelse");
 			brelse(partial2->bh);
 			partial2--;
 		}
 	}
+	return 0;
 
 do_indirects:
 	/* Kill the remaining (whole) subtrees */
-- 
2.3.0
