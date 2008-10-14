From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patches for patchqueue
Date: Tue, 14 Oct 2008 12:03:22 +0530
Message-ID: <1223966008-6656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36365 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750766AbYJNGdl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 02:33:41 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9E6Xbkl010578
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:37 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9E6XbRJ856180
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:37 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9E6XaO9004479
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:37 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Below patches are updates for patches in the patch queue.
0001-ext4-Use-an-rbtree-for-tracking-blocks-freed-during.patch
Updated with the fix from you. I also removed the definition of
EXT4_BB_MAX_BLOCKS

0004-ext4-Use-tag-dirty-lookup-during-mpage_da_submit_io.patch
0005-vfs-Remove-the-range_cont-writeback-mode.patch
0006-vfs-Add-no_nrwrite_update-and-no_index_update-write.patch
0007-ext4-Fix-file-fragmentation-during-large-file-write.patch

Split the single patch fix_file_fragmentation_during_large_file_write
into 4 patches. The VFS changes are cc to linux-fsdevel@vger.kernel.org

0010-ext4-Free-ext4_prealloc_space-using-kmem_cache_free.patch

-aneesh




