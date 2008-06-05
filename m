From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patches for the patchqueue
Date: Thu, 5 Jun 2008 15:20:32 +0530
Message-ID: <20080605095032.GE8942@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51351 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYFEJvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 05:51:13 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m559oswO024206
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 15:20:54 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m559oNvf721046
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 15:20:23 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m559osY8030368
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 15:20:54 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

These are the patches for patch queue. They have been sent to the
mailing list before. I am attaching them below so that it can be easily
pushed to the patch queue. The patches will be sent as a follow up to
this mail.

I modified the delalloc-clear-bh-delay-bit-fix.patch
to address only the VFS bug. The delay bit is properly cleared in
0001-delalloc-enospc.patch. I guess we should also push
003-delalloc-clear-bh-delay-bit-fix.patch to the stable series as
it is a  VFS bug in handling delay buffer.

002-blkcleanup.patch patch can be merged with
ext4-use-inode-preallocation-with-noextents.patch. I am just posting it
as a separate patch so that others can review the changes.


The series file looks like

+ ext4-use-inode-preallocation-with-noextents.patch
+ 002-blkcleanup.patch
+ ext4-call-blkdev_issue_flush-on-fsync.patch
+ ext4-mb-add-ext4_has_free_blocks-check.patch

......

+ jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch
+ delalloc-vfs.patch
+ 003-delalloc-clear-bh-delay-bit-fix.patch
+ ext4-fix-fs-corruption-with-delalloc.patch

.....

+ percpucounter-add-sum-and-set-function.patch
+ 0001-delalloc-enospc.patch
+ jbd-blocks-reservation-fix-for-large-blk.patch
+ jbd2-blocks-reservation-fix-for-large-blk.patch

-aneesh
