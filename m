From: Andreas Schultz <aschultz@warp10.net>
Subject: [RFC][PATCH] "tune2fs -I 256" speedup
Date: Sat, 29 Nov 2008 11:54:19 +0100
Message-ID: <1227956059.25439.16.camel@ws-aschultz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-I4mUIaK842GH7vSEJJvB"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tpip.net ([213.187.84.201]:44197 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYK2Ky2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Nov 2008 05:54:28 -0500
Received: from localhost (office-old.tpip.net [213.187.84.201])
	by mail.tpip.net (Postfix) with ESMTP id 2BCC1FF313
	for <linux-ext4@vger.kernel.org>; Sat, 29 Nov 2008 11:54:25 +0100 (CET)
Received: from mail.tpip.net ([213.187.84.201])
	by localhost (office.tpip.net [213.187.84.201]) (amavisd-new, port 10024)
	with ESMTP id JA18xpycf3ST for <linux-ext4@vger.kernel.org>;
	Sat, 29 Nov 2008 11:54:21 +0100 (CET)
Received: from [192.168.2.24] (port-87-193-170-219.static.qsc.de [87.193.170.219])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.tpip.net (Postfix) with ESMTP id 494E462FA8
	for <linux-ext4@vger.kernel.org>; Sat, 29 Nov 2008 11:54:21 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-I4mUIaK842GH7vSEJJvB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

After some on and off list discussion about the 'tune2fs -I'
performance, Theodore Tso pointed out that the blk_move_list used by
transalate_block() was less then optimal.

This is my attempt at fixing that.

Have fun
Andreas

--=-I4mUIaK842GH7vSEJJvB
Content-Disposition: attachment; filename="tune2fs_replace_list_with_array.patch"
Content-Type: text/x-patch; name="tune2fs_replace_list_with_array.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

replace list search with binary in transalate_block

Signed-off-by: Andreas Schultz <aschultz@warp10.net>
---

 misc/tune2fs.c |   61 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e72518a..9c58f87 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -84,14 +84,14 @@ static unsigned long new_inode_size;
 int journal_size, journal_flags;
 char *journal_device;
 
-static struct list_head blk_move_list;
-
 struct blk_move {
-	struct list_head list;
 	blk_t old_loc;
 	blk_t new_loc;
 };
 
+#define BLK_MOVE_BLK	(1024 * 512)				/* grow blk_move_list this many entries */
+static blk_t blk_move_cnt = 0;
+static struct blk_move *blk_move_list = NULL;
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 
@@ -1006,7 +1006,6 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	blk_t blk, new_blk;
 	struct blk_move *bmv;
 
-
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
 		return retval;
@@ -1024,15 +1023,17 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 		/* Mark this block as allocated */
 		ext2fs_mark_block_bitmap(fs->block_map, new_blk);
 
-		/* Add it to block move list */
-		retval = ext2fs_get_mem(sizeof(struct blk_move), &bmv);
-		if (retval)
-			goto err_out;
-
-		bmv->old_loc = blk;
-		bmv->new_loc = new_blk;
+		if (blk_move_cnt % BLK_MOVE_BLK == 0) {
+			retval = ext2fs_resize_mem(sizeof(struct blk_move) * blk_move_cnt,
+						   sizeof(struct blk_move) * (blk_move_cnt + BLK_MOVE_BLK),
+						   &blk_move_list);
+			if (retval)
+				goto err_out;
+		}
 
-		list_add(&(bmv->list), &blk_move_list);
+		blk_move_list[blk_move_cnt].old_loc = blk;
+		blk_move_list[blk_move_cnt].new_loc = new_blk;
+		blk_move_cnt++;
 
 		retval = io_channel_read_blk(fs->io, blk, 1, buf);
 		if (retval)
@@ -1048,17 +1049,29 @@ err_out:
 	return retval;
 }
 
+static int comp_blk(const void *a, const void *b)
+{
+	struct blk_move *blk_a = (struct blk_move *) a;
+	struct blk_move *blk_b = (struct blk_move *) b;
+
+	if (blk_a->old_loc < blk_b->old_loc)
+		return -1;
+	else if (blk_a->old_loc > blk_b->old_loc)
+		return 1;
+	return 0;
+}
+
 static blk_t transalate_block(blk_t blk)
 {
-	struct list_head *entry;
+	struct blk_move key;
 	struct blk_move *bmv;
 
-	list_for_each(entry, &blk_move_list) {
+	key.old_loc = blk;
+	bmv = bsearch(&key, blk_move_list, blk_move_cnt,
+		      sizeof(struct blk_move), comp_blk);
 
-		bmv = list_entry(entry, struct blk_move, list);
-		if (bmv->old_loc == blk)
-			return bmv->new_loc;
-	}
+	if (bmv)
+		return bmv->new_loc;
 
 	return 0;
 }
@@ -1297,15 +1310,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 
 static void free_blk_move_list(void)
 {
-	struct list_head *entry, *tmp;
-	struct blk_move *bmv;
-
-	list_for_each_safe(entry, tmp, &blk_move_list) {
-
-		bmv = list_entry(entry, struct blk_move, list);
-		list_del(entry);
-		ext2fs_free_mem(&bmv);
-	}
+	ext2fs_free_mem(&blk_move_list);
 
 	return ;
 }
@@ -1318,8 +1323,6 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 
 	ext2fs_read_inode_bitmap(fs);
 	ext2fs_read_block_bitmap(fs);
-	INIT_LIST_HEAD(&blk_move_list);
--=-I4mUIaK842GH7vSEJJvB--
