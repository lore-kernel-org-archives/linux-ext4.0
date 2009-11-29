From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] e2fsck: Don't rehash directories which can fit in a single directory block
Date: Sun, 29 Nov 2009 15:33:28 -0500
Message-ID: <1259526809-23697-4-git-send-email-tytso@mit.edu>
References: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbZK2UeR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2009 15:34:17 -0500
In-Reply-To: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/rehash.c         |   12 ++++++++++++
 tests/f_dup_de/expect.1 |   12 ++++++------
 tests/f_dup_de/expect.2 |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 46d04e4..780742e 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -736,6 +736,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 		fd.compress = 1;
 	fd.parent = 0;
 
+retry_nohash:
 	/* Read in the entire directory into memory */
 	retval = ext2fs_block_iterate2(fs, ino, 0, 0,
 				       fill_dir_block, &fd);
@@ -744,6 +745,17 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 		goto errout;
 	}
 
+	/* 
+	 * If the entries read are less than a block, then don't index
+	 * the directory
+	 */
+	if (!fd.compress && (fd.dir_size < (fs->blocksize - 24))) {
+		fd.compress = 1;
+		fd.dir_size = 0;
+		fd.num_array = 0;
+		goto retry_nohash;
+	}
+
 #if 0
 	printf("%d entries (%d bytes) found in inode %d\n",
 	       fd.num_array, fd.dir_size, ino);
diff --git a/tests/f_dup_de/expect.1 b/tests/f_dup_de/expect.1
index 78545cc..e421547 100644
--- a/tests/f_dup_de/expect.1
+++ b/tests/f_dup_de/expect.1
@@ -5,24 +5,24 @@ Duplicate entry 'mailcap.dpkg-old' found.
 
 Pass 3: Checking directory connectivity
 Pass 3A: Optimizing directories
-Duplicate entry 'mailcap.dpkg-old' in /etc (12) found.  Clear? yes
-
 Duplicate entry 'fstab' in /etc (12) found.  Clear? yes
 
 Duplicate entry 'localtime' in /etc (12) found.  Clear? yes
 
-Duplicate entry 'resolv.conf' in /etc (12) found.  Clear? yes
-
-Duplicate entry 'usb.permissions' in /etc (12) found.  Clear? yes
+Duplicate entry 'mailcap.dpkg-old' in /etc (12) found.  Clear? yes
 
 Duplicate entry 'modules.conf.old' in /etc (12) found.  Clear? yes
 
 Entry 'modules.conf.old' in /etc (12) has a non-unique filename.
 Rename to modules.conf.o~0? yes
 
+Duplicate entry 'resolv.conf' in /etc (12) found.  Clear? yes
+
+Duplicate entry 'usb.permissions' in /etc (12) found.  Clear? yes
+
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 18/2048 files (5.6% non-contiguous), 325/330 blocks
+test_filesys: 18/2048 files (5.6% non-contiguous), 324/330 blocks
 Exit status is 1
diff --git a/tests/f_dup_de/expect.2 b/tests/f_dup_de/expect.2
index e3accc6..4d680af 100644
--- a/tests/f_dup_de/expect.2
+++ b/tests/f_dup_de/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 18/2048 files (5.6% non-contiguous), 325/330 blocks
+test_filesys: 18/2048 files (5.6% non-contiguous), 324/330 blocks
 Exit status is 0
-- 
1.6.5.216.g5288a.dirty

