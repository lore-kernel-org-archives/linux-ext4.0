From: akpm@linux-foundation.org
Subject: + ext4-remove-extra-is_rdonly-check.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:54:28 -0700
Message-ID: <200706231654.l5NGsPNl019755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: haveblue@us.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: remove extra IS_RDONLY() check
has been added to the -mm tree.  Its filename is
     ext4-remove-extra-is_rdonly-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: remove extra IS_RDONLY() check
From: Dave Hansen <haveblue@us.ibm.com>

ext4_change_inode_journal_flag() is only called from one location:
ext4_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY()
call in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check
+++ a/fs/ext4/inode.c
@@ -3352,7 +3352,7 @@ int ext4_change_inode_journal_flag(struc
 	 */
 
 	journal = EXT4_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;
 
 	jbd2_journal_lock_updates(journal);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

document-nlink-function.patch
ext3-remove-extra-is_rdonly-check.patch
ext4-remove-extra-is_rdonly-check.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
page-owner-tracking-leak-detector.patch
