From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Mon, 2 Jun 2008 19:47:19 +0530
Message-ID: <20080602141719.GA20714@skywalker>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602000842.GA24339@mit.edu> <4843F8C0.7060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, alex@clusterfs.com, adilger@sun.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:56123 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbYFBOUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 10:20:54 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m52EHBc1007393
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 00:17:11 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m52EHOh72494582
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 00:17:24 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m52EHeuH011277
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 00:17:40 +1000
Content-Disposition: inline
In-Reply-To: <4843F8C0.7060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 08:42:24AM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
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
> 
> Hm, ok, so what's going on here:
> 
> ext4_mb_normalize_group_request()
> {
> ...
>         if (EXT4_SB(sb)->s_stripe)
>                 ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
>         else
>                 ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
> ...
> }
> 
> and that's a long:
> 
>         unsigned long s_mb_group_prealloc;
> 
> Oh, but that's only ever assigned as
> 
>         sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
> 
> which is
> 
> /*
>  * default group prealloc size 512 blocks
>  */
> #define MB_DEFAULT_GROUP_PREALLOC       512
> 
> 
> so it's fine... but why are we carrying around a field in the sbi to
> hold a constant that cannot be changed runtime?

We can tune that via MB_PROC_FOPS(group_prealloc);


-aneesh

