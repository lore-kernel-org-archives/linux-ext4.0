From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Fri, 04 Sep 2009 13:57:47 +0530
Message-ID: <4AA0CF83.8060405@in.ibm.com>
References: <4A9F7B48.9010903@in.ibm.com> <20090903112003.GA13105@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:33955 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbZIDI1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 04:27:47 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id n848Rmcn023250
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 13:57:48 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n848RmmV630900
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 13:57:48 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n848Rlvg027370
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:27:48 +1000
In-Reply-To: <20090903112003.GA13105@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Can you try this patch ?
>   
Thanks for the patch Aneesh.

I have executed the tests several times against this patch 
and haven't seen this issue. So at this point the patch looks good.

Tested-by : Sachin Sant <sachinp@in.ibm.com>

Will execute the tests few times more just to be doubly sure about this.

Thanks
-Sachin

> commit 43149bc800a6ae88b7d984558403e8d8cb045138
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Thu Sep 3 16:47:27 2009 +0530
>
>     ext4: check for good group with alloc_sem held
>     
>     We need to make sure we check for good group with alloc_sem
>     held to make sure we prevent a parallel addition of new blocks
>     to the group via resize.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index cd25846..4623555 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2029,13 +2029,6 @@ repeat:
>  					goto out;
>  			}
>
> -			/*
> -			 * If the particular group doesn't satisfy our
> -			 * criteria we continue with the next group
> -			 */
> -			if (!ext4_mb_good_group(ac, group, cr))
> -				continue;
> -
>  			err = ext4_mb_load_buddy(sb, group, &e4b);
>  			if (err)
>  				goto out;
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

