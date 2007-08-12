From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Remove e2fsck's swapfs test, since we've removed the functionality
Date: Sun, 12 Aug 2007 12:57:17 -0400
Message-ID: <11869378412404-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
 <11869378411811-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46655 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbXHLQ6g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:36 -0400
In-Reply-To: <11869378411811-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_swapfs/debugfs.cmd |    5 --
 tests/f_swapfs/expect      |  133 --------------------------------------------
 tests/f_swapfs/image       |  Bin 1048576 -> 0 bytes
 tests/f_swapfs/image.gz    |  Bin 3777 -> 0 bytes
 tests/f_swapfs/name        |    1 -
 tests/f_swapfs/script      |   79 --------------------------
 6 files changed, 0 insertions(+), 218 deletions(-)
 delete mode 100644 tests/f_swapfs/debugfs.cmd
 delete mode 100644 tests/f_swapfs/expect
 delete mode 100644 tests/f_swapfs/image
 delete mode 100644 tests/f_swapfs/image.gz
 delete mode 100644 tests/f_swapfs/name
 delete mode 100644 tests/f_swapfs/script

diff --git a/tests/f_swapfs/debugfs.cmd b/tests/f_swapfs/debugfs.cmd
deleted file mode 100644
index df583b2..0000000
--- a/tests/f_swapfs/debugfs.cmd
+++ /dev/null
@@ -1,5 +0,0 @@
-ls
-stat sym
-stat double-indirect-test
-cat fluff
-quit
diff --git a/tests/f_swapfs/expect b/tests/f_swapfs/expect
deleted file mode 100644
index ecbb990..0000000
--- a/tests/f_swapfs/expect
+++ /dev/null
@@ -1,133 +0,0 @@
-Swapfs test
-e2fsck -yf -N test_filesys
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 25/256 files (0.0% non-contiguous), 418/1024 blocks
-Exit status is 0
-e2fsck -Sy -N test_filesys
-Pass 0: Doing byte-swap of filesystem
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 25/256 files (0.0% non-contiguous), 418/1024 blocks
-Exit status is 0
-Running debugfs....
-debugfs: ls
- 2  (12) .    2  (12) ..    11  (20) lost+found    12  (16) fluff   
- 13  (28) indirect-fluff-test    14  (28) double-indirect-test   
- 15  (20) sym    16  (24) long-sym-test    17  (864) dir-test   
-debugfs: stat sym
-Inode: 15   Type: symlink    Mode:  0777   Flags: 0x0   Generation: 1
-User:     0   Group:     0   Size: 5
-File ACL: 0    Directory ACL: 0
-Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
-ctime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-atime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-mtime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-Fast_link_dest: fluff
-debugfs: stat double-indirect-test
-Inode: 14   Type: regular    Mode:  0644   Flags: 0x0   Generation: 1
-User:     0   Group:     0   Size: 348960
-File ACL: 0    Directory ACL: 0
-Links: 1   Blockcount: 688
-Fragment:  Address: 0    Number: 0    Size: 0
-ctime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-atime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-mtime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-BLOCKS:
-(0-11):70-81, (IND):82, (12-267):83-338, (DIND):339, (IND):340, (268-340):341-413
-TOTAL: 344
-
-debugfs: cat fluff
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-
-debugfs: quit
-Exit status is 0
-e2fsck -yf -N test_filesys
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 25/256 files (0.0% non-contiguous), 418/1024 blocks
-Exit status is 0
-e2fsck -sy -N test_filesys
-Pass 0: Doing byte-swap of filesystem
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 25/256 files (0.0% non-contiguous), 418/1024 blocks
-Exit status is 0
-Running debugfs....
-debugfs: ls
- 2  (12) .    2  (12) ..    11  (20) lost+found    12  (16) fluff   
- 13  (28) indirect-fluff-test    14  (28) double-indirect-test   
- 15  (20) sym    16  (24) long-sym-test    17  (864) dir-test   
-debugfs: stat sym
-Inode: 15   Type: symlink    Mode:  0777   Flags: 0x0   Generation: 1
-User:     0   Group:     0   Size: 5
-File ACL: 0    Directory ACL: 0
-Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
-ctime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-atime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-mtime: 0x322737e2 -- Fri Aug 30 18:50:10 1996
-Fast_link_dest: fluff
-debugfs: stat double-indirect-test
-Inode: 14   Type: regular    Mode:  0644   Flags: 0x0   Generation: 1
-User:     0   Group:     0   Size: 348960
-File ACL: 0    Directory ACL: 0
-Links: 1   Blockcount: 688
-Fragment:  Address: 0    Number: 0    Size: 0
-ctime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-atime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-mtime: 0x322488cf -- Wed Aug 28 17:58:39 1996
-BLOCKS:
-(0-11):70-81, (IND):82, (12-267):83-338, (DIND):339, (IND):340, (268-340):341-413
-TOTAL: 344
-
-debugfs: cat fluff
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-yabba dabba doo.  cocka doodle doo.  yabba dabba doo.  cocka doodle doo. yipyip
-
-debugfs: quit
-Exit status is 0
-e2fsck -yf -N test_filesys
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 25/256 files (0.0% non-contiguous), 418/1024 blocks
-Exit status is 0
diff --git a/tests/f_swapfs/image b/tests/f_swapfs/image
deleted file mode 100644
index e7b24b94610a31eb8697f68748a34da75b5c071b..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 1048576
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
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
e2oNAZfB*pk1PBlyK!5-N0t5&UAV6Sk2>d?)UC1>6

diff --git a/tests/f_swapfs/image.gz b/tests/f_swapfs/image.gz
deleted file mode 100644
index 852231bd45d70b4c3bb64fffc0588960ef5d34b8..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 3777
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

diff --git a/tests/f_swapfs/name b/tests/f_swapfs/name
deleted file mode 100644
index b4520ba..0000000
--- a/tests/f_swapfs/name
+++ /dev/null
@@ -1 +0,0 @@
-checking the e2fsck swapfs functionality
diff --git a/tests/f_swapfs/script b/tests/f_swapfs/script
deleted file mode 100644
index 75f9fb4..0000000
--- a/tests/f_swapfs/script
+++ /dev/null
@@ -1,79 +0,0 @@
-if $FSCK -SV > /dev/null 2>&1 ; then
-    IMAGE=$test_dir/image.gz
-    VERIFY_FSCK_OPT=-yf
-    SWAP_FSCK_OPT=-Sy
-    NATIVE_FSCK_OPT=-sy
-    OUT=$test_name.log
-    EXP=$test_dir/expect
-    
-    gunzip < $IMAGE > $TMPFILE
-    
-    echo "Swapfs test" > $OUT
-    
-    echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
-    $FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '2d' $OUT.new >> $OUT
-    
-    echo e2fsck $SWAP_FSCK_OPT -N test_filesys > $OUT.new
-    $FSCK $SWAP_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '2d' $OUT.new >> $OUT
-    
-    echo Running debugfs.... >> $OUT
-    $DEBUGFS -f $test_dir/debugfs.cmd $TMPFILE > $OUT.new 2>&1 
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '1d' $OUT.new >> $OUT
-    
-    echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
-    $FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '2d' $OUT.new >> $OUT
-    
-    echo e2fsck $NATIVE_FSCK_OPT -N test_filesys > $OUT.new
-    $FSCK $NATIVE_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '2d' $OUT.new >> $OUT
-    
-    echo Running debugfs.... >> $OUT
-    $DEBUGFS -f $test_dir/debugfs.cmd $TMPFILE > $OUT.new 2>&1 
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '1d' $OUT.new >> $OUT
-    
-    echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
-    $FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
-    status=$?
-    echo Exit status is $status >> $OUT.new
-    sed -e '2d' $OUT.new >> $OUT
-    rm -f $OUT.new
-    
-    rm $TMPFILE
-    
-    #
-    # Do the verification
-    #
-    
-    rm -f $test_name.ok $test_name.failed
-    cmp -s $OUT $EXP
-    status=$?
-    
-    if [ "$status" = 0 ] ; then
-	    echo "ok"
-	    touch $test_name.ok
-    else
-	    echo "failed"
-	    diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-    fi
-    
-    unset IMAGE VERIFY_FSCK_OPT SWAP_FSCK_OPT NATIVE_FSCK_OPT OUT EXP 
-
-else
-    rm -f $test_name.ok $test_name.failed
-    echo "skipped"
-fi
-- 
1.5.3.rc4.67.gf9286
