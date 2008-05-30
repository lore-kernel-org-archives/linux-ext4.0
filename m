From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] delalloc and journal locking order inversion fixes
Date: Fri, 30 May 2008 10:51:06 -0700
Message-ID: <1212169866.8596.79.camel@BVR-FS.beaverton.ibm.com>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47828 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbYE3RvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 13:51:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4UHp7Bc005936
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 13:51:07 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UHovd2120116
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 13:50:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UHovkx005937
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 13:50:57 -0400
In-Reply-To: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-05-30 at 19:09 +0530, Aneesh Kumar K.V wrote:
> The below set of patches gets the delalloc work with journal locking
> order inversion patches.
> 
> The series file look like
> 
> + ext4-new-defm-options
> + ext4-call-blkdev_issue_flush-on-fsync.patch
> 0001-ext4-Use-page_mkwrite-vma_operations-to-get-mmap-wr.patch
> + ext4_ialloc-flexbg.patch
> 0002-ext4-Inverse-locking-order-of-page_lock-and-transac.patch
> 0003-vfs-Move-mark_inode_dirty-from-under-page-lock-in.patch
> 0004-ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
> + delalloc-vfs.patch
> + ext4-fix-fs-corruption-with-delalloc.patch
> + delalloc-ext4.patch
> + delalloc-ext4-release-page-when-write_begin-failed.patch
> + delalloc-ext4-preallocation-handling.patch
> ...
> ...
> .....
> + vfs-fiemap.patch
> + ext4-add-ext4_ext_walk_space.patch
> + ext4-fiemap.patch
> 0005-ext4-inverse-locking-ordering-of-page_lock-and-tra.patch
> 0006-ext4-Fix-delalloc-sync-hang-with-journal-lock-inver.patch
> 
> I have pushed the lock inversion patches and related changes to the
> top of the patch queue expecting it can be pushed upstream before
> delalloc changes.
> 
> 
Thanks for fixing this up.

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

Added the series to patch queue.

Mingming
> -aneesh
> 
> 

