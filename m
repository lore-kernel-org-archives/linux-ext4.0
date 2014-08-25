From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] tests/d_inline_dump: remove version dependency in the expected output
Date: Mon, 25 Aug 2014 18:31:08 -0400
Message-ID: <1409005868-10854-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48675 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbaHYWbO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 18:31:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also add the convenience macro $CLEAN_OUTPUT in test_config which can
be used to run the "sed -e $cmd_dir/filter.sed" command to clean up
e2fsprogs command output before comparing with the expected golden
output.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/d_inline_dump/expect |  6 ------
 tests/d_inline_dump/script | 12 ++++++------
 tests/test_config          |  1 +
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tests/d_inline_dump/expect b/tests/d_inline_dump/expect
index ead47f9..c84f64d 100644
--- a/tests/d_inline_dump/expect
+++ b/tests/d_inline_dump/expect
@@ -1,5 +1,4 @@
 *** long file
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 13   Type: regular    Mode:  0644   Flags: 0x10000000
 Generation: 3289262644    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 80
@@ -16,7 +15,6 @@ Extended attributes:
   user.a = "b" (1)
 Size of inline data: 80
 *** short file
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 18   Type: regular    Mode:  0644   Flags: 0x10000000
 Generation: 3842229473    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 20
@@ -34,7 +32,6 @@ Extended attributes:
 Size of inline data: 60
 
 *** long dir
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 16   Type: directory    Mode:  0755   Flags: 0x10000000
 Generation: 3842229469    Version: 0x00000000:00000004
 User:     0   Group:     0   Size: 132
@@ -51,7 +48,6 @@ Extended attributes:
   user.a = "b" (1)
 Size of inline data: 132
 *** short dir
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 20   Type: directory    Mode:  0755   Flags: 0x10000000
 Generation: 3710818931    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 60
@@ -69,7 +65,6 @@ Extended attributes:
 Size of inline data: 60
 
 *** long link
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x10000000
 Generation: 3289262643    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 80
@@ -85,7 +80,6 @@ Extended attributes:
   system.data (20)
 Fast link dest: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 *** short link
-debugfs 1.43-WIP (09-Jul-2014)
 Inode: 19   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 3842229474    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 20
diff --git a/tests/d_inline_dump/script b/tests/d_inline_dump/script
index 8d97729..7199453 100644
--- a/tests/d_inline_dump/script
+++ b/tests/d_inline_dump/script
@@ -11,21 +11,21 @@ ZIMAGE=$test_dir/image.gz
 gzip -d < $ZIMAGE > $TMPFILE
 
 echo "*** long file" > $OUT
-$DEBUGFS -R 'stat /file' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /file' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 echo "*** short file" >> $OUT
-$DEBUGFS -R 'stat /shortfile' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /shortfile' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 echo >> $OUT
 
 echo "*** long dir" >> $OUT
-$DEBUGFS -R 'stat /dir' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /dir' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 echo "*** short dir" >> $OUT
-$DEBUGFS -R 'stat /shortdir' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /shortdir' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 echo >> $OUT
 
 echo "*** long link" >> $OUT
-$DEBUGFS -R 'stat /link' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /link' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 echo "*** short link" >> $OUT
-$DEBUGFS -R 'stat /shortlink' $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'stat /shortlink' $TMPFILE 2>&1 | $CLEAN_OUTPUT >> $OUT 2>&1
 
 echo "*** end test" >> $OUT
 
diff --git a/tests/test_config b/tests/test_config
index 1872e5c..50e987e 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -20,6 +20,7 @@ E2UNDO_EXE="../misc/e2undo"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
 CRCSUM=../tests/progs/crcsum
+CLEAN_OUTPUT="sed -f $cmd_dir/filter.sed"
 LD_LIBRARY_PATH=../lib:../lib/ext2fs:../lib/e2p:../lib/et:../lib/ss
 DYLD_LIBRARY_PATH=../lib:../lib/ext2fs:../lib/e2p:../lib/et:../lib/ss
 export LD_LIBRARY_PATH
-- 
2.1.0

