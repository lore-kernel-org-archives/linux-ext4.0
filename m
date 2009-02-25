From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Fix discard of inode prealloc space with delayed allocation.
Date: Wed, 25 Feb 2009 19:57:52 +0300
Message-ID: <m3y6vusbcf.fsf@openvz.org>
References: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34405 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbZBYQ7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 11:59:37 -0500
In-Reply-To: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message of "Wed\, 25 Feb 2009 21\:52\:02 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> With delayed allocation we should not/cannot discard inode prealloc space
> during file close. We would still have dirty pages for which we haven't allocated
> blocks yet. With this fix after each get_blocks request we check whether we have
> zero reserved blocks and if yes and we don't have any writers on the file we
> discard inode prealloc space.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> ---
>  fs/ext4/file.c  |    9 ++++++++-
>  fs/ext4/inode.c |    6 ++++++
>  2 files changed, 14 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f731cb5..4e468e2 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -33,9 +33,16 @@
>   */
>  static int ext4_release_file(struct inode *inode, struct file *filp)
>  {
> +	int rsv_data_blocks;
> +
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +	rsv_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
Seems we have race condition here because at this point someone may:
1)open file
2)then perform some write activity => (i_reserved_data_blocks != 0)
3)close file => (inode->i_writecount == 1)

>  	/* if we are the last writer on the inode, drop the block reservation */
>  	if ((filp->f_mode & FMODE_WRITE) &&
> -			(atomic_read(&inode->i_writecount) == 1))
> +			(atomic_read(&inode->i_writecount) == 1) &&
> +		        !rsv_data_blocks)
>  	{
>  		down_write(&EXT4_I(inode)->i_data_sem);
After we have grabbed i_data_sem we are protected from get_block activity,
and may safely recheck i_reserved_data_blocks again here.
>  		ext4_discard_preallocations(inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 51cdd13..26dcec4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1038,6 +1038,12 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  	EXT4_I(inode)->i_reserved_data_blocks -= used;
>  
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +	/*
> +	 * If have done all the pending block allocation and if the
> +	 * we don't have any writer on the inode
> +	 */
No problem here because we are hold i_data_sem.
> +	if (!total && (atomic_read(&inode->i_writecount) == 0))
> +		ext4_discard_preallocations(inode);
>  }
>  
>  /*
