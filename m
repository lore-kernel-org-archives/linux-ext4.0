From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2] ext4: fix indirect punch hole corruption
Date: Sat,  7 Feb 2015 13:57:01 -0800
Message-ID: <c1b3048d1afd6d30946bd036292ec3e94f7f8cea.1423345772.git.osandov@osandov.com>
References: <54D55DEE.6020509@canonical.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Omar Sandoval <osandov@osandov.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
	Chris J Arges <chris.j.arges@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D55DEE.6020509@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
mapping. However, the case where the punch happens within one level of
indirection is incorrect. It assumes that the partial branches returned
from ext4_find_shared will have the same depth, but this is not
necessarily the case even when the offsets have the same depth. For
example, if the last block occurs at the beginning of an indirect group
(i.e., it has an offset of 0 at the end of the offsets array), then
ext4_find_shared will return a shallower chain. So, let's handle the
mismatch and clean up that case.

This should reflect the original intent of the code. However, I'm still
seeing failures of generic/270 due to an inconsistent filesystem after
many runs, so there could be another bug here, or it could be unrelated.
I'll keep working on tracking that down.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Once again, this applies to v3.19-rc7. Chris, could you take this one
for a spin when you get the chance? Hopefully you'll be able to confirm
whether the corruption is still here or unrelated.

Changes from v1:
Handle partial == chain || partial2 == chain2 cases.

 fs/ext4/indirect.c | 57 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 36b3696..3ff325f 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1434,49 +1434,54 @@ end_range:
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
