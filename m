From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Tue, 03 Jun 2008 14:02:52 -0600
Message-ID: <20080603200252.GC2961@webber.adilger.int>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080602000842.GA24339@mit.edu> <4843C52D.20400@cn.fujitsu.com>
 <20080602103225.GA12240@skywalker> <48449705.1070101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org, alex@clusterfs.com
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48852 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYFCUDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 16:03:03 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m53K30iK018598
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 13:03:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1W00I01KMYUD00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Jun 2008 13:03:00 -0700 (PDT)
In-reply-to: <48449705.1070101@cn.fujitsu.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2008  08:57 +0800, Shen Feng wrote:
> Aneesh Kumar K.V Wrote:
> >> Theodore Tso Wrote:
> >>> Can someone who is really familiar with this code check this out?  I
> >>> think the following pseudo-patch to mballoc.h might be in order:
> >>>
> >>>  struct ext4_free_extent {
> >>>  	ext4_lblk_t fe_logical;
> >>>  	ext4_grpblk_t fe_start;
> >>>  	ext4_group_t fe_group;
> >>> -	int fe_len;
> >>> +	unsigned int fe_len;
> >>>  };
> >>>
> >> I'm studying the ext4 code these days.
> >> The data types always confuse me.
> >>
> >> The length of a ext4_extent ee_len is define as unsigned short.
> >>
> >> struct ext4_extent {
> >> 	__le32	ee_block;	/* first logical block extent covers */
> >> 	__le16	ee_len;		/* number of blocks covered by extent */
> >> 	__le16	ee_start_hi;	/* high 16 bits of physical block */
> >> 	__le32	ee_start_lo;	/* low 32 bits of physical block */
> >> };
> >>
> >> So I think fe_len should also be defined as unsigned short.
> >> Is that right?
> > 
> > Extents and each prealloc space have at max 2**16 blocks. So the length
> > of both should be unsigned short. With respect to ext4_free_extent we
> > use fe_len to store the number of blocks requested for allocation.
> > ( ext4_mb_initialize_context )

I agree that we _could_ use an unsigned short here, but this is not a
native type on some CPUs, and the use of an "int" is more optimal.
Making this an unsigned int (and removing BUG_ON()) is one way to do this.

> In ext4_mb_initialize_context, we have
> 
> 	/* just a dirty hack to filter too big requests  */
> 	if (len >= EXT4_BLOCKS_PER_GROUP(sb) - 10)
> 		len = EXT4_BLOCKS_PER_GROUP(sb) - 10;
> 
> This means that we cannot allocate blocks which is bigger then
> EXT4_BLOCKS_PER_GROUP(sb) - 10 ( max 2**16-10 ) with MBALLOC.
> But ext4_new_blocks_old can do that.

Once we have FLEX_BG in the mix, it should be possible to allocate
a full group worth of blocks at one time.  The "- 10" part was only
to take into account some small number of metadata blocks (bitmap,
inode tables, etc) but will actually hurt allocation with FLEX_BG.

> So ext4_new_blocks may be changed as
> 
> ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> 		ext4_fsblk_t goal, unsigned long *count, int *errp)
> {
> 	struct ext4_allocation_request ar;
> 	ext4_fsblk_t ret;
> 
> -	if (!test_opt(inode->i_sb, MBALLOC)) {
> +	if (!test_opt(inode->i_sb, MBALLOC) || 
> +		(*count >= EXT4_BLOCKS_PER_GROUP(inode->i_sb) - 10)) {
> 		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
> 		return ret;

In light of the above, I'd prefer if this is change to be:

	if (!test_opt(inode->i_sb, MBALLOC) || 
		(*count > EXT4_BLOCKS_PER_GROUP(inode->i_sb))) {
		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);

or much better would be to split the allocation into several BLOCKS_PER_GROUP
chunks and stick with mballoc, since we don't want to fall back to the slower
ext4_new_blocks_old() just when there are allocations that mballoc is best
suited for.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

