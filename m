From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: delalloc and journal locking order inversion fixes.
Date: Wed, 21 May 2008 23:14:14 +0530
Message-ID: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38667 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936445AbYEURoi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 13:44:38 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4LHiPPX016984
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:25 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHiEwE1208548
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:14 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4LHi9E1018273
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:10 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The below set of patches gets the delalloc work with journal locking
order inversion patches.

The series file look like

+ ext4-new-defm-options
+ ext4-call-blkdev_issue_flush-on-fsync.patch
+ ext4-page-mkwrite.patch
+ ext4_ialloc-flexbg.patch
+ ext4-inverse-pagelock-vs-transaction.patch
+ 005-lock-inversion.patch
+ delalloc-vfs.patch
+ ext4-fix-fs-corruption-with-delalloc.patch
+ delalloc-ext4.patch
+ delalloc-ext4-release-page-when-write_begin-failed.patch
+ delalloc-ext4-preallocation-handling.patch
...
...
.....
+ delalloc-ext4-lock-reverse.patch
> delalloc-fix.patch

Most of these patche will have to folded into other patches before
we push them to the patch queue.

Patch and their subject line matching:

ext4-page-mkwrite.patch: (repost with changes)
[PATCH] ext4: Use page_mkwrite vma_operations to get mmap write notification

ext4-inverse-pagelock-vs-transaction.patch:(repost due to moving patch up in the stack)
[PATCH] ext4: Inverse locking order of page_lock and transaction start.

005-lock-inversion.patch: (New changes needs review )
[PATCH] ext4: Add validation to jbd lock inversion patch and split and writepage
  and page_mkwrite calls.

delalloc-ext4-lock-reverse.patch:(repost due to changes, VFS change dropped)
[PATCH] ext4:  inverse locking ordering of page_lock and transaction start in delalloc

delalloc-fix.patch:(New changes to fix the hang)
[PATCH] ext4: Fix delalloc sync hang with journal lock inversion

NOTE: The patches are only for review and not for patchqueue.

-aneesh

