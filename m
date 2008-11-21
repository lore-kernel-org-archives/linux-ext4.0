From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
 and mark_diskspace_used
Date: Fri, 21 Nov 2008 11:39:44 -0600
Message-ID: <4926F260.4040109@redhat.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926EE3C.7050207@redhat.com> <20081121173135.GF11212@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbYKURkJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2008 12:40:09 -0500
In-Reply-To: <20081121173135.GF11212@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Nov 21, 2008 at 11:22:04AM -0600, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> We need to make sure we update the block bitmap and clear
>>> EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held. We look
>>> at EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each
>>> time in ext4_read_block_bitmap (introduced by
>>> c806e68f5647109350ec546fee5b526962970fd2 )
>> Can you add details about the failure mode(s) of this race, so people
>> (i.e. me) have an idea which bugs they've seen that it might address?
>>
> 
> ext4_read_block_bitmap does
> 
> 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
> 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> 		ext4_init_block_bitmap(sb, bh, block_group, desc);
> 
> the above ext4_init_block_bitmap actually zero out the block bitmap.
> 
> Now on the block allocation side we do
> 
> 	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
> 				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
> 
> 	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
> 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
> 
> ie on allocation we update the bitmap then we take the sb_bgl_lock
> and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
> parallel ext4_read_block_bitmap can zero out the bitmap in between
> the above mb_set_bits and spin_lock(sb_bg_lock..)
> 
> Result of this race is
> a) blocks getting allocated multiple times
> b) File corruption because two files have same blocks allocated
> c) mb_free_blocks called multiple times on the same block

Thanks -

And do any of these cases lead to BUG(), WARNING(), ext3_error(), etc
messages that people may one day google for?

-Eric
