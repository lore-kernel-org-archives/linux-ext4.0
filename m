From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Group meta-data blocks together.
Date: Wed, 30 Apr 2008 15:37:42 +0530
Message-ID: <20080430100742.GD7791@skywalker>
References: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <481782D7.9050102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49293 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbYD3KTg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Apr 2008 06:19:36 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id m3UANMPp122718
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 20:23:22 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3UAAWdG680058
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 20:10:40 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3UAAdo5002357
	for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2008 20:10:39 +1000
Content-Disposition: inline
In-Reply-To: <481782D7.9050102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 29, 2008 at 03:19:35PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > Hi Eric,
> > 
> > I haven't yet tested this. Let me know what you think.
> > 
> > -aneesh
> 
> I'll look over it when I get a chance; I did do a quick test with my RM
> scenario, and it came in about 1s faster than stock (5s vs. 6s)  :)
> 
> http://people.redhat.com/esandeen/rm_test/ext4_aneesh_rm.png

I did minimal testing. The layout of the meta-data blocks using the
patch is marked below. So the patch actually cluster the meta-data
blocks together. In the patch I am preallocating some blocks which
are used for the subsequent meta-block request. Number of blocks preallocated
is determined by

static void
ext4_mb_normalize_meta_data_request(struct ext4_allocation_context *ac)
{
	/*
	 * Need to find what the right nomalized block num should be
	 */
	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
	if (i_size_read(ac->ac_inode) >= sbi->s_mb_stream_request) {
		/* large inode which is using inode prealloc */
		ac->ac_g_ex.fe_len = 10;
	} else {
		ac->ac_g_ex.fe_len = 2;
	}
	mb_debug("#%u: goal %lu blocks for meta-data group\n",
			current->pid, ac->ac_g_ex.fe_len);
}

ie, for large files for which we are using inode preallocation I am 
preallocating 10 blocks and for small files 2 blocks. The output also
shows that when we are trying to allocate a new preallocation space
we try to place the window closer to the data block.

extent: lblk 0--335871, len 335872, pblk 45482, flags: 2ND_VISIT
tst_extents:  ns
(Left 41)
extent: lblk 335872--679935, len 344064, pblk 45483, flags: (none)
tst_extents:  ns
(Left 40)
extent: lblk 679936--1023999, len 344064, pblk 45484, flags: (none)
tst_extents:  ns
(Left 39)
extent: lblk 1024000--1368063, len 344064, pblk 45485, flags: (none)
tst_extents:  ns
(Left 38)
extent: lblk 1368064--1712127, len 344064, pblk 45487, flags: (none)
tst_extents:  ns
(Left 37)
extent: lblk 1712128--2056191, len 344064, pblk 45488, flags: (none)
tst_extents:  ns
(Left 36)
extent: lblk 2056192--2400255, len 344064, pblk 45489, flags: (none)
tst_extents:  ns
(Left 35)
extent: lblk 2400256--2744319, len 344064, pblk 45490, flags: (none)
tst_extents:  ns
(Left 34)
extent: lblk 2744320--3088383, len 344064, pblk 45491, flags: (none)
tst_extents:  ns
(Left 33)
extent: lblk 3088384--3432447, len 344064, pblk 6205571, flags: (none)
tst_extents:  ns
(Left 32)
extent: lblk 3432448--3776511, len 344064, pblk 6205572, flags: (none)
tst_extents:  ns
(Left 31)
extent: lblk 3776512--4120575, len 344064, pblk 6205573, flags: (none)
tst_extents:  ns
(Left 30)
extent: lblk 4120576--4464639, len 344064, pblk 6205574, flags: (none)
tst_extents:  ns
(Left 29)
extent: lblk 4464640--4808703, len 344064, pblk 6205575, flags: (none)
tst_extents:  ns
(Left 28)
extent: lblk 4808704--5013373, len 204670, pblk 6205576, flags: (none)
tst_extents:  ns
(Left 27)
extent: lblk 5013374--5185405, len 172032, pblk 6205577, flags: (none)
tst_extents:  ns
(Left 26)
extent: lblk 5185406--5357437, len 172032, pblk 6205578, flags: (none)
tst_extents:  ns
(Left 25)
extent: lblk 5357438--5529469, len 172032, pblk 6205579, flags: (none)
tst_extents:  ns
(Left 24)
extent: lblk 5529470--5701501, len 172032, pblk 6205580, flags: (none)
tst_extents:  ns
(Left 23)
extent: lblk 5701502--5873533, len 172032, pblk 3371269, flags: (none)
tst_extents:  ns
(Left 22)
extent: lblk 5873534--6045565, len 172032, pblk 3371270, flags: (none)
tst_extents:  ns
(Left 21)
extent: lblk 6045566--6217597, len 172032, pblk 3371271, flags: (none)
tst_extents:  ns
(Left 20)
extent: lblk 6217598--6389629, len 172032, pblk 3371272, flags: (none)
tst_extents:  ns
(Left 19)
extent: lblk 6389630--6561661, len 172032, pblk 3371273, flags: (none)
tst_extents:  ns
(Left 18)
extent: lblk 6561662--6733693, len 172032, pblk 3371274, flags: (none)
tst_extents:  ns
(Left 17)
extent: lblk 6733694--6905725, len 172032, pblk 3371275, flags: (none)
tst_extents:  ns
(Left 16)
extent: lblk 6905726--7077757, len 172032, pblk 3371276, flags: (none)
tst_extents:  ns
(Left 15)
extent: lblk 7077758--7249789, len 172032, pblk 3371277, flags: (none)
tst_extents:  ns
(Left 14)
extent: lblk 7249790--7421691, len 171902, pblk 3371278, flags: (none)
tst_extents:  ns
(Left 13)
extent: lblk 7421692--7593723, len 172032, pblk 1094153, flags: (none)
tst_extents:  ns

The meta-data block 1094153 is closer to data block 1093893,

tst_extents:  nl
(Left 13)
<<<< OP = down
header: magic=f30a entries=84 max=84 depth=0 generation=0
Down to level 2/2, end_blk=7593724
(Left 83)
extent: lblk 7421692--7421951, len 260, pblk 1093893, flags: LEAF 

Eric,

For the test you ran, If we update the preallocation window may be
we will have better numbers. Can you try with different values in
ext4_mb_normalize_meta_data_request ?

-aneesh


