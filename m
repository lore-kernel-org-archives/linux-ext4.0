From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Mon, 2 Jun 2008 14:29:48 +0530
Message-ID: <20080602085948.GC29995@skywalker>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602000842.GA24339@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	alex@clusterfs.com, adilger@sun.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46309 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211AbYFBJAE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 05:00:04 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m528xnvT028902
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:29:49 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m528xZLK1151084
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:29:35 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m528xmeY025050
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:29:49 +0530
Content-Disposition: inline
In-Reply-To: <20080602000842.GA24339@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 08:08:42PM -0400, Theodore Tso wrote:
> On Thu, May 15, 2008 at 12:17:11AM +0530, Aneesh Kumar K.V wrote:
> > @@ -3134,8 +3135,7 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
> >  static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
> >  				struct ext4_prealloc_space *pa)
> >  {
> > -	unsigned len = ac->ac_o_ex.fe_len;
> > -
> > +	unsigned int len = ac->ac_o_ex.fe_len;
> >  	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
> >  					&ac->ac_b_ex.fe_group,
> >  					&ac->ac_b_ex.fe_start);
> > -- 
> 
> This change had nothing to do with fixing the use of unitialized data,
> but when I started looking more closely, it raised a potential signed
> vs. unsigned issue: ac_o_ex is a struct ext4_free_extent, and fe_len
> is an int.
> 
> So here we are assigning an int to an unsigned int.  Later, len is
> assigned to ac_b_ex.len, which means assigning an unsigned int to an
> int.  In other places, fe_len (an int) is compared against pa_free
> (which is an unsigned short), and fe_len gets assined to pa_free, once
> again mixing signed and unsigned.
> 
> Can someone who is really familiar with this code check this out?  I
> think the following pseudo-patch to mballoc.h might be in order:
> 
>  struct ext4_free_extent {
>  	ext4_lblk_t fe_logical;
>  	ext4_grpblk_t fe_start;
>  	ext4_group_t fe_group;
> -	int fe_len;
> +	unsigned int fe_len;
>  };
> 

Looks correct. We have some BUG_ON that is doing fe_len <= 0. May be we
need to remove  the < part.

-aneesh
