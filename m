From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] libext2fs: create inlinedata symlinks
Date: Sun, 24 Aug 2014 12:15:50 -0400
Message-ID: <20140824161550.GE6236@thunk.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042617.2441.24067.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Pu Hou <houpu.hp@alibaba-inc.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46689 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbaHXQP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Aug 2014 12:15:58 -0400
Content-Disposition: inline
In-Reply-To: <20140809042617.2441.24067.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 09:26:17PM -0700, Darrick J. Wong wrote:
> Add to ext2fs_symlink the ability to create inline data symlinks.

Applied with the following modification to the test script and
expected out.  This makes the test more self-documenting --- by
looking at the expect script it's more clear what is going on --- and
it also makes it easier to understand what might have gone wrong if
the test fails.  In particular it includes the error messages when
trying to create a symlink longer than what is allowed given the file
system block size.

Thanks,

						- Ted

diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index 847e092..13768a1 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -6,31 +6,80 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 441/1024 blocks
 Exit status is 0
-stat /l_30
+debugfs -R "symlink /l_30 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+debugfs -R "symlink /l_70 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+debugfs -R "symlink /l_500 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+debugfs -R "symlink /l_1023 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+debugfs -R "symlink /l_1024 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+ext2fs_symlink: Invalid argument passed to ext2 library 
+symlink: Invalid argument passed to ext2 library 
+debugfs -R "symlink /l_1500 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
+ext2fs_symlink: Invalid argument passed to ext2 library 
+symlink: Invalid argument passed to ext2 library 
+debugfs -R "stat /l_30" test.img
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
+Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 31
+File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ atime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ mtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+crtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+Size of extra inode fields: 28
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
-stat /l_70
+debugfs -R "stat /l_70" test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
+Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 71
+File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ atime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ mtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+crtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+Size of extra inode fields: 28
 Extended attributes:
   system.data (11)
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
-stat /l_500
+debugfs -R "stat /l_500" test.img
 Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
+Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Size: 501
+File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
-stat /l_1500
+ ctime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ atime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ mtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+crtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+Size of extra inode fields: 28
+EXTENTS:
+(0):153
+debugfs -R "stat /l_1023" test.img
+Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
+Generation: 0    Version: 0x00000000:00000000
+User:     0   Group:     0   Size: 1024
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 2
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ atime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+ mtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+crtime: 0x53fa0e06:00000000 -- Sun Aug 24 16:08:38 2014
+Size of extra inode fields: 28
+EXTENTS:
+(0):154
+debugfs -R "stat /l_1024" test.img
+/l_1024: File not found by ext2_lookup 
+debugfs -R "stat /l_1500" test.img
 /l_1500: File not found by ext2_lookup 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 14/128 files (0.0% non-contiguous), 442/1024 blocks
+test_filesys: 15/128 files (0.0% non-contiguous), 443/1024 blocks
 Exit status is 0
diff --git a/tests/f_create_symlinks/script b/tests/f_create_symlinks/script
index c49825a..958347a 100644
--- a/tests/f_create_symlinks/script
+++ b/tests/f_create_symlinks/script
@@ -23,15 +23,20 @@ echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
-for i in 30 70 500 1500; do
-	echo "symlink /l_$i /$(perl -e "print 'x' x $i;")"
-done | $DEBUGFS -w $TMPFILE >/dev/null 2>&1
+for i in 30 70 500 1023 1024 1500; do
+	echo "debugfs -R \"symlink /l_$i /$(perl -e "print 'x' x $i;")\" test.img" >> $OUT
+	$DEBUGFS -w -R "symlink /l_$i /$(perl -e "print 'x' x $i;")" $TMPFILE \
+		 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+done
 
-for i in 30 70 500 1500; do
-	echo "stat /l_$i" >> $OUT
-	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | egrep '(File not found|^Inode|^Fast link dest|Blockcount:|^Extended attributes:|system.data|Size:)' >> $OUT
+for i in 30 70 500 1023 1024 1500; do
+	echo "debugfs -R \"stat /l_$i\" test.img" >> $OUT
+	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | \
+		 sed -f $cmd_dir/filter.sed >> $OUT
 done
 
+/bin/cp $TMPFILE /tmp/foo.img
+
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
