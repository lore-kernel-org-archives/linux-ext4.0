From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V2] fix mballoc oopses on mkdir
Date: Wed, 29 Aug 2007 14:01:47 -0700
Message-ID: <1188421307.3799.32.camel@localhost.localdomain>
References: <46D39776.2090103@redhat.com> <46D3A390.5000202@redhat.com>
	 <46D3B1AE.40408@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36896 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXH2VBj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2007 17:01:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7TL2usC018198
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 17:02:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7TL1Xxu568690
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 17:01:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7TL1WKO003262
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 17:01:33 -0400
In-Reply-To: <46D3B1AE.40408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-08-28 at 00:25 -0500, Eric Sandeen wrote:
> Ugh. brain clearly not fully engaged... here we go:
> 
> ------------------
> 
> Tried out Ted's git tree + all pending patches today, and 
> immediately oopsed on a mkdir thanks to this in 
> ext4_mb_new_group_pa()
> 
> 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
> 
> (there are 54 BUGs and BUG_ONs in this file...!)
> 
> I think something like this patch is needed?
> 

Thanks for catching this and the fix.  I saw the same kernel oops today
when rum mballoc on fsstress (mkdir). I just added this fix to the patch
queue with some comments.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> 
> Index: ext4.git/fs/ext4/extents.c
> ===================================================================
> --- ext4.git.orig/fs/ext4/extents.c
> +++ ext4.git/fs/ext4/extents.c
> @@ -2535,7 +2535,10 @@ int ext4_ext_get_blocks(handle_t *handle
>  	ar.goal = ext4_ext_find_goal(inode, path, iblock);
>  	ar.logical = iblock;
>  	ar.len = allocated;
> -	ar.flags = EXT4_MB_HINT_DATA;
> +	if (S_ISREG(inode->i_mode))
> +		ar.flags = EXT4_MB_HINT_DATA;
> +	else
> +		ar.flags = 0;

I see. We set the flags to zero here to avoid doing in-core
preallocation for directory files later. 

Well, I am not sure whether it's worth the effort to support in-core
preallocation for directory files. But I don't see hard reason we cannot
do this. My understanding is: this is the new in-core preallocation
which does a should not depend on extents or any on-disk format changes.

Alex, any comments?


Mingming

>  	newblock = ext4_mb_new_blocks(handle, &ar, &err);
>  	if (!newblock)
>  		goto out2;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
