From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
 ext4_mb_regular_allocator()
Date: Wed, 24 Mar 2010 22:53:23 +0530
Message-ID: <878w9hd46s.fsf@linux.vnet.ibm.com>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
	<20100322182645.GI11560@thunk.org>
	<ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41049 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0CXRX2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 13:23:28 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp08.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2OGYXnF003646
	for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 22:04:33 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OHNQwb3149940
	for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 22:53:26 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2OHNQKU012812
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:23:26 +1100
In-Reply-To: <ac8f92701003230540w5a788ec1s54737e2e38c90e11@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 23 Mar 2010 20:40:29 +0800, jing zhang <zj.barak@gmail.com> wrote:
> 2010/3/23, tytso@mit.edu <tytso@mit.edu>:
> > On Mon, Mar 22, 2010 at 10:35:54PM +0800, jing zhang wrote:
> >> From: Jing Zhang <zj.barak@gmail.com>
> >>
> >> Date: Mon Mar 22 22:20:38     2010
> >>
> >> 1, In one of the hot functions in mballoc.c, unnecessary operation on
> >>        struct ext4_group_desc *desc;
> >>     is removed.
> 
> ---
> 
> diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc5.c
> index bba1282..fb18199 100644
> --- a/linux-2.6.32/fs/ext4/mballoc.c
> +++ b/ext4_mm_leak/mballoc5.c
> @@ -2027,7 +2027,6 @@ repeat:
> 
>  		for (i = 0; i < ngroups; group++, i++) {
>  			struct ext4_group_info *grp;
> -			struct ext4_group_desc *desc;
> 
>  			if (group == ngroups)
>  				group = 0;
> @@ -2050,7 +2049,6 @@ repeat:
>  			}
> 
>  			ac->ac_groups_scanned++;
> -			desc = ext4_get_group_desc(sb, group, NULL);
>  			if (cr == 0)
>  				ext4_mb_simple_scan_group(ac, &e4b);
>  			else if (cr == 1 &&
> 


We missed that in commit 75507efb1372b6acf1aa6bf00ebd49ce196fd994
ealier we had an uninit check around that. 


-aneesh
