From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in
	each transaction.
Date: Fri, 07 Mar 2008 03:30:57 -0800
Message-ID: <1204889457.3627.43.camel@localhost.localdomain>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52264 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbYCGLbh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 06:31:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m27BVWo0006660
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 06:31:32 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27BVWXg163354
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 04:31:32 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27BVVq0023313
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 04:31:32 -0700
In-Reply-To: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-07 at 16:23 +0530, Aneesh Kumar K.V wrote:
> ext4_fallocate need to update file size in each transaction. Otherwise
> ife we crash the file size won't be updated. We were also not marking
> the inode dirty after updating file size before. Also when we try to
> retry allocation due to ENOSPC make sure we reset the variable ret so
> that we actually do a retry.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   78 +++++++++++++++++++++--------------------------------
>  1 files changed, 31 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index dcdf92a..09dd3c5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2783,6 +2783,26 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
>  	return needed;
>  }
> 
> +static void ext4_falloc_update_inode(struct inode *inode,
> +					int mode, loff_t new_size)
> +{
> +	struct timespec now;
> +
> +	now = current_fs_time(inode->i_sb);
> +	if (!timespec_equal(&inode->i_ctime, &now))
> +		inode->i_ctime = now;
> +	/*
> +	 * Update only when preallocation was requested beyond
> +	 * the file size.
> +	 */
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +				new_size > i_size_read(inode)) {
> +		i_size_write(inode, new_size);
> +		EXT4_I(inode)->i_disksize = i_size_read(inode);

Just a minor thing, we could store new_size directly to i_disksize to
avoid calling the i_size_read() instead.


> +	}
> +
> +}
> +
>  /*
>   * preallocate space for a file. This implements ext4's fallocate inode
>   * operation, which gets called from sys_fallocate system call.
> @@ -2794,8 +2814,8 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  {
>  	handle_t *handle;
>  	ext4_lblk_t block;
> +	loff_t new_size;
>  	unsigned long max_blocks;
> -	ext4_fsblk_t nblocks = 0;
>  	int ret = 0;
>  	int ret2 = 0;
>  	int retries = 0;
> @@ -2814,8 +2834,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  		return -ENODEV;
> 
>  	block = offset >> blkbits;
> -	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> -			- block;
> +	max_blocks = EXT4_BLOCK_ALIGN(len, blkbits) >> blkbits;
> 

Not sure about this change... Other than this looks fine to me

MIngming


