From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [E2FSPROGS, PATCH] libext2fs: Fix byte-swap logic for i_block[] in inodes with extents
Date: Mon, 24 Mar 2008 08:34:15 -0400
Message-ID: <1206362055-13244-1-git-send-email-tytso@mit.edu>
References: <47E403F3.3030209@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61594 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830AbYCXMfL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 08:35:11 -0400
In-Reply-To: <47E403F3.3030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

ext2fs_swap_inode_full() was incorrectly swapping the i_block array
for extents.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/swapfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 132f6f3..33c7ab3 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -147,6 +147,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			    int bufsize)
 {
 	unsigned i, has_data_blocks, extra_isize, attr_magic;
+	int has_extents = 0;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -172,12 +173,13 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		has_data_blocks = ext2fs_inode_data_blocks(fs, 
 					   (struct ext2_inode *) t);
 	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
-		has_data_blocks = 0;
+		has_extents = 1;
 	t->i_flags = ext2fs_swab32(f->i_flags);
-	if (hostorder && (t->i_flags & EXT4_EXTENTS_FL))
-		has_data_blocks = 0;
+	if (!hostorder && (t->i_flags & EXT4_EXTENTS_FL))
+		has_extents = 1;
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
-	if (!islnk || has_data_blocks ) {
+	/* extent data are swapped on access, not here */
+	if (!has_extents && (!islnk || has_data_blocks)) {
 		for (i = 0; i < EXT2_N_BLOCKS; i++)
 			t->i_block[i] = ext2fs_swab32(f->i_block[i]);
 	} else if (t != f) {
-- 
1.5.4.1.144.gdfee-dirty

