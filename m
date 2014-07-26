From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/6] resize2fs: radically reduce memory utilization by using rbtree bitmaps
Date: Sat, 26 Jul 2014 09:48:31 -0400
Message-ID: <1406382514-8662-4-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58035 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaGZNsh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:37 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When resizing an empty 21T file system to 28T, resize2fs was using
this much CPU time and memory:

216.98user 19.77system 4:02.92elapsed 97%CPU (0avgtext+0avgdata 4485664maxresident)k
8inputs+1068680outputs (0major+800745minor)pagefaults 0swaps

After this one-line change:

222.29user 0.49system 3:48.79elapsed 97%CPU (0avgtext+0avgdata 30080maxresident)k
8inputs+1068552outputs (0major+2497minor)pagefaults 0swaps

So this reduces the max memory utilized from 4.2GB to 29MB!

For future work, the primary place where we are spending the most cpu
time (from resize2fs -d 16) are these two places:

blocks_to_move: Memory used: 2508k/25096k (1903k/606k), time: 91.42/91.53/ 0.00

and

calculate_summary_stats: Memory used: 2508k/25612k (1908k/601k), time: 95.33/95.45/ 0.00

The calculate_summary_stats pass can be sped up by using
ext2fs_find_first_{zero,set}_block_bitmap2(), instead of iterating
over the entire block bitmap one bit at a time.

The blocks_to_move pass can be sped up by using a bitmap to store the
location of fs metadata blocks, to avoid an O(N**2) algorithm where N
is the number of groups in the file system.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 resize/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/resize/main.c b/resize/main.c
index e4b4435..ef2a810 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -318,6 +318,7 @@ int main (int argc, char ** argv)
 		printf("%s", _("Couldn't find valid filesystem superblock.\n"));
 		exit (1);
 	}
+	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 
 	if (!(mount_flags & EXT2_MF_MOUNTED)) {
 		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
-- 
2.0.0

