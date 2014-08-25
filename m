From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] resize2fs: clarify the size of blocks in resize2fs's messages
Date: Sun, 24 Aug 2014 23:59:50 -0400
Message-ID: <1408939192-22656-3-git-send-email-tytso@mit.edu>
References: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47273 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaHYD76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 23:59:58 -0400
In-Reply-To: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Debian-Bug: #758029

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 resize/main.c               | 9 +++++----
 tests/r_inline_xattr/expect | 2 +-
 tests/r_min_itable/expect   | 2 +-
 tests/r_move_itable/expect  | 8 ++++----
 tests/r_resize_inode/expect | 6 +++---
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index ef2a810..c107028 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -441,8 +441,9 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	if (new_size == ext2fs_blocks_count(fs->super)) {
-		fprintf(stderr, _("The filesystem is already %llu blocks "
-			"long.  Nothing to do!\n\n"), new_size);
+		fprintf(stderr, _("The filesystem is already %llu (%dk) "
+			"blocks long.  Nothing to do!\n\n"), new_size,
+			fs->blocksize / 1024);
 		exit(0);
 	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
@@ -468,8 +469,8 @@ int main (int argc, char ** argv)
 		ext2fs_close_free(&fs);
 		exit(1);
 	}
-	printf(_("The filesystem on %s is now %llu blocks long.\n\n"),
-	       device_name, new_size);
+	printf(_("The filesystem on %s is now %llu (%dk) blocks long.\n\n"),
+	       device_name, new_size, fs->blocksize / 1024);
 
 	if ((st_buf.st_size > new_file_size) &&
 	    (fd > 0)) {
diff --git a/tests/r_inline_xattr/expect b/tests/r_inline_xattr/expect
index 9e71264..b2f1ccd 100644
--- a/tests/r_inline_xattr/expect
+++ b/tests/r_inline_xattr/expect
@@ -6,7 +6,7 @@ Extended attributes stored in inode body:
 Exit status is 0
 resize2fs test.img 5M
 Resizing the filesystem on test.img to 5120 (1k) blocks.
-The filesystem on test.img is now 5120 blocks long.
+The filesystem on test.img is now 5120 (1k) blocks long.
 
 Exit status is 0
 debugfs -R ''stat file'' test.img 2>&1 | grep ''^Inode\|in inode body\|name = ''
diff --git a/tests/r_min_itable/expect b/tests/r_min_itable/expect
index 2d8ecb4..e01041c 100644
--- a/tests/r_min_itable/expect
+++ b/tests/r_min_itable/expect
@@ -1,7 +1,7 @@
 resize2fs test
 resize2fs -M test.img
 Resizing the filesystem on test.img to 1124 (1k) blocks.
-The filesystem on test.img is now 1124 blocks long.
+The filesystem on test.img is now 1124 (1k) blocks long.
 
 Exit status is 0
  
diff --git a/tests/r_move_itable/expect b/tests/r_move_itable/expect
index b4b089b..cec0038 100644
--- a/tests/r_move_itable/expect
+++ b/tests/r_move_itable/expect
@@ -3,7 +3,7 @@ resize2fs -p test.img 10000
 Resizing the filesystem on test.img to 10000 (1k) blocks.
 Begin pass 1 (max = 35)
 Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-The filesystem on test.img is now 9985 blocks long.
+The filesystem on test.img is now 9985 (1k) blocks long.
 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
@@ -299,7 +299,7 @@ resize2fs -p test.img 20000
 Resizing the filesystem on test.img to 20000 (1k) blocks.
 Begin pass 1 (max = 39)
 Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-The filesystem on test.img is now 19969 blocks long.
+The filesystem on test.img is now 19969 (1k) blocks long.
 
 Filesystem did not have a UUID; generating one.
 
@@ -833,7 +833,7 @@ resize2fs -p test.img 30000
 Resizing the filesystem on test.img to 30000 (1k) blocks.
 Begin pass 1 (max = 39)
 Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-The filesystem on test.img is now 29953 blocks long.
+The filesystem on test.img is now 29953 (1k) blocks long.
 
 Filesystem did not have a UUID; generating one.
 
@@ -1603,7 +1603,7 @@ resize2fs -p test.img 40000
 Resizing the filesystem on test.img to 40000 (1k) blocks.
 Begin pass 1 (max = 40)
 Extending the inode table     ----------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-The filesystem on test.img is now 40000 blocks long.
+The filesystem on test.img is now 40000 (1k) blocks long.
 
 Filesystem did not have a UUID; generating one.
 
diff --git a/tests/r_resize_inode/expect b/tests/r_resize_inode/expect
index 786fe13..ba1647e 100644
--- a/tests/r_resize_inode/expect
+++ b/tests/r_resize_inode/expect
@@ -1,7 +1,7 @@
 mke2fs -q -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 16384
 resize2fs test.img 65536
 Resizing the filesystem on test.img to 65536 (1k) blocks.
-The filesystem on test.img is now 65536 blocks long.
+The filesystem on test.img is now 65536 (1k) blocks long.
 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
@@ -448,7 +448,7 @@ Group 63: (Blocks 64513-65535)
 mke2fs -q -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 65536
 resize2fs test.img 16384
 Resizing the filesystem on test.img to 16384 (1k) blocks.
-The filesystem on test.img is now 16384 blocks long.
+The filesystem on test.img is now 16384 (1k) blocks long.
 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
@@ -600,7 +600,7 @@ Group 15: (Blocks 15361-16383)
 --------------------------------
 resize2fs test.img 165536
 Resizing the filesystem on test.img to 165536 (1k) blocks.
-The filesystem on test.img is now 165536 blocks long.
+The filesystem on test.img is now 165536 (1k) blocks long.
 
 Filesystem did not have a UUID; generating one.
 
-- 
2.1.0

