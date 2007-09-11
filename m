From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: new mballoc patches.
Date: Tue, 11 Sep 2007 13:59:26 +0530
Message-ID: <46E651E6.3070107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53141 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXIKI3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 04:29:51 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8B8TY0K012906
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 18:29:34 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8B8TY8Q4292828
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 18:29:34 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8B9TXor000936
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 19:29:34 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have updated the mballoc patches. The same can be found at

http://www.radian.org/~kvaneesh/ext4/patch-series/



The series file is 

# This series applies on GIT commit b07d68b5ca4d55a16fab223d63d5fb36f89ff42f
ext4-journal_chksum-2.6.20.patch
ext4-journal-chksum-review-fix.patch
ext4_uninit_blockgroup.patch
64-bit-i_version.patch
i_version_hi.patch
ext4_i_version_hi_2.patch
i_version_update_ext4.patch
jbd-stats-through-procfs
jbd-stats-through-procfs_fix.patch
delalloc-vfs.patch
delalloc-ext4.patch
ext-truncate-mutex.patch
ext3-4-migrate.patch
new-extent-function.patch
generic-find-next-le-bit
mballoc-core.patch
ext234_enlarge_blocksize.patch
ext2_rec_len_overflow_with_64kblk_fix.patch
ext3_rec_len_overflow_with_64kblk_fix.patch
ext4_rec_len_overflow_with_64kblk_fix.patch
RFC-1-2-JBD-slab-management-support-for-large-b.patch
RFC-2-2-JBD-blocks-reservation-fix-for-large-bl.patch



Changes:
a) deleted mballoc-fixup.patch; merged with mballoc-core.path
b) deleted mballoc-mkdir-oops-fix.patch; merged with mballoc-core.patch
c) merged  Uninitialized group related changes for mballoc
d) merged the checkpatch.pl error fix patch for mballoc 
e) merged the fix for ext4_ext_search_right for error 
   EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode #3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), depth 0(1)
f) PPC build fix by introducing generic_find_next_le_bit()
g) Document the code. Rest of the places that needs more comments are marked with FIXME!!
h) 48 bit block usage by converting bg_*_bitmap and bg_inode_table to respective ext4_*_bitmap and ext4_inode_table() function
i) Added jbd fixes patches from Mingming for large  block size with the comment from hch. (this is added towards the end of the series)
k) Updated the ext234_enlarge_blocksize.patch ext2_rec_len_overflow_with_64kblk_fix.patch ext3_rec_len_overflow_with_64kblk_fix.patch 
   ext4_rec_len_overflow_with_64kblk_fix.patch to make sure they can be applied with stgit. They didn't had a valid email id in the
   From: field. ( This is only commit message update )

Test status:
Minor testing with KVM. I also didn't do a PPC build. 

Mingming/Avantika,

Can we update the patch queue with the series ?

-aneesh
  
