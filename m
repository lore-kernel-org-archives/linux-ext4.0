From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: group cache is added in
 ext4_mb_discard_preallocations()
Date: Wed, 31 Mar 2010 00:07:14 +0530
Message-ID: <87wrwty7tx.fsf@linux.vnet.ibm.com>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"zj.barak" <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40893 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0C3ShX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 14:37:23 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2UIY1i2015833
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:34:01 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2UIVDGe1151120
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:31:13 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2UIbKOH029694
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:37:21 +1100
In-Reply-To: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 30 Mar 2010 20:36:17 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Tue Mar 30 20:35:22     2010
> 
> With the added cache, better group locality may be earned when
> allocating blocks.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-13.c	2010-03-30 20:28:08.000000000 +0800
> @@ -4183,12 +4183,20 @@ static int ext4_mb_discard_preallocation
>  	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
>  	int ret;
>  	int freed = 0;
> +	static ext4_group_t grp_cache = 0;
> 
>  	trace_ext4_mb_discard_preallocations(sb, needed);
> -	for (i = 0; i < ngroups && needed > 0; i++) {
> -		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
> +	if (needed <= 0)
> +		return freed;
> +	for (i = 0; i < ngroups; i++) {
> +		if (grp_cache >= ngroups)
> +			grp_cache -= ngroups;
> +		ret = ext4_mb_discard_group_preallocations(sb, grp_cache, needed);
>  		freed += ret;
>  		needed -= ret;
> +		if (needed <= 0)
> +			break;
> +		grp_cache++;
>  	}
> 
>  	return freed;

can you explain this further ?

-aneesh
