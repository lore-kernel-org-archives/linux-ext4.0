From: Eric Sandeen <sandeen@redhat.com>
Subject: [RFC][PATCH] ensure do_split leaves enough free space in both blocks
Date: Sat, 15 Sep 2007 22:46:36 -0500
Message-ID: <46ECA71C.9020100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: hooanon05@yahoo.co.jp
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXIPDql (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Sep 2007 23:46:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For me, this fixes the problem reported by 
hooanon05@yahoo.co.jp, "ext3 dir_index causes an error"

The issue is that the do_split() function sorts the entries in the old 
block by hash value, then moves half the entries to the new block 
without accounting for how much space this actually moves.  (IOW,
it moves half of the entry *count* not half of the entry *space*)

The patch below stores size as well when calculating the dx_map,
and then walks the hash-sorted dx_map, calculating how
many entries must be moved to more evenly split the existing
entries between the old block and the new block, guaranteeing
enough space for the new entry.

Enhancements that could be made, though I'm not sure it's worth it:
* pack the old dir block before calculating nr of entries to move,

-or-

* calculate the minimum rec_len when generating the map, vs.
  just storing the current rec_len.

I'm not sure it's worth the extra calculations, I think this code
below works just fine from a correctness perspective.

How's this look, any comments?

Thanks,

-Eric

Index: linux/fs/ext3/namei.c
===================================================================
--- linux.orig/fs/ext3/namei.c
+++ linux/fs/ext3/namei.c
@@ -141,6 +141,7 @@ struct dx_map_entry
 {
 	u32 hash;
 	u32 offs;
+	u32 size;
 };
 
 #ifdef CONFIG_EXT3_INDEX
@@ -685,6 +687,7 @@ static int dx_make_map (struct ext3_dir_
 			map_tail--;
 			map_tail->hash = h.hash;
 			map_tail->offs = (u32) ((char *) de - base);
+			map_tail->size = le16_to_cpu(de->rec_len);
 			count++;
 			cond_resched();
 		}
@@ -1142,7 +1159,7 @@ static struct ext3_dir_entry_2 *do_split
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split;
+	unsigned split, move, size, i;
 	struct ext3_dir_entry_2 *de = NULL, *de2;
 	int	err = 0;
 
@@ -1170,8 +1187,19 @@ static struct ext3_dir_entry_2 *do_split
 	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
 			     blocksize, hinfo, map);
 	map -= count;
-	split = count/2; // need to adjust to actual middle
 	dx_sort_map (map, count);
+	/* Split the existing block in the middle, size-wise */
+	size = 0;
+	move = 0;
+	for (i = count-1; i >= 0; i--) {
+		/* is more than half of this entry in last half of the block? */
+		if (size + map[i].size/2 > blocksize/2)
+			break;
+		size += map[i].size;
+		move++;
+	}
+	/* map index at which we will split */
+	split = count - move;
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
 	dxtrace(printk("Split block %i at %x, %i/%i\n",
