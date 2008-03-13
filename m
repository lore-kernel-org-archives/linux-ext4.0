From: Theodore Ts'o <tytso@mit.edu>
Subject: [E2FSPROGS PATCH 3/4] e2fsck: Fix directory i_size handling
Date: Thu, 13 Mar 2008 01:12:26 -0400
Message-ID: <1205385147-12855-3-git-send-email-tytso@mit.edu>
References: <1205385147-12855-1-git-send-email-tytso@mit.edu>
 <1205385147-12855-2-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: bas@dev.tetra.nl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38329 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbYCMFMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 01:12:38 -0400
In-Reply-To: <1205385147-12855-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a directory's i_size is bigger than the number of blocks, don't try
to allocate extra empty blocks to the end of the directory; there's no
real point to do that.  Also, if a directory's i_size is not a
multiple of the blocksize, flag that as a mistake so it can be fixed.

This more elegantly addresses the problem which was found on Bas van
Schaik's filesystem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c           |   25 ++++++++++++++++++++++++-
 tests/f_holedir/expect.1 |   13 ++++++++++---
 tests/f_holedir/expect.2 |    2 +-
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b4db8ef..839f099 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1546,6 +1546,26 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		goto out;
 	}
 	
+	if (pb.is_dir) {
+		while (1) {
+			struct ext2_db_entry *entry;
+
+			if (ext2fs_dblist_get_last(fs->dblist, &entry) ||
+			    (entry->ino != ino) ||
+			    (entry->blk != 0) ||
+			    (entry->blockcnt == 0))
+				break;
+			/* printf("Dropping ino %lu blk %lu blockcnt %d\n", 
+				  entry->ino, entry->blk, entry->blockcnt); */
+			ext2fs_dblist_drop_last(fs->dblist);
+			if (ext2fs_dblist_get_last(fs->dblist, &entry) ||
+			    (entry->ino != ino))
+				pb.last_block--;
+			else
+				pb.last_block = entry->blockcnt;
+		}
+	}
+
 	if (inode->i_flags & EXT2_INDEX_FL) {
 		if (handle_htree(ctx, pctx, ino, inode, block_buf)) {
 			inode->i_flags &= ~EXT2_INDEX_FL;
@@ -1583,7 +1603,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 #endif
 	if (pb.is_dir) {
 		int nblock = inode->i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (nblock > (pb.last_block + 1))
+		if (inode->i_size & (fs->blocksize - 1)) 
+			bad_size = 5;
+		else if (nblock > (pb.last_block + 1))
 			bad_size = 1;
 		else if (nblock < (pb.last_block + 1)) {
 			if (((pb.last_block + 1) - nblock) >
@@ -1745,6 +1767,7 @@ static int process_block(ext2_filsys fs,
 			printf("Missing block (#%d) in directory inode %lu!\n",
 			       blockcnt, p->ino);
 #endif
+			p->last_block = blockcnt;
 			goto mark_dir;
 		}
 		return 0;
diff --git a/tests/f_holedir/expect.1 b/tests/f_holedir/expect.1
index 05e0cbb..ad74fa6 100644
--- a/tests/f_holedir/expect.1
+++ b/tests/f_holedir/expect.1
@@ -15,12 +15,19 @@ Directory inode 11 has an unallocated block #3.  Allocate? yes
 
 Directory inode 11 has an unallocated block #6.  Allocate? yes
 
-Directory inode 11 has an unallocated block #11.  Allocate? yes
-
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
+Block bitmap differences:  -21
+Fix? yes
+
+Free blocks count wrong for group #0 (78, counted=79).
+Fix? yes
+
+Free blocks count wrong (78, counted=79).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/32 files (9.1% non-contiguous), 22/100 blocks
+test_filesys: 11/32 files (9.1% non-contiguous), 21/100 blocks
 Exit status is 1
diff --git a/tests/f_holedir/expect.2 b/tests/f_holedir/expect.2
index a821f87..4c0b4f2 100644
--- a/tests/f_holedir/expect.2
+++ b/tests/f_holedir/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32 files (0.0% non-contiguous), 22/100 blocks
+test_filesys: 11/32 files (0.0% non-contiguous), 21/100 blocks
 Exit status is 0
-- 
1.5.4.1.144.gdfee-dirty

