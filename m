From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Mon, 24 Nov 2008 23:42:52 +0530
Message-ID: <20081124181252.GE8462@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com> <20081124113323.GC8462@skywalker> <492AD821.9030506@sun.com> <20081124164300.GD8462@skywalker> <492AEC69.40202@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:54096 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYKXSNE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:13:04 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAOID054013045
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 23:43:00 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOICPCJ4317328
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 23:42:25 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAOICxZ5031055
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 05:13:00 +1100
Content-Disposition: inline
In-Reply-To: <492AEC69.40202@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 09:03:21PM +0300, Alex Zhuravlev wrote:
> Aneesh Kumar K.V wrote:
>> On Mon, Nov 24, 2008 at 07:36:49PM +0300, Alex Zhuravlev wrote:
>>> Aneesh Kumar K.V wrote:
>>>> Ok the changes was not done for this purpose. I need to make sure we
>>>> update bitmap and clear group_desc uninit flag after taking sb_bgl_lock
>>>> That means when we claim blocks we can't use mb_set_bits with
>>>> sb_bgl_lock because we would already be holding it. How about the below
>>>> change
>>> may I have a look at the original patch?
>>
>> http://patchwork.ozlabs.org/patch/10065/
>
> I don't understand how a group can be "uninit" if we do some manipulations
> inside. both allocation and preallocation initialize group first, see in
> ext4_mb_init_cache()
>

With commit c806e68f we do a init_bitmap every time we do a
read_block_bitmap.

To quote the update commit message that i have

    ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
    
    We need to make sure we update the block bitmap and clear
    EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held.  We look at
    EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each time in
    ext4_read_block_bitmap (introduced by commit c806e68f), and this can
    race with block allocations in ext4_mb_mark_diskspace_used().
    
    ext4_read_block_bitmap does:
    
    spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
    if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
    	ext4_init_block_bitmap(sb, bh, block_group, desc);
    
    Now on the block allocation side we do
    
    mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
    			ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
    ....
    spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
    if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
    	gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
    
    ie on allocation we update the bitmap then we take the sb_bgl_lock
    and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
    parallel ext4_read_block_bitmap can zero out the bitmap in between
    the above mb_set_bits and spin_lock(sb_bg_lock..)
    
    The race results in below user visible errors
    EXT4-fs error (device sdb1): ext4_mb_release_inode_pa: free 100, pa_free 105
    EXT4-fs error (device sdb1): mb_free_blocks: double-free of inode 0's block 50(bit 100 in group 0)

-aneesh
