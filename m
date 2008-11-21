From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Fri, 21 Nov 2008 23:01:35 +0530
Message-ID: <20081121173135.GF11212@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926EE3C.7050207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33121 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbYKURh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 12:37:28 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mALHabnS026783
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:36:37 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALHWegI1450068
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:32:40 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mALHWNjW025858
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:32:24 +1100
Content-Disposition: inline
In-Reply-To: <4926EE3C.7050207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:22:04AM -0600, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > We need to make sure we update the block bitmap and clear
> > EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held. We look
> > at EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each
> > time in ext4_read_block_bitmap (introduced by
> > c806e68f5647109350ec546fee5b526962970fd2 )
> 
> Can you add details about the failure mode(s) of this race, so people
> (i.e. me) have an idea which bugs they've seen that it might address?
> 

ext4_read_block_bitmap does

	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
		ext4_init_block_bitmap(sb, bh, block_group, desc);

the above ext4_init_block_bitmap actually zero out the block bitmap.

Now on the block allocation side we do

	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);

	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);

ie on allocation we update the bitmap then we take the sb_bgl_lock
and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
parallel ext4_read_block_bitmap can zero out the bitmap in between
the above mb_set_bits and spin_lock(sb_bg_lock..)

Result of this race is
a) blocks getting allocated multiple times
b) File corruption because two files have same blocks allocated
c) mb_free_blocks called multiple times on the same block

....

Same is true with inode bitmap also.

-aneesh
