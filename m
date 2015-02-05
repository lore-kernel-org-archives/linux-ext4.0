From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] ext4: fix indirect punch hole corruption
Date: Thu,  5 Feb 2015 12:50:13 -0800
Message-ID: <cf81509853ecdbef7d738d8d39abe786f41193ec.1423169101.git.osandov@osandov.com>
Cc: Chris J Arges <chris.j.arges@canonical.com>,
	Omar Sandoval <osandov@osandov.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40436 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbbBEUuq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2015 15:50:46 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so12307452pab.5
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2015 12:50:46 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
mapping. However, the case where the punch happens within one level of
indirection is incorrect. It assumes that the partial branches returned
from ext4_find_shared will have the same depth, but this is not
necessarily the case even when the offsets have the same depth. For
example, if the last block occurs at the beginning of an indirect group
(i.e., it has an offset of 0 at the end of the offsets array), then
ext4_find_shared will return a shallower chain. So, let's handle the
mismatch and clean up that case. Tested with generic/270, which no
longer leads to an inconsistent filesystem like before.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/ext4/indirect.c | 61 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 36b3696..e04bbce 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1434,50 +1434,59 @@ end_range:
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
+	while (partial > chain && partial2 > chain2) {
+		int depth = (chain+n-1) - partial;
+		int depth2 = (chain2+n2-1) - partial2;
+
+		if (partial->bh->b_blocknr == partial2->bh->b_blocknr) {
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
+		if (depth <= depth2) {
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
+		if (depth2 <= depth) {
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
 
+	/*
+	 * The punch happened within the same level, so at some point we _must_
+	 * converge on an indirect block.
+	 */
+	BUG_ON(1);
+
 do_indirects:
 	/* Kill the remaining (whole) subtrees */
 	switch (offsets[0]) {
-- 
2.2.2

