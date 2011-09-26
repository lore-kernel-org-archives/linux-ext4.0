From: Eric Gouriou <egouriou@google.com>
Subject: [PATCH 2/2] ext4: optimize memmmove lengths in extent/index insertions
Date: Sun, 25 Sep 2011 23:54:29 -0700
Message-ID: <1317020069-16355-2-git-send-email-egouriou@google.com>
References: <1317020069-16355-1-git-send-email-egouriou@google.com>
Cc: linux-ext4@vger.kernel.org, Eric Gouriou <egouriou@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1IZGyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 02:54:44 -0400
In-Reply-To: <1317020069-16355-1-git-send-email-egouriou@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_insert_extent() (respectively ext4_ext_insert_index())
was using EXT_MAX_EXTENT() (resp. EXT_MAX_INDEX()) to determine
how many entries needed to be moved beyond the insertion point.
In practice this means that (320 - I) * 24 bytes were memmove()'d
when I is the insertion point, rather than (#entries - I) * 24 bytes.

This patch uses EXT_LAST_EXTENT() (resp. EXT_LAST_INDEX()) instead
to only move existing entries. The code flow is also simplified
slightly to highlight similarities and reduce code duplication in
the insertion logic.

This patch reduces system CPU consumption by over 25% on a 4kB
synchronous append DIO write workload when used with the
pre-2.6.39 x86_64 memmove() implementation. With the much faster
2.6.39 memmove() implementation we still see a decrease in
system CPU usage between 2% and 7%.

Note that the ext_debug() output changes with this patch, splitting
some log information between entries. Users of the ext_debug() output
should note that the "move %d" units changed from reporting the number
of bytes moved to reporting the number of entries moved.

Signed-off-by: Eric Gouriou <egouriou@google.com>
---
 fs/ext4/extents.c |   85 ++++++++++++++++++++++++++---------------------------
 1 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0a7dd85..30dd641 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -751,31 +751,25 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		return -EIO;
 	}
 
-	len = EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
 	if (logical > le32_to_cpu(curp->p_idx->ei_block)) {
 		/* insert after */
-		if (curp->p_idx != EXT_LAST_INDEX(curp->p_hdr)) {
-			len = (len - 1) * sizeof(struct ext4_extent_idx);
-			len = len < 0 ? 0 : len;
-			ext_debug("insert new index %d after: %llu. "
-					"move %d from 0x%p to 0x%p\n",
-					logical, ptr, len,
-					(curp->p_idx + 1), (curp->p_idx + 2));
-			memmove(curp->p_idx + 2, curp->p_idx + 1, len);
-		}
+		ext_debug("insert new index %d after: %llu\n", logical, ptr);
 		ix = curp->p_idx + 1;
 	} else {
 		/* insert before */
-		len = len * sizeof(struct ext4_extent_idx);
-		len = len < 0 ? 0 : len;
-		ext_debug("insert new index %d before: %llu. "
-				"move %d from 0x%p to 0x%p\n",
-				logical, ptr, len,
-				curp->p_idx, (curp->p_idx + 1));
-		memmove(curp->p_idx + 1, curp->p_idx, len);
+		ext_debug("insert new index %d before: %llu\n", logical, ptr);
 		ix = curp->p_idx;
 	}
 
+	len = EXT_LAST_INDEX(curp->p_hdr) - ix + 1;
+	BUG_ON(len < 0);
+	if (len > 0) {
+		ext_debug("insert new index %d: "
+				"move %d indices from 0x%p to 0x%p\n",
+				logical, len, ix, ix + 1);
+		memmove(ix + 1, ix, len * sizeof(struct ext4_extent_idx));
+	}
+
 	ix->ei_block = cpu_to_le32(logical);
 	ext4_idx_store_pblock(ix, ptr);
 	le16_add_cpu(&curp->p_hdr->eh_entries, 1);
@@ -1778,41 +1772,46 @@ has_space:
 				ext4_ext_pblock(newext),
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext));
-		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
-	} else if (le32_to_cpu(newext->ee_block)
+		nearex = EXT_FIRST_EXTENT(eh);
+	} else {
+		if (le32_to_cpu(newext->ee_block)
 			   > le32_to_cpu(nearex->ee_block)) {
-/*		BUG_ON(newext->ee_block == nearex->ee_block); */
-		if (nearex != EXT_LAST_EXTENT(eh)) {
-			len = EXT_MAX_EXTENT(eh) - nearex;
-			len = (len - 1) * sizeof(struct ext4_extent);
-			len = len < 0 ? 0 : len;
-			ext_debug("insert %d:%llu:[%d]%d after: nearest 0x%p, "
-					"move %d from 0x%p to 0x%p\n",
+			/* Insert after */
+			ext_debug("insert %d:%llu:[%d]%d %s before: "
+					"nearest 0x%p\n"
+					le32_to_cpu(newext->ee_block),
+					ext4_ext_pblock(newext),
+					ext4_ext_is_uninitialized(newext),
+					ext4_ext_get_actual_len(newext),
+					nearex);
+			nearex++;
+		} else {
+			/* Insert before */
+			BUG_ON(newext->ee_block == nearex->ee_block);
+			ext_debug("insert %d:%llu:[%d]%d %s after: "
+					"nearest 0x%p\n"
 					le32_to_cpu(newext->ee_block),
 					ext4_ext_pblock(newext),
 					ext4_ext_is_uninitialized(newext),
 					ext4_ext_get_actual_len(newext),
-					nearex, len, nearex + 1, nearex + 2);
-			memmove(nearex + 2, nearex + 1, len);
+					nearex);
+		}
+		len = EXT_LAST_EXTENT(eh) - nearex + 1;
+		if (len > 0) {
+			ext_debug("insert %d:%llu:[%d]%d: "
+					"move %d extents from 0x%p to 0x%p\n",
+					le32_to_cpu(newext->ee_block),
+					ext4_ext_pblock(newext),
+					ext4_ext_is_uninitialized(newext),
+					ext4_ext_get_actual_len(newext),
+					len, nearex, nearex + 1);
+			memmove(nearex + 1, nearex,
+				len * sizeof(struct ext4_extent));
 		}
-		path[depth].p_ext = nearex + 1;
-	} else {
-		BUG_ON(newext->ee_block == nearex->ee_block);
-		len = (EXT_MAX_EXTENT(eh) - nearex) * sizeof(struct ext4_extent);
-		len = len < 0 ? 0 : len;
-		ext_debug("insert %d:%llu:[%d]%d before: nearest 0x%p, "
-				"move %d from 0x%p to 0x%p\n",
-				le32_to_cpu(newext->ee_block),
-				ext4_ext_pblock(newext),
-				ext4_ext_is_uninitialized(newext),
-				ext4_ext_get_actual_len(newext),
-				nearex, len, nearex, nearex + 1);
-		memmove(nearex + 1, nearex, len);
-		path[depth].p_ext = nearex;
 	}
 
 	le16_add_cpu(&eh->eh_entries, 1);
-	nearex = path[depth].p_ext;
+	path[depth].p_ext = nearex;
 	nearex->ee_block = newext->ee_block;
 	ext4_ext_store_pblock(nearex, ext4_ext_pblock(newext));
 	nearex->ee_len = newext->ee_len;
-- 
1.7.3.1

