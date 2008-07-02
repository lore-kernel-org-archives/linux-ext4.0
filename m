From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] Ext4 Documentation updates.
Date: Wed, 02 Jul 2008 12:22:00 -0500
Message-ID: <20080702172200.14990.37737.stgit@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56256 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYGBRWC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jul 2008 13:22:02 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m62HM1Yf025746
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 13:22:01 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m62HM1EN172622
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 13:22:01 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m62HM1tE027817
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 13:22:01 -0400
Received: from [127.0.1.1] (rx8.austin.ibm.com [9.41.41.30])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m62HM1IU027759
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jul 2008 13:22:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Ext4 Documentation updates.

Some of the information in Documentation/filesystems/ext4.txt is out
of date and in need of an update.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 Documentation/filesystems/ext4.txt |   83 +++++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 0c5086d..b0c3bb2 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -15,23 +15,32 @@ Mailing list: linux-ext4@vger.kernel.org
 
   - Grab updated e2fsprogs from
     ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/
-    This is a patchset on top of e2fsprogs-1.39, which can be found at
-    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
 
-  - It's still mke2fs -j /dev/hda1
+    or grab the latest git repository from:
+    git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
+    
+  - Create a new filesystem and set the "test_fs" extended option:
 
-  - mount /dev/hda1 /wherever -t ext4dev
+    	# mke2fs -j -E test_fs /dev/hda1
 
-  - To enable extents,
+    Or set the test_fs flag on an existing ext3 filesystem:
 
-	mount /dev/hda1 /wherever -t ext4dev -o extents
+        # debugfs -w /dev/sda5
+	debugfs 1.41-WIP (17-Jun-2008)
+	debugfs:  set_super_value s_flags 4
+	debugfs:  quit 
+
+  - Mounting:
+
+	# mount /dev/hda1 /wherever -t ext4dev
+
+  - To disable extents:
+
+	# mount /dev/hda1 /wherever -t ext4dev -o noextents
 
   - The filesystem is compatible with the ext3 driver until you add a file
     which has extents (ie: `mount -o extents', then create a file).
 
-    NOTE: The "extents" mount flag is temporary.  It will soon go away and
-    extents will be enabled by the "-o extents" flag to mke2fs or tune2fs
-
   - When comparing performance with other filesystems, remember that
     ext3/4 by default offers higher data integrity guarantees than most.  So
     when comparing with a metadata-only journalling filesystem, use `mount -o
@@ -44,41 +53,46 @@ Mailing list: linux-ext4@vger.kernel.org
 
 2.1 Currently available
 
-* ability to use filesystems > 16TB
+* ability to use filesystems > 16TB (e2fsprogs support not available yet)
 * extent format reduces metadata overhead (RAM, IO for access, transactions)
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redunancy in tree
+* improved file allocation (multi-block alloc, delayed alloc)
+* fix 32000 subdirectory limit
+* nsec timestamps for mtime, atime, ctime, create time
+* inode version field on disk (NFSv4, Lustre)
+* reduced e2fsck time via uninit_bg feature
+* journal checksumming for robustness, performance
+* persistent file preallocation (e.g for streaming media, databases)
+* ability to pack bitmaps and inode tables into larger virtual groups via the
+  flex_bg feature
+* large file support
 
-2.1 Previously available, soon to be enabled by default by "mkefs.ext4":
+2.2 Previously available, soon to be enabled by default by "mkefs.ext4":
 
 * dir_index and resize inode will be on by default
 * large inodes will be used by default for fast EAs, nsec timestamps, etc
 
-2.2 Candidate features for future inclusion
+2.3 Candidate features for future inclusion
 
-There are several under discussion, whether they all make it in is
-partly a function of how much time everyone has to work on them:
+* Online defrag (patches available but not well tested)
+* Inode allocation using large virtual block groups via flex_bg (patch
+  available; fragmentation issues due to prolong fs use still unknown)
+* reduced mke2fs time via uninit_bg feature (capability to do this is
+  available in e2fsprogs but a kernel thread to do lazy zeroing of unused
+  inode table blocks after filesystem is first mounted is required for
+  safety)
 
-* improved file allocation (multi-block alloc, delayed alloc; basically done)
-* fix 32000 subdirectory limit (patch exists, needs some e2fsck work)
-* nsec timestamps for mtime, atime, ctime, create time (patch exists,
-  needs some e2fsck work)
-* inode version field on disk (NFSv4, Lustre; prototype exists)
-* reduced mke2fs/e2fsck time via uninitialized groups (prototype exists)
-* journal checksumming for robustness, performance (prototype exists)
-* persistent file preallocation (e.g for streaming media, databases)
+There are several others under discussion, whether they all make it in is
+partly a function of how much time everyone has to work on them. Features like
+metadata checksumming have been discussed and planned for a bit but no patches
+exist yet so I'm not sure they're in the near-term roadmap.
 
-Features like metadata checksumming have been discussed and planned for
-a bit but no patches exist yet so I'm not sure they're in the near-term
-roadmap.
+The big performance win will come with mballoc, delalloc and flex_bg
+grouping of bitmaps and inode tables.  Some test results available here:
 
-The big performance win will come with mballoc and delalloc.  CFS has
-been using mballoc for a few years already with Lustre, and IBM + Bull
-did a lot of benchmarking on it.  The reason it isn't in the first set of
-patches is partly a manageability issue, and partly because it doesn't
-directly affect the on-disk format (outside of much better allocation)
-so it isn't critical to get into the first round of changes.  I believe
-Alex is working on a new set of patches right now.
+ - http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
+ - http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
 
 3. Options
 ==========
@@ -224,7 +238,7 @@ stripe=n		Number of filesystem blocks that mballoc will try
 			disks *  RAID chunk size in file system blocks.
 
 Data Mode
----------
+=========
 There are 3 different data modes:
 
 * writeback mode
@@ -256,7 +270,8 @@ kernel source:	<file:fs/ext4/>
 		<file:fs/jbd2/>
 
 programs:	http://e2fsprogs.sourceforge.net/
-		http://ext2resize.sourceforge.net
 
 useful links:	http://fedoraproject.org/wiki/ext3-devel
 		http://www.bullopensource.org/ext4/
+		http://ext4.wiki.kernel.org/index.php/Main_Page
+		http://fedoraproject.org/wiki/Features/Ext4

