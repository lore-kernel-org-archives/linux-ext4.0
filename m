From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] ext2fs_mkjournal(): Don't allocate an extra block to the journal
Date: Wed, 27 Aug 2008 17:14:33 -0400
Message-ID: <1219871676-18456-1-git-send-email-tytso@mit.edu>
References: <20080827210636.GC26987@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Boh=C3=A9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51449 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818AbYH0VOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:14:38 -0400
In-Reply-To: <20080827210636.GC26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Sourceforge-Bug: 1483791

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/mkjournal.c           |    2 +-
 tests/f_badjour_indblks/expect.1 |    2 +-
 tests/f_badjour_indblks/expect.2 |    2 +-
 tests/f_badjourblks/expect.1     |    2 +-
 tests/f_badjourblks/expect.2     |    2 +-
 tests/f_miss_journal/expect.1    |    2 +-
 tests/f_miss_journal/expect.2    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index e55dcbd..3cae874 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -225,7 +225,7 @@ static int mkjournal_proc(ext2_filsys	fs,
 		es->err = retval;
 		return BLOCK_ABORT;
 	}
-	if (blockcnt > 0)
+	if (blockcnt >= 0)
 		es->num_blocks--;
 
 	es->newblocks++;
diff --git a/tests/f_badjour_indblks/expect.1 b/tests/f_badjour_indblks/expect.1
index 0190bf2..d80da89 100644
--- a/tests/f_badjour_indblks/expect.1
+++ b/tests/f_badjour_indblks/expect.1
@@ -29,5 +29,5 @@ Creating journal (1024 blocks):  Done.
 *** journal has been re-created - filesystem is now ext3 again ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/256 files (0.0% non-contiguous), 1112/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1111/8192 blocks
 Exit status is 1
diff --git a/tests/f_badjour_indblks/expect.2 b/tests/f_badjour_indblks/expect.2
index 35365fa..3fbb8b3 100644
--- a/tests/f_badjour_indblks/expect.2
+++ b/tests/f_badjour_indblks/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/256 files (0.0% non-contiguous), 1112/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1111/8192 blocks
 Exit status is 0
diff --git a/tests/f_badjourblks/expect.1 b/tests/f_badjourblks/expect.1
index 5a0bfef..cd86fc4 100644
--- a/tests/f_badjourblks/expect.1
+++ b/tests/f_badjourblks/expect.1
@@ -27,5 +27,5 @@ Creating journal (1024 blocks):  Done.
 *** journal has been re-created - filesystem is now ext3 again ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/256 files (0.0% non-contiguous), 1080/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1079/8192 blocks
 Exit status is 1
diff --git a/tests/f_badjourblks/expect.2 b/tests/f_badjourblks/expect.2
index 632dc71..7c50703 100644
--- a/tests/f_badjourblks/expect.2
+++ b/tests/f_badjourblks/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/256 files (0.0% non-contiguous), 1080/8192 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1079/8192 blocks
 Exit status is 0
diff --git a/tests/f_miss_journal/expect.1 b/tests/f_miss_journal/expect.1
index cad69f6..7d696f8 100644
--- a/tests/f_miss_journal/expect.1
+++ b/tests/f_miss_journal/expect.1
@@ -25,5 +25,5 @@ Creating journal (1024 blocks):  Done.
 *** journal has been re-created - filesystem is now ext3 again ***
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/256 files (0.0% non-contiguous), 1080/2048 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1079/2048 blocks
 Exit status is 1
diff --git a/tests/f_miss_journal/expect.2 b/tests/f_miss_journal/expect.2
index 1e8c47f..ad32763 100644
--- a/tests/f_miss_journal/expect.2
+++ b/tests/f_miss_journal/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/256 files (0.0% non-contiguous), 1080/2048 blocks
+test_filesys: 11/256 files (0.0% non-contiguous), 1079/2048 blocks
 Exit status is 0
-- 
1.5.6.1.205.ge2c7.dirty

