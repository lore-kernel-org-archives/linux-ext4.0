From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Return unwritten buffer head when trying to
	read from prealloc space.
Date: Fri, 21 Mar 2008 15:13:58 -0700
Message-ID: <1206137638.3605.36.camel@localhost.localdomain>
References: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1206080337-8732-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, Solofo.Ramangalahy@bull.net,
	dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56590 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYCUWOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 18:14:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2LME2ZU017945
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:14:02 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2LME2WV241742
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:14:02 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2LME1vf022923
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:14:01 -0400
In-Reply-To: <1206080337-8732-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-21 at 11:48 +0530, Aneesh Kumar K.V wrote:
> ext4_ext_get_blocks  returns number of blocks allocated with buffer head
> unmapped for a read from prealloc space. This is needed so that delayed
> allocation doesn't do block reservation for prealloc space since the blocks
> are already resevred on disk. Fix ext4_ext_get_blocks to not return greater
> than max_blocks and also mark the buffer head unwritten. Some code path tries
> to read the block if buffer_head is not new and no uptodate. Marking the buffer
> head unwritten avoid this reading.
> 

Seems this patch fixes two bugs together, it would be nice to split to
two as they cause two different problems.

To fix the bh->b_size warning solof founds for delayed allocation, I
would say we need to fix it in ext4_get_blocks_handle() (for indirect
files) and ext4_ext_get_blocks()(for extent files) both, not allowing
returning b_size greater than what the caller asking for. Also, the
patch below seems only address the preallocation map case, we need to
fix in in general block lookup case.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d6ae40a..edd1bf2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2600,8 +2600,20 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  			}
>  			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
>  				goto out;
> -			if (!create)
> +			if (!create) {
> +				/*
> +				 * We have blocks reserved already. We
> +				 * return allocated blocks so that delalloc
> +				 * won't do block reservation for us. But
> +				 * the buffer head will be unmapped so that
> +				 * a read from the block return 0
> +				 */
> +				if (allocated > max_blocks)
> +					allocated = max_blocks;
> +				/* mark the buffer unwritten */
> +				__set_bit(BH_Unwritten, &bh_result->b_state);
>  				goto out2;
> +			}
> 
>  			ret = ext4_ext_convert_to_initialized(handle, inode,
>  								path, iblock,

