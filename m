From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/2] tests: fix f_badcluster output formatting
Date: Tue, 29 Jul 2014 17:30:40 -0600
Message-ID: <1406676640-5627-2-git-send-email-adilger@dilger.ca>
References: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:9286 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaG2Xan (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2014 19:30:43 -0400
In-Reply-To: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The f_badcluster output format depends on how libreadline formats
and outputs the commands read from stdin.  Instead of trying to
handle these differences, use an input command file, which does
not depend on external components to be consistent.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/f_badcluster/expect |   16 ++++++++--------
 tests/f_badcluster/script |    5 ++++-
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
index 5a60cf3..6cfffb7 100644
--- a/tests/f_badcluster/expect
+++ b/tests/f_badcluster/expect
@@ -109,7 +109,7 @@ Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_fs: 18/128 files (5.6% non-contiguous), 1248/2048 blocks
-debugfs:  stat /a
+debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152157    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -121,7 +121,7 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-1):1136-1137, (2):1138
-debugfs:  stat /b
+debugfs: stat /b
 Inode: 13   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152158    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -133,7 +133,7 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-2):1152-1154
-debugfs:  stat /c
+debugfs: stat /c
 Inode: 14   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152159    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -145,7 +145,7 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-1):1216-1217, (2):1218
-debugfs:  stat /d
+debugfs: stat /d
 Inode: 15   Type: regular    Mode:  0644   Flags: 0x0
 Generation: 1117152160    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -159,7 +159,7 @@ BLOCKS:
 (TIND):1650
 TOTAL: 1
 
-debugfs:  stat /e
+debugfs: stat /e
 Inode: 16   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152161    Version: 0x00000001
 User:     0   Group:     0   Size: 6144
@@ -171,7 +171,7 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-2):1664-1666, (5):1669
-debugfs:  stat /f
+debugfs: stat /f
 Inode: 17   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152162    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -183,7 +183,7 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0):1232, (1):1233, (2):1234
-debugfs:  stat /g
+debugfs: stat /g
 Inode: 18   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152163    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
@@ -195,4 +195,4 @@ atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-2):1680-1682, (3):1683
-debugfs:  
\ No newline at end of file
+debugfs: quit
diff --git a/tests/f_badcluster/script b/tests/f_badcluster/script
index 74498a4..56b4b7f 100644
--- a/tests/f_badcluster/script
+++ b/tests/f_badcluster/script
@@ -6,7 +6,10 @@ if test -x $DEBUGFS_EXE; then
 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 	$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
-	for i in a b c d e f g; do echo "stat /$i"; done | $DEBUGFS_EXE $TMPFILE >> $OUT
+	for i in a b c d e f g; do echo "stat /$i"; done > $TMPFILE.tmp
+	echo "quit" >> $TMPFILE.tmp
+	$DEBUGFS_EXE -f $TMPFILE.tmp $TMPFILE >> $OUT
+	rm -f $TMPFILE.tmp
 
 	cmp -s $OUT $EXP
 	status=$?
-- 
1.7.3.4

