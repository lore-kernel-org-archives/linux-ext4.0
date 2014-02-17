From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: silence warnings in extent status tree debugging code
Date: Sun, 16 Feb 2014 21:30:41 -0500
Message-ID: <20140217023041.GA1831@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:32850 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaBQCaq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Feb 2014 21:30:46 -0500
Received: by mail-qc0-f180.google.com with SMTP id i17so23046992qcy.39
        for <linux-ext4@vger.kernel.org>; Sun, 16 Feb 2014 18:30:45 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adjust the conversion specifications in a few optionally compiled debug
messages to match the return type of ext4_es_status().  Also, make a
couple of minor grammatical message edits while we're at it.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents_status.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 3981ff7..b6897d4 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -184,7 +184,7 @@ static void ext4_es_print_tree(struct inode *inode)
 	while (node) {
 		struct extent_status *es;
 		es = rb_entry(node, struct extent_status, rb_node);
-		printk(KERN_DEBUG " [%u/%u) %llu %llx",
+		printk(KERN_DEBUG " [%u/%u) %llu %x",
 		       es->es_lblk, es->es_len,
 		       ext4_es_pblock(es), ext4_es_status(es));
 		node = rb_next(node);
@@ -445,8 +445,8 @@ static void ext4_es_insert_extent_ext_check(struct inode *inode,
 				pr_warn("ES insert assertion failed for "
 					"inode: %lu we can find an extent "
 					"at block [%d/%d/%llu/%c], but we "
-					"want to add an delayed/hole extent "
-					"[%d/%d/%llu/%llx]\n",
+					"want to add a delayed/hole extent "
+					"[%d/%d/%llu/%x]\n",
 					inode->i_ino, ee_block, ee_len,
 					ee_start, ee_status ? 'u' : 'w',
 					es->es_lblk, es->es_len,
@@ -486,8 +486,8 @@ static void ext4_es_insert_extent_ext_check(struct inode *inode,
 		if (!ext4_es_is_delayed(es) && !ext4_es_is_hole(es)) {
 			pr_warn("ES insert assertion failed for inode: %lu "
 				"can't find an extent at block %d but we want "
-				"to add an written/unwritten extent "
-				"[%d/%d/%llu/%llx]\n", inode->i_ino,
+				"to add a written/unwritten extent "
+				"[%d/%d/%llu/%x]\n", inode->i_ino,
 				es->es_lblk, es->es_lblk, es->es_len,
 				ext4_es_pblock(es), ext4_es_status(es));
 		}
@@ -524,7 +524,7 @@ static void ext4_es_insert_extent_ind_check(struct inode *inode,
 			 */
 			pr_warn("ES insert assertion failed for inode: %lu "
 				"We can find blocks but we want to add a "
-				"delayed/hole extent [%d/%d/%llu/%llx]\n",
+				"delayed/hole extent [%d/%d/%llu/%x]\n",
 				inode->i_ino, es->es_lblk, es->es_len,
 				ext4_es_pblock(es), ext4_es_status(es));
 			return;
@@ -554,7 +554,7 @@ static void ext4_es_insert_extent_ind_check(struct inode *inode,
 		if (ext4_es_is_written(es)) {
 			pr_warn("ES insert assertion failed for inode: %lu "
 				"We can't find the block but we want to add "
-				"an written extent [%d/%d/%llu/%llx]\n",
+				"a written extent [%d/%d/%llu/%x]\n",
 				inode->i_ino, es->es_lblk, es->es_len,
 				ext4_es_pblock(es), ext4_es_status(es));
 			return;
-- 
1.8.3.2

