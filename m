From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC/PATCH] ext4: Request for journal write access early.
Date: Thu, 14 Feb 2008 10:46:37 -0800
Message-ID: <1203014797.3637.23.camel@localhost.localdomain>
References: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1202985052-15694-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41540 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbYBNSrF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 13:47:05 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1EIkdkA004438
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:46:39 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1EIkd1w311080
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:46:39 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1EIkcQF020155
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 13:46:39 -0500
In-Reply-To: <1202985052-15694-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-14 at 16:00 +0530, Aneesh Kumar K.V wrote:
> In ext4_ext_convert_to_initialized before we need to request for journal
> write access before we even modify the extent length.
> 
Acked.
Thanks
Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 995ac16..c4d6f19 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2168,6 +2168,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	newblock = iblock - ee_block + ext_pblock(ex);
>  	ex2 = ex;
> 
> +	err = ext4_ext_get_access(handle, inode, path + depth);
> +	if (err)
> +		goto out;
> +
>  	/* ex1: ee_block to iblock - 1 : uninitialized */
>  	if (iblock > ee_block) {
>  		ex1 = ex;
> @@ -2210,6 +2214,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			ex = path[depth].p_ext;
>  			if (ex2 != &newex)
>  				ex2 = ex;
> +
> +			err = ext4_ext_get_access(handle, inode, path + depth);
> +			if (err)
> +				goto out;
>  		}
>  		allocated = max_blocks;
>  	}
> @@ -2230,9 +2238,6 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	ex2->ee_len = cpu_to_le16(allocated);
>  	if (ex2 != ex)
>  		goto insert;
> -	err = ext4_ext_get_access(handle, inode, path + depth);
> -	if (err)
> -		goto out;
>  	/*
>  	 * New (initialized) extent starts from the first block
>  	 * in the current extent. i.e., ex2 == ex
