From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching
 holes
Date: Wed, 29 Feb 2012 08:44:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab2B2Hok (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 02:44:40 -0500
In-Reply-To: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 29 Feb 2012, Allison Henderson wrote:

> When punching holes, it is possible that all the entries of an
> index block may be removed.  These empty index blocks need to
> be removed once punch hole completes.  This patch adds some extra
> logic to the punch hole code to remove empty index blocks.

Hi Allison,

I have not looked at the patch, but just to let you know. I am working
on a patch to reorganize the punch hole support a bit in order to fix
a bug I found but more importantly to make it faster, better
understandable and to reuse more of an existing code paths.

I am cleaning up the patches and testing them right now, so hopefully by
the end of the week I'll send those out.

Thanks!
-Lukas

> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> :100644 100644 ad39627... 6bb2f55... M	fs/ext4/extents.c
>  fs/ext4/extents.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad39627..6bb2f55 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3709,7 +3709,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	struct ext4_extent newex, *ex, *ex2;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	ext4_fsblk_t newblock = 0;
> -	int free_on_err = 0, err = 0, depth, ret;
> +	int free_on_err = 0, err = 0, depth, ret, i;
>  	unsigned int allocated = 0, offset = 0;
>  	unsigned int allocated_clusters = 0, reserved_clusters = 0;
>  	unsigned int punched_out = 0;
> @@ -3880,6 +3880,21 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			err = ext4_ext_rm_leaf(handle, inode, path,
>  					       &partial_cluster, map->m_lblk,
>  					       map->m_lblk + punched_out);
> +			if (err)
> +				goto out2;
> +
> +			/*
> +			 * Walk back up the path and remove
> +			 * empty index blocks
> +			 */
> +			for (i = depth - 1; i > 0; i--) {
> +				if (path[i].p_hdr->eh_entries == 0) {
> +					err = ext4_ext_rm_idx(handle, inode,
> +								path + i);
> +					if (err)
> +						goto out2;
> +				}
> +			}
>  
>  			if (!err && path->p_hdr->eh_entries == 0) {
>  				/*
> 

-- 
