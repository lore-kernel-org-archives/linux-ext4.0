From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/6 v7] ext4: Lock i_mutex for punch hole
Date: Tue, 30 Aug 2011 18:31:40 -0600
Message-ID: <7607E9C9-650E-4C7F-B5EA-1DD76E564C05@dilger.ca>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com> <1314750513-10045-5-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46552 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1HaAbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 20:31:41 -0400
In-Reply-To: <1314750513-10045-5-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-30, at 6:28 PM, Allison Henderson wrote:
> This patch modifies the fallocate routine to lock i_mutex during
> the punch hole operation.
> 
> Yongqiang noticed that the vfs layer locks i_mutex for truncate,
> but not fallocate, so the fallocate routine will need to take
> care of locking i_mutex.  Otherwise a page may be mapped after
> punch hole has released the pages, but before i_data_sem is
> locked to release the blocks in the extent tree.

If the VFS is locking i_mutex for truncate, shouldn't the locking for
fallocate() also be done in the VFS?

> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> :100644 100644 9124cd2... 007fb08... M	fs/ext4/extents.c
> fs/ext4/extents.c |   10 +++++++---
> 1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 9124cd2..007fb08 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3774,8 +3774,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> 		return -EOPNOTSUPP;
> 
> -	if (mode & FALLOC_FL_PUNCH_HOLE)
> -		return ext4_punch_hole(file, offset, len);
> +	mutex_lock(&inode->i_mutex);
> +
> +	if (mode & FALLOC_FL_PUNCH_HOLE) {
> +		ret = ext4_punch_hole(file, offset, len);
> +		mutex_unlock(&inode->i_mutex);
> +		return ret;	
> +	}
> 
> 	trace_ext4_fallocate_enter(inode, offset, len, mode);
> 	map.m_lblk = offset >> blkbits;
> @@ -3789,7 +3794,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> 	 * credits to insert 1 extent into extent tree
> 	 */
> 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
> -	mutex_lock(&inode->i_mutex);
> 	ret = inode_newsize_ok(inode, (len + offset));
> 	if (ret) {
> 		mutex_unlock(&inode->i_mutex);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





