From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: new mballoc patches.
Date: Tue, 11 Sep 2007 16:18:29 -0700
Message-ID: <1189552709.3974.2.camel@localhost.localdomain>
References: <46E651E6.3070107@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41047 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXIKXSQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2007 19:18:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8BNIF0n017415
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 19:18:15 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8BNIFgV592428
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 19:18:15 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8BNIE9W027040
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 19:18:15 -0400
In-Reply-To: <46E651E6.3070107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-11 at 13:59 +0530, Aneesh Kumar K.V wrote:
> I have updated the mballoc patches. The same can be found at
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/
> 
> 
> 
> The series file is 
> 
> # This series applies on GIT commit b07d68b5ca4d55a16fab223d63d5fb36f89ff42f
> ext4-journal_chksum-2.6.20.patch
> ext4-journal-chksum-review-fix.patch
> ext4_uninit_blockgroup.patch
> 64-bit-i_version.patch
> i_version_hi.patch
> ext4_i_version_hi_2.patch
> i_version_update_ext4.patch
> jbd-stats-through-procfs
> jbd-stats-through-procfs_fix.patch
> delalloc-vfs.patch
> delalloc-ext4.patch
> ext-truncate-mutex.patch
> ext3-4-migrate.patch
> new-extent-function.patch
> generic-find-next-le-bit
> mballoc-core.patch
> ext234_enlarge_blocksize.patch
> ext2_rec_len_overflow_with_64kblk_fix.patch
> ext3_rec_len_overflow_with_64kblk_fix.patch
> ext4_rec_len_overflow_with_64kblk_fix.patch
> RFC-1-2-JBD-slab-management-support-for-large-b.patch
> RFC-2-2-JBD-blocks-reservation-fix-for-large-bl.patch
> 
> 
> 
> Changes:
> a) deleted mballoc-fixup.patch; merged with mballoc-core.path
> b) deleted mballoc-mkdir-oops-fix.patch; merged with mballoc-core.patch
> c) merged  Uninitialized group related changes for mballoc
> d) merged the checkpatch.pl error fix patch for mballoc 
> e) merged the fix for ext4_ext_search_right for error 
>    EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode #3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), depth 0(1)
> f) PPC build fix by introducing generic_find_next_le_bit()
> g) Document the code. Rest of the places that needs more comments are marked with FIXME!!
> h) 48 bit block usage by converting bg_*_bitmap and bg_inode_table to respective ext4_*_bitmap and ext4_inode_table() function
> i) Added jbd fixes patches from Mingming for large  block size with the comment from hch. (this is added towards the end of the series)
> k) Updated the ext234_enlarge_blocksize.patch ext2_rec_len_overflow_with_64kblk_fix.patch ext3_rec_len_overflow_with_64kblk_fix.patch 
>    ext4_rec_len_overflow_with_64kblk_fix.patch to make sure they can be applied with stgit. They didn't had a valid email id in the
>    From: field. ( This is only commit message update )
> 
> Test status:
> Minor testing with KVM. I also didn't do a PPC build. 
> 
> Mingming/Avantika,
> 
> Can we update the patch queue with the series ?
> 

Thanks for the update.  I just back to home from London late last night,
still catching up emails, so I haven't get a chance to update the ext4
patch queue yet. Will do so shortly.


Cheers,
Mingming
> -aneesh
>   
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
