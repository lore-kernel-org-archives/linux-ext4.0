From: akpm@linux-foundation.org
Subject: - ext3-remove-extra-is_rdonly-check.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:21 -0700
Message-ID: <200707162057.l6GKvLae002182@imap1.linux-foundation.org>
To: haveblue@us.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995AbXGPVPF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: remove extra IS_RDONLY() check
has been removed from the -mm tree.  Its filename was
     ext3-remove-extra-is_rdonly-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: remove extra IS_RDONLY() check
From: Dave Hansen <haveblue@us.ibm.com>

ext3_change_inode_journal_flag() is only called from one location:
ext3_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY()
call in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-remove-extra-is_rdonly-check fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-remove-extra-is_rdonly-check
+++ a/fs/ext3/inode.c
@@ -3195,7 +3195,7 @@ int ext3_change_inode_journal_flag(struc
 	 */
 
 	journal = EXT3_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;
 
 	journal_lock_updates(journal);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
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
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
page-owner-tracking-leak-detector.patch
