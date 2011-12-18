From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 06/10] e2fsck: fix pass5 bug when using two different bitmap backends
Date: Sun, 18 Dec 2011 01:42:34 -0500
Message-ID: <1324190558-7436-7-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50566 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The pass5 checks would fail if the expected and current {inode,block}
bitmaps used different back ends that returned different non-zero
values from the test_*_bitmap() functions.  Fix this by changing
"(actual == bitmap)" to "(!actual == !bitmap)".

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index a60e84a..1e836e3 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -279,7 +279,7 @@ redo_counts:
 		else
 			bitmap = ext2fs_fast_test_block_bitmap2(fs->block_map, i);
 
-		if (actual == bitmap)
+		if (!actual == !bitmap)
 			goto do_counts;
 
 		if (!actual && bitmap) {
@@ -511,7 +511,7 @@ redo_counts:
 			bitmap = actual;
 		else if (!skip_group)
 			bitmap = ext2fs_fast_test_inode_bitmap2(fs->inode_map, i);
-		if (actual == bitmap)
+		if (!actual == !bitmap)
 			goto do_counts;
 
 		if (!actual && bitmap) {
-- 
1.7.8.11.gefc1f.dirty

