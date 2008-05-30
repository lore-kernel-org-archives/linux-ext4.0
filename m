From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v2] delalloc and journal locking order inversion fixes
Date: Fri, 30 May 2008 19:09:23 +0530
Message-ID: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50730 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYE3Njh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 09:39:37 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4UDd6r8027510
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:39:06 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UDdJWR4731044
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:39:19 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UDdYbO023714
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:39:35 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The below set of patches gets the delalloc work with journal locking
order inversion patches.

The series file look like

+ ext4-new-defm-options
+ ext4-call-blkdev_issue_flush-on-fsync.patch
0001-ext4-Use-page_mkwrite-vma_operations-to-get-mmap-wr.patch
+ ext4_ialloc-flexbg.patch
0002-ext4-Inverse-locking-order-of-page_lock-and-transac.patch
0003-vfs-Move-mark_inode_dirty-from-under-page-lock-in.patch
0004-ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
+ delalloc-vfs.patch
+ ext4-fix-fs-corruption-with-delalloc.patch
+ delalloc-ext4.patch
+ delalloc-ext4-release-page-when-write_begin-failed.patch
+ delalloc-ext4-preallocation-handling.patch
...
...
.....
+ vfs-fiemap.patch
+ ext4-add-ext4_ext_walk_space.patch
+ ext4-fiemap.patch
0005-ext4-inverse-locking-ordering-of-page_lock-and-tra.patch
0006-ext4-Fix-delalloc-sync-hang-with-journal-lock-inver.patch

I have pushed the lock inversion patches and related changes to the
top of the patch queue expecting it can be pushed upstream before
delalloc changes.


-aneesh


