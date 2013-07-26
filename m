From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: make sure group number is bumped after a inode allocation race
Date: Fri, 26 Jul 2013 15:16:14 -0400
Message-ID: <1374866174-14481-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When we try to allocate an inode, and there is a race between two
CPU's trying to grab the same inode, _and_ this inode is the last free
inode in the block group, make sure the group number is bumped before
we continue searching the rest of the block groups.  Otherwise, we end
up searching the current block group twice, and we end up skipping
searching the last block group.  So in the unlikely situation where
almost all of the inodes are allocated, it's possible that we will
return ENOSPC even though there might be free inodes in that last
block group.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/ialloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f03598c..5b8e22e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -734,11 +734,8 @@ repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb), ino);
-		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
-			if (++group == ngroups)
-				group = 0;
-			continue;
-		}
+		if (ino >= EXT4_INODES_PER_GROUP(sb))
+			goto next_group;
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
 			ext4_error(sb, "reserved inode found cleared - "
 				   "inode=%lu", ino + 1);
@@ -769,6 +766,9 @@ repeat_in_this_group:
 			goto got; /* we grabbed the inode! */
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
+	next_group:
+		if (++group == ngroups)
+			group = 0;
 	}
 	err = -ENOSPC;
 	goto out;
-- 
1.7.12.rc0.22.gcdd159b
