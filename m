From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: Ext4 patch queue comments
Date: Mon, 21 Jan 2008 10:41:47 -0500
Message-ID: <E1JGymR-0000V6-BS@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50534 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbYAUPmo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2008 10:42:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Mingming,

I thought I should mention to you (and other people who maintain the
ext4 patch queue) that I'm continuing to have to fix up certain issues
in the patch queue to make sure the patch comments look good when
imported into git via "guilt".

Basically, I have a git branch called "ext4dev" where the
ext4-patch-queue git repository is in my Linux tree in
.git/patches/ext4dev.  Then I can important the patches into Linux git
via:

	(cd .git/patches/ext4dev; git pull)
	git checkout ext4dev
	git reset --hard v2.6.24-rc8
	guilt pop -a
	guilt push -a

The goal is to make sure the patches look clean when they are pulled by
Linus, the result doesn't look like a mess.

In order for this to be the case, a couple of things have to be true:

The first line of the patch should be a summary of what the patch does,
and it should be free standing.  It should be followed by an empty line.

The next line (in almost all cases) should be a From: line.  This will
be used by guilt to set the author of the patch, so the original person
submitting the patch shows up in the git logs as the author.

After that, there should be a description of the patch.  It should be
short, sweet, and to the point.  Quoting other poeple's mail messages is
in general not great idea, but if it should be done, it should be cut
down drastically.  Massive code documentation (such as in the mballoc
patch; I'll deal with it later) should probably be in the .c file, and
not in the git revision log, so that people who are trying to understand
how the .c file works can see it in the source file.

The patch description should be line wrapped at around 70-72 characters
(the one-line summary should not be longer than that if possible as
well).

Also, "A port of some other patch" isn't as good as actually describing
what the patch does, and then including a comment that this was copied
from some other patch at the end.

Finally, try to avoid extra empty blank lines in the patch comments.

In general, remember that a patch description should be free-standing,
and describe the specific patch in question.

    					- Ted



commit a5cab2d59b7fb032f507933d5d2b1590edbf9036
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jan 21 10:31:58 2008 -0500

    Fix up patch comments
    
    Fix up patch comments so that they look decent when imported into git
    using guilt.

diff --git a/ext4_get_extent_length_fix.patch b/ext4_get_extent_length_fix.patch
index 75f3b55..556d8a1 100644
--- a/ext4_get_extent_length_fix.patch
+++ b/ext4_get_extent_length_fix.patch
@@ -1,4 +1,4 @@
-et4: Get the actual length of extent
+ext4: Get the actual length of extent
 
 From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
 
@@ -23,7 +23,6 @@ Call Trace:
 [<ffffffff810a8de7>] sys_fallocate+0xe4/0x10d
 [<ffffffff8100c043>] tracesys+0xd5/0xda
 
-
 Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
 ---
 
diff --git a/ext4_handle_uniniatilized_extents_split_return_error_fix.patch b/ext4_handle_uniniatilized_extents_split_return_error_fix.patch
index 2bc49d5..a9739c8 100644
--- a/ext4_handle_uniniatilized_extents_split_return_error_fix.patch
+++ b/ext4_handle_uniniatilized_extents_split_return_error_fix.patch
@@ -1,56 +1,36 @@
-ext4: fix uniniatilized extent splitting error.
+ext4: fix uniniatilized extent splitting error
 
 From: Dmitry Monakhov <dmonakhov@openvz.org>
 
-Hi,
-While playing with new fancy fallocate interface on ext4 i've triggered
-bug which corrupted my grub :).
+Fix bug reported by Dmitry Monakhov caused by lost error code
 
-My testcase:
-~~~~~~~~~~~~
-blksize = 0x1000;
-fd = open(argv[1], O_RDWR|O_CREAT, 0700);
-unsigned long long sz = 0x10000000UL;
-/* allocating big blocks chunk */
-syscall(__NR_fallocate, fd, 0, 0UL, sz)
+    Testcase: 
 
-/* grab all other available filesystem space */
-tfd = open("tmp", O_RDWR|O_CREAT|O_DIRECT, 0700);
-while( write(tfd, buf, 4096) > 0); /* loop untill ENOSPC */
-fsync(fd); /* just in case */
-while (pos < sz) {
-	/* each seek+ write operation result in splits uninitialized extent
-	in three extents. Splitting may result in new extent allocation
-	which probably will fail because of ENOSPC*/
+    blksize = 0x1000;
+    fd = open(argv[1], O_RDWR|O_CREAT, 0700);
+    unsigned long long sz = 0x10000000UL;
+    /* allocating big blocks chunk */
+    syscall(__NR_fallocate, fd, 0, 0UL, sz)
 
-	lseek(fd, blksize*2 -1, SEEK_CUR);
-	if ((ret = write(fd, 'a', 1)) != 1)
-		exit(1);
-	pos += blksize * 2;
-}
+    /* grab all other available filesystem space */
+    tfd = open("tmp", O_RDWR|O_CREAT|O_DIRECT, 0700);
+    while( write(tfd, buf, 4096) > 0); /* loop untill ENOSPC */
+    fsync(fd); /* just in case */
+    while (pos < sz) {
+    	/* each seek+ write operation result in splits uninitialized extent
+    	in three extents. Splitting may result in new extent allocation
+    	which probably will fail because of ENOSPC*/
 
-Buggy place:
-~~~~~~~~~~~~
-ext4_ext_get_blocks(..., bh_result,..)
-{
-	err = 0;
-	allocated = 0;
-....
-	 ret = ext4_ext_convert_to_initialized(...)
- 	if (ret < 0)
-<< By occasion real error code was lost here.
-		goto out2
-....
-out2:
-....
-	return err? err: allocated;
-<< Wow.. exit with "0", and caller assumes what bh_result was properly filled
-<<   and then will submit it for write. But in fact bh contains random data in
-<<   ->b_bdev, ->b_blocknr fileds :).
-}
+    	lseek(fd, blksize*2 -1, SEEK_CUR);
+    	if ((ret = write(fd, 'a', 1)) != 1)
+    		exit(1);
+    	pos += blksize * 2;
+    }
 
 Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
+
 ---
 
  fs/ext4/extents.c |    5 +++--
diff --git a/jbd2-sparse-warning-fixes.patch b/jbd2-sparse-warning-fixes.patch
index 8c58cbf..f1c4d1e 100644
--- a/jbd2-sparse-warning-fixes.patch
+++ b/jbd2-sparse-warning-fixes.patch
@@ -1,13 +1,13 @@
 JBD: sparse pointer use of zero as null
-From: Mingming Cao <cmm@us.ibm.com>
-Ported from upstream ext3/jbd changes
 
-sparse pointer use of zero as null
+From: Mingming Cao <cmm@us.ibm.com>
 
 Get rid of sparse related warnings from places that use integer as NULL
-pointer.
+pointer.  (Ported from upstream ext3/jbd changes.)
 
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
+
 ---
 
 ---
diff --git a/jbd2_group_short_lived_and_reclaimable_kernel_allocations.patch b/jbd2_group_short_lived_and_reclaimable_kernel_allocations.patch
index 06d6e17..db743e4 100644
--- a/jbd2_group_short_lived_and_reclaimable_kernel_allocations.patch
+++ b/jbd2_group_short_lived_and_reclaimable_kernel_allocations.patch
@@ -1,29 +1,17 @@
-JBD2: Group short-lived and reclaimable kernel allocations
-From: Mingming Cao <cmm@us.ibm.com>
-Ported from JBD to JBD2
-
---------------------------------
-From: Mel Gorman <mel@csn.ul.ie>
-Date: Tue, 16 Oct 2007 08:25:52 +0000 (-0700)
-Subject: Group short-lived and reclaimable kernel allocations
-X-Git-Tag: v2.6.24-rc1~1137
-X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=e12ba74d8ff3e2f73a583500d7095e406df4d093
-
-Group short-lived and reclaimable kernel allocations
+jbd2: Mark jbd2 slabs as SLAB_TEMPORARY
 
-This patch marks a number of allocations that are either short-lived such as
-network buffers or are reclaimable such as inode allocations.  When something
-like updatedb is called, long-lived and unmovable kernel allocations tend to
-be spread throughout the address space which increases fragmentation.
+From: Mingming Cao <cmm@us.ibm.com>
 
-This patch groups these allocations together as much as possible by adding a
-new MIGRATE_TYPE.  The MIGRATE_RECLAIMABLE type is for allocations that can be
-reclaimed on demand, but not moved.  i.e.  they can be migrated by deleting
-them and re-reading the information from elsewhere.
+This patch marks slab allocations by jbd2 as short-lived in support of
+Mel Gorman's "Group short-lived and reclaimable kernel allocations"
+patch.  (Ported from similar changes made to fs/jbd/journal.c and
+fs/jbd/revoke.c in Mel's patch.)
 
 Cc: Mel Gorman <mel@csn.ul.ie>
 Cc: Andrew Morton <akpm@linux-foundation.org>
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
+
 ---
 
 ---
diff --git a/jbd2_user_of_the_jiffes_rounding_code.patch b/jbd2_user_of_the_jiffes_rounding_code.patch
index b73d9af..f24783d 100644
--- a/jbd2_user_of_the_jiffes_rounding_code.patch
+++ b/jbd2_user_of_the_jiffes_rounding_code.patch
@@ -1,28 +1,21 @@
-user of the jiffies rounding code: JBD2
-From: Mingming Cao <cmm@us.ibm.com>
-
-Ported from JBD changes from Arjan van de Ven <arjan@linux.intel.com>
--------------------------------------------
-Date: Sun, 10 Dec 2006 10:21:26 +0000 (-0800)
-Subject: [PATCH] user of the jiffies rounding code: JBD
-X-Git-Tag: v2.6.20-rc1~15^2~43
-X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=44d306e1508fef6fa7a6eb15a1aba86ef68389a6
+jbd2: Use round-jiffies() function for the "5 second" ext4/jbd2 wakeup
 
-[PATCH] user of the jiffies rounding code: JBD
+From: Mingming Cao <cmm@us.ibm.com>
 
-This patch introduces a user: of the round_jiffies() function; the "5 second"
-ext3/jbd wakeup.
+While "every 5 seconds" doesn't sound as a problem, there can be many
+of these (and these timers do add up over all the kernel).  The "5
+second" wakeup isn't really timing sensitive; in addition even with
+rounding it'll still happen every 5 seconds (with the exception of the
+very first time, which is likely to be rounded up to somewhere closer
+to 6 seconds)
 
-While "every 5 seconds" doesn't sound as a problem, there can be many of these
-(and these timers do add up over all the kernel).  The "5 second" wakeup isn't
-really timing sensitive; in addition even with rounding it'll still happen
-every 5 seconds (with the exception of the very first time, which is likely to
-be rounded up to somewhere closer to 6 seconds)
+(Ported from similar JBD patch made by Arjan van de Ven to
+fs/jbd/transaction.c)
 
 Cc: Arjan van de Ven <arjan@linux.intel.com>
 Cc: Andrew Morton <akpm@osdl.org>
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>
----
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
 
 ---
  fs/jbd2/transaction.c |    2 +-
diff --git a/lockdep-annotate-jbd2-journal-start.patch b/lockdep-annotate-jbd2-journal-start.patch
index f236ea1..0fa1dfd 100644
--- a/lockdep-annotate-jbd2-journal-start.patch
+++ b/lockdep-annotate-jbd2-journal-start.patch
@@ -1,8 +1,12 @@
-jbd2: port jbd2 lockdep support to jbd2
-> Except lockdep doesn't know about journal_start(), which has ranking
-> requirements similar to a semaphore.  
+jbd2: add lockdep support
+
+From: Mingming Cao <cmm@us.ibm.com>
+
+Ported from similar patch for the jbd layer.
 
 Signed-off-by: Mingming Cao <cmm@us.ibm.com>
+Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
+
 ---
  fs/jbd2/transaction.c |   11 +++++++++++
  include/linux/jbd2.h  |    4 ++++
