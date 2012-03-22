From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ext4: Remove restrictive checks for EOFBLOCKS_FL
Date: Wed, 21 Mar 2012 17:10:58 -0700
Message-ID: <4F6A6E12.7050505@linux.vnet.ibm.com>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37943 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964866Ab2CVALG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 20:11:06 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 21 Mar 2012 20:11:05 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 3487E6E804D
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2012 20:11:03 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2M0B1FT3055864
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2012 20:11:02 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2M0B1pe019566
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2012 20:11:01 -0400
In-Reply-To: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/21/2012 12:23 AM, Lukas Czerner wrote:
> We are going to remove the EOFBLOCKS_FL flag in the future, so this is
> the first part of the removal. We can not remove it entirely just now,
> since the e2fsck is still checking for it and it might cause headache to
> some people. Instead, remove the restrictive checks now and the rest
> later, when the new e2fsck code is out and common enough.
>
> This is also needed because punch hole already breaks the EOFBLOCKS_FL
> semantics, so it might cause the some troubles. So simply remove it.
>
> Signed-off-by: Lukas Czerner<lczerner@redhat.com>

Alrighty, I went over your set and it all looks good to me.  Thx Lukas!

Allison Henderson

> ---
>   fs/ext4/extents.c |   13 ++++++++-----
>   fs/ext4/inode.c   |    6 ++----
>   2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 9e10b82..06b0792 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3291,11 +3291,13 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
>   	depth = ext_depth(inode);
>   	eh = path[depth].p_hdr;
>
> -	if (unlikely(!eh->eh_entries)) {
> -		EXT4_ERROR_INODE(inode, "eh->eh_entries == 0 and "
> -				 "EOFBLOCKS_FL set");
> -		return -EIO;
> -	}
> +	/*
> +	 * We're going to remove EOFBLOCKS_FL entirely in future so we
> +	 * do not care for this case anymore. Simply remove the flag
> +	 * if there are no extents.
> +	 */
> +	if (unlikely(!eh->eh_entries))
> +		goto out;
>   	last_ex = EXT_LAST_EXTENT(eh);
>   	/*
>   	 * We should clear the EOFBLOCKS_FL flag if we are writing the
> @@ -3319,6 +3321,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
>   	for (i = depth-1; i>= 0; i--)
>   		if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
>   			return 0;
> +out:
>   	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
>   	return ext4_mark_inode_dirty(handle, inode);
>   }
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..55f5b91 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4152,11 +4152,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>   	}
>
>   	if (attr->ia_valid&  ATTR_SIZE) {
> -		if (attr->ia_size != i_size_read(inode)) {
> +		if (attr->ia_size != i_size_read(inode))
>   			truncate_setsize(inode, attr->ia_size);
> -			ext4_truncate(inode);
> -		} else if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
> -			ext4_truncate(inode);
> +		ext4_truncate(inode);
>   	}
>
>   	if (!rc) {

