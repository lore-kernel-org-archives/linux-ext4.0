From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix ext2fs_extent_get for uninit leaf extents
Date: Wed, 19 Mar 2008 15:20:18 -0500
Message-ID: <47E17582.2030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbYCSUVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 16:21:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix ext2fs_extent_get for uninit leaf extents

From: Eric Sandeen <sandeen@redhat.com>

The ext2fs_extent_get() function was not OR-ing together UNINIT
and LEAF flags in the case where an extent was both; so if we 
had an extent which was both uniint and leaf, pass1 would bail
out where depth == max_depth but was not marked as leaf, and
e2fsck (from the next branch) would abort with:

e2fsck 1.40.8 (13-Mar-2008)
Pass 1: Checking inodes, blocks, and sizes
Error1: No 'down' extent
Aborted

Also, if the error is encountered again, print the inode number
to aid debugging until it's properly handled, at least.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index ab211b1..c616984 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -463,10 +463,10 @@ retry:
 			((__u64) ext2fs_le16_to_cpu(ex->ee_start_hi) << 32);
 		extent->e_lblk = ext2fs_le32_to_cpu(ex->ee_block);
 		extent->e_len = ext2fs_le16_to_cpu(ex->ee_len);
-		extent->e_flags = EXT2_EXTENT_FLAGS_LEAF;
+		extent->e_flags |= EXT2_EXTENT_FLAGS_LEAF;
 		if (extent->e_len > EXT_INIT_MAX_LEN) {
 			extent->e_len -= EXT_INIT_MAX_LEN;
-			extent->e_flags = EXT2_EXTENT_FLAGS_UNINIT;
+			extent->e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
 		}
 	} else {
 		extent->e_pblk = ext2fs_le32_to_cpu(ix->ei_leaf) +

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 50e38e1..79e9f23 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1622,14 +1622,16 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
-				printf("Error1: %s\n", error_message(pctx->errcode));
+				printf("Error1: %s on inode %lld\n",
+					error_message(pctx->errcode), pctx->ino);
 				abort();
 			}
 			scan_extent_node(ctx, pctx, pb, ehandle);
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_UP, &extent);
 			if (pctx->errcode) {
-				printf("Error1: %s\n", error_message(pctx->errcode));
+				printf("Error1: %s on inode %lld\n",
+					error_message(pctx->errcode), pctx->ino);
 				abort();
 			}
 			goto next;

