From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Mon, 2 Jun 2008 16:02:25 +0530
Message-ID: <20080602103225.GA12240@skywalker>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602000842.GA24339@mit.edu> <4843C52D.20400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, alex@clusterfs.com, adilger@sun.com
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37639 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYFBKco (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 06:32:44 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m52AWRaW005663
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:02:27 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m52AWCJ4807046
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:02:12 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m52AWP0U015851
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:02:26 +0530
Content-Disposition: inline
In-Reply-To: <4843C52D.20400@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 06:02:21PM +0800, Shen Feng wrote:
> 
> 
> Theodore Tso Wrote:
> > On Thu, May 15, 2008 at 12:17:11AM +0530, Aneesh Kumar K.V wrote:
> >> @@ -3134,8 +3135,7 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
> >>  static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
> >>  				struct ext4_prealloc_space *pa)
> >>  {
> >> -	unsigned len = ac->ac_o_ex.fe_len;
> >> -
> >> +	unsigned int len = ac->ac_o_ex.fe_len;
> >>  	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
> >>  					&ac->ac_b_ex.fe_group,
> >>  					&ac->ac_b_ex.fe_start);
> >> -- 
> > 
> > This change had nothing to do with fixing the use of unitialized data,
> > but when I started looking more closely, it raised a potential signed
> > vs. unsigned issue: ac_o_ex is a struct ext4_free_extent, and fe_len
> > is an int.
> > 
> > So here we are assigning an int to an unsigned int.  Later, len is
> > assigned to ac_b_ex.len, which means assigning an unsigned int to an
> > int.  In other places, fe_len (an int) is compared against pa_free
> > (which is an unsigned short), and fe_len gets assined to pa_free, once
> > again mixing signed and unsigned.
> > 
> > Can someone who is really familiar with this code check this out?  I
> > think the following pseudo-patch to mballoc.h might be in order:
> > 
> >  struct ext4_free_extent {
> >  	ext4_lblk_t fe_logical;
> >  	ext4_grpblk_t fe_start;
> >  	ext4_group_t fe_group;
> > -	int fe_len;
> > +	unsigned int fe_len;
> >  };
> > 
> 
> I'm studying the ext4 code these days.
> The data types always confuse me.
> 
> The length of a ext4_extent ee_len is define as unsigned short.
> 
> struct ext4_extent {
> 	__le32	ee_block;	/* first logical block extent covers */
> 	__le16	ee_len;		/* number of blocks covered by extent */
> 	__le16	ee_start_hi;	/* high 16 bits of physical block */
> 	__le32	ee_start_lo;	/* low 32 bits of physical block */
> };
> 
> So I think fe_len should also be defined as unsigned short.
> Is that right?

Extents and each prealloc space have at max 2**16 blocks. So the length
of both should be unsigned short. With respect to ext4_free_extent we
use fe_len to store the number of blocks requested for allocation.
( ext4_mb_initialize_context )

The allocated extent will definitely have <= 2**16. But the requested
number of blocks may not.

-aneesh
