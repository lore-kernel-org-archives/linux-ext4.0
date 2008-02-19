From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: Don't mark the filesystem with errors if we
	fail to fallocate.
Date: Mon, 18 Feb 2008 21:24:43 -0800
Message-ID: <1203398683.3612.9.camel@localhost.localdomain>
References: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1203392640-14335-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45086 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYBSFYq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 00:24:46 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J5OkNr001413
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:46 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J5Okx0248056
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:46 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J5OjS5021086
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:46 -0500
In-Reply-To: <1203392640-14335-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-02-19 at 09:14 +0530, Aneesh Kumar K.V wrote:
> IF we fail allocate blocks don't call ext4_error. Also don't hide errors
> from ext4_get_blocks_wrap
> 
Aced. And added to patch queue.

Thanks,
Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5b22f71..9a27e88 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2653,13 +2653,14 @@ retry:
>  		ret = ext4_get_blocks_wrap(handle, inode, block,
>  					  max_blocks, &map_bh,
>  					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
> -		WARN_ON(ret <= 0);
>  		if (ret <= 0) {
> -			ext4_error(inode->i_sb, "ext4_fallocate",
> -				    "ext4_ext_get_blocks returned error: "
> -				    "inode#%lu, block=%u, max_blocks=%lu",
> +#ifdef EXT4FS_DEBUG
> +			WARN_ON(ret <= 0);
> +			printk(KERN_ERR "%s: ext4_ext_get_blocks "
> +				    "returned error inode#%lu, block=%u, "
> +				    "max_blocks=%lu", __FUNCTION__,
>  				    inode->i_ino, block, max_blocks);
> -			ret = -EIO;
> +#endif
>  			ext4_mark_inode_dirty(handle, inode);
>  			ret2 = ext4_journal_stop(handle);
>  			break;
