From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: When reading from fallocated blocks make sure we
	return zero.
Date: Fri, 15 Feb 2008 11:43:04 -0800
Message-ID: <1203104584.3598.4.camel@localhost.localdomain>
References: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49636 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759119AbYBOTn0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 14:43:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1FJhHWA002660
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:43:17 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1FJh79X223354
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:43:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1FJh6Qr010038
	for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2008 14:43:06 -0500
In-Reply-To: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-02-15 at 23:46 +0530, Aneesh Kumar K.V wrote:
> fallocate blocks are considered as sparse area and read from them should
> return zero. ext4_ext_get_blocks should return zero for read request.
> 

The patch itself looks harmless, but I still don't see how this could
fix the problem you described at irc: a write hit a BUG_ON() in
fs/buffer.c saying the buffer is not mapped. Could you add more details
here?

Thanks
Mingming
 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3efbfd1..5b22f71 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2379,8 +2379,14 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  			}
>  			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
>  				goto out;
> -			if (!create)
> +			if (!create) {
> +				/*
> +				 * read request should return zero blocks
> +				 * allocated
> +				 */
> +				allocated = 0;
>  				goto out2;
> +			}
> 
>  			ret = ext4_ext_convert_to_initialized(handle, inode,
>  								path, iblock,
