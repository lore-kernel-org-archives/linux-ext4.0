From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Tue, 10 Apr 2007 23:40:20 -0400
Message-ID: <20070411034019.GA25231@thunk.org>
References: <Pine.LNX.4.61.0704101344050.29750@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59152 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030384AbXDKDk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2007 23:40:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704101344050.29750@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 10, 2007 at 01:51:12PM -0700, Jim Garlick wrote:
> I think this is a small buglet in e2fsck:  if a file has multiple hard 
> links, e2fsck pass1c search_dirent_proc() doesn't maintain its count 
> properly and may return DIRENT_ABORT before it has found containing 
> directories for all inodes sharing blocks.

Yep, indeed!  Thanks for submitting the patch.  I've checked it into
the e2fsprogs source code repository.

Enclosed please note what I've checked into Mercurial (also visible at
http://thunk.org/hg/e2fsprogs/?rev/8bb7637c6508).  I'd really
appreciate it if folks who submit bug fixes or other
changes/enhancements to e2fsck could include test cases which
reproduce the bug and then demonstrate that the patches fix the
problem, such as what I've done below.  Also note that providing a
script which generates the test filesystem is now preferred to
including an image.gz file; it avoids the need for binary patches, and
it makes it clearer how the test filesystem is constructed.  (We
couldn't do that before since debugfs didn't have enough facilities to
some of the test cases; patches to replace image.gz files with a
generator scripts are definitely welcome.)

So for people who are looking to create test cases, please use the
script file in tests/f_dup4 in the Mercurial repository as a template
for new test cases when possible.

Thanks, regards,

						- Ted


# HG changeset patch
# User tytso@mit.edu
# Date 1176260109 14400
# Node ID 8bb7637c6508a37cbf1556a083dcf4f7985e2926
# Parent  365efb1a2299b5f9f064f15186540d2807fab308
e2fsck: pass1c terminates early if hard links

I think this is a small buglet in e2fsck:  if a file has multiple hard
links, e2fsck pass1c search_dirent_proc() doesn't maintain its count
properly and may return DIRENT_ABORT before it has found containing
directories for all inodes sharing blocks.

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r 365efb1a2299 -r 8bb7637c6508 e2fsck/ChangeLog
--- a/e2fsck/ChangeLog	Tue Apr 10 21:10:55 2007 -0400
+++ b/e2fsck/ChangeLog	Tue Apr 10 22:55:09 2007 -0400
@@ -1,3 +1,11 @@ 2007-04-06  Theodore Tso  <tytso@mit.edu
+2007-04-10  Jim Garlick <garlick@llnl.gov>
+
+	* pass1b.c (search_dirent_proc): if a file has multiple hard
+		links, e2fsck pass1c search_dirent_proc() doesn't maintain
+		its count properly and may return DIRENT_ABORT before it
+		has found containing directories for all inodes sharing
+		blocks.
+
 2007-04-06  Theodore Tso  <tytso@mit.edu>
 
 	* e2fsck.conf.5.in: Update man page to document the scratch_files
diff -r 365efb1a2299 -r 8bb7637c6508 e2fsck/pass1b.c
--- a/e2fsck/pass1b.c	Tue Apr 10 21:10:55 2007 -0400
+++ b/e2fsck/pass1b.c	Tue Apr 10 22:55:09 2007 -0400
@@ -372,8 +372,10 @@ static int search_dirent_proc(ext2_ino_t
 	if (!n)
 		return 0;
 	p = (struct dup_inode *) dnode_get(n);
-	p->dir = dir;
-	sd->count--;
+	if (!p->dir) {
+		p->dir = dir;
+		sd->count--;
+	}
 
 	return(sd->count ? 0 : DIRENT_ABORT);
 }
diff -r 365efb1a2299 -r 8bb7637c6508 tests/ChangeLog
--- a/tests/ChangeLog	Tue Apr 10 21:10:55 2007 -0400
+++ b/tests/ChangeLog	Tue Apr 10 22:55:09 2007 -0400
@@ -1,3 +1,11 @@ 2007-04-07  Theodore Tso  <tytso@mit.edu
+2007-04-10  Theodore Tso  <tytso@mit.edu>
+
+	* f_dup4: New test cases which tests a bugfix in e2fsck where if an
+		inode which has blocks claimed by other inodes has
+		multiple hard links, e2fsck could fail to collect the
+		directory information for all of the inodes with multiply
+		claimed blocks.
+
 2007-04-07  Theodore Tso  <tytso@mit.edu>
 
 	* test_script.in: Skip completely empty directories
diff -r 365efb1a2299 -r 8bb7637c6508 tests/f_dup4/expect.1
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tests/f_dup4/expect.1	Tue Apr 10 22:55:09 2007 -0400
@@ -0,0 +1,112 @@
+Pass 1: Checking inodes, blocks, and sizes
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 16: 30
+Multiply-claimed block(s) in inode 17: 30
+Multiply-claimed block(s) in inode 18: 30
+Multiply-claimed block(s) in inode 19: 30
+Multiply-claimed block(s) in inode 20: 34
+Multiply-claimed block(s) in inode 21: 34
+Multiply-claimed block(s) in inode 22: 34
+Multiply-claimed block(s) in inode 23: 34
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 8 inodes containing multiply-claimed blocks.)
+
+File /dir/foo (inode #16, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir/quux1 (inode #19, mod time Tue Apr 10 21:00:00 2007)
+	/dir3/baz (inode #18, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/bar (inode #17, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir2/bar (inode #17, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir/quux1 (inode #19, mod time Tue Apr 10 21:00:00 2007)
+	/dir3/baz (inode #18, mod time Tue Apr 10 21:00:00 2007)
+	/dir/foo (inode #16, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir3/baz (inode #18, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir/quux1 (inode #19, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/bar (inode #17, mod time Tue Apr 10 21:00:00 2007)
+	/dir/foo (inode #16, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir/quux1 (inode #19, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir3/baz (inode #18, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/bar (inode #17, mod time Tue Apr 10 21:00:00 2007)
+	/dir/foo (inode #16, mod time Tue Apr 10 21:00:00 2007)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /dir/fee (inode #20, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir4/fum (inode #23, mod time Tue Apr 10 21:00:00 2007)
+	/dir3/foe (inode #22, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/fie (inode #21, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir2/fie (inode #21, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir4/fum (inode #23, mod time Tue Apr 10 21:00:00 2007)
+	/dir3/foe (inode #22, mod time Tue Apr 10 21:00:00 2007)
+	/dir/fee (inode #20, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir3/foe (inode #22, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir4/fum (inode #23, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/fie (inode #21, mod time Tue Apr 10 21:00:00 2007)
+	/dir/fee (inode #20, mod time Tue Apr 10 21:00:00 2007)
+Clone multiply-claimed blocks? yes
+
+File /dir4/fum (inode #23, mod time Tue Apr 10 21:00:00 2007) 
+  has 1 multiply-claimed block(s), shared with 3 file(s):
+	/dir3/foe (inode #22, mod time Tue Apr 10 21:00:00 2007)
+	/dir2/fie (inode #21, mod time Tue Apr 10 21:00:00 2007)
+	/dir/fee (inode #20, mod time Tue Apr 10 21:00:00 2007)
+Multiply-claimed blocks already reassigned or cloned.
+
+Pass 2: Checking directory structure
+Invalid inode number for '.' in directory inode 20.
+Fix? yes
+
+Invalid inode number for '.' in directory inode 21.
+Fix? yes
+
+Invalid inode number for '.' in directory inode 22.
+Fix? yes
+
+Pass 3: Checking directory connectivity
+'..' in /dir/fee (20) is /dir4 (15), should be /dir (12).
+Fix? yes
+
+'..' in /dir2/fie (21) is /dir4 (15), should be /dir2 (13).
+Fix? yes
+
+'..' in /dir3/foe (22) is /dir4 (15), should be /dir3 (14).
+Fix? yes
+
+Pass 4: Checking reference counts
+Inode 12 ref count is 4, should be 3.  Fix? yes
+
+Inode 13 ref count is 4, should be 3.  Fix? yes
+
+Inode 14 ref count is 4, should be 3.  Fix? yes
+
+Inode 15 ref count is 0, should be 3.  Fix? yes
+
+Inode 16 ref count is 1, should be 3.  Fix? yes
+
+Inode 17 ref count is 1, should be 2.  Fix? yes
+
+Inode 19 ref count is 1, should be 3.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 23/32 files (0.0% non-contiguous), 35/100 blocks
+Exit status is 1
diff -r 365efb1a2299 -r 8bb7637c6508 tests/f_dup4/expect.2
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tests/f_dup4/expect.2	Tue Apr 10 22:55:09 2007 -0400
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 23/32 files (0.0% non-contiguous), 35/100 blocks
+Exit status is 0
diff -r 365efb1a2299 -r 8bb7637c6508 tests/f_dup4/name
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tests/f_dup4/name	Tue Apr 10 22:55:09 2007 -0400
@@ -0,0 +1,2 @@
+find all directdory pathnames
+
diff -r 365efb1a2299 -r 8bb7637c6508 tests/f_dup4/script
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/tests/f_dup4/script	Tue Apr 10 22:55:09 2007 -0400
@@ -0,0 +1,50 @@
+SKIP_GUNZIP="true"
+TEST_DATA="test.data"
+
+echo "/ Murphy Magic.  The SeCrEt of the UnIvErSe is 43, NOT 42" > $TEST_DATA
+
+touch $TMPFILE
+$MKE2FS -N 32 -F -o Linux -b 1024 $TMPFILE 100 > /dev/null 2>&1 
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+set_current_time 200704102100
+set_super_value lastcheck 0
+set_super_value hash_seed null
+set_super_value mkfs_time 0
+mkdir dir
+mkdir dir2
+mkdir dir3
+mkdir dir4
+cd /dir
+write $TEST_DATA foo
+cd /dir2
+write $TEST_DATA bar
+cd /dir3
+write $TEST_DATA baz
+cd /dir4
+write $TEST_DATA quux
+mkdir /dir/fee
+mkdir /dir2/fie
+mkdir /dir3/foe
+mkdir /dir4/fum
+link /dir/foo /dir2/foo1
+link /dir/foo /dir3/foo2
+link /dir2/bar /dir3/bar1
+link /dir4/quux /dir/quux1
+link /dir4/quux /dir2/quux2
+set_inode_field /dir/foo block[0] 30
+set_inode_field /dir2/bar block[0] 30
+set_inode_field /dir3/baz block[0] 30
+set_inode_field /dir/fee block[0] 34
+set_inode_field /dir2/fie block[0] 34
+set_inode_field /dir3/foe block[0] 34
+q
+EOF
+
+E2FSCK_TIME=200704102100
+export E2FSCK_TIME
+
+. $cmd_dir/run_e2fsck
+
+rm -f $TEST_DATA
+
+unset E2FSCK_TIME TEST_DATA
