From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: set EXT4_EXTENTS_FL only for directory and regular
 files
Date: Tue, 19 Feb 2008 14:03:53 -0600
Message-ID: <47BB3629.1030205@redhat.com>
References: <1203450545-9938-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbYBSUFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 15:05:01 -0500
In-Reply-To: <1203450545-9938-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Also don't inherit EXT4_EXTENTS_FL from parent directory.
> If we have a directory with extent flag set and later mount the file
> system with -o noextents, the files created in that directory will also
> have extent flag set but we would not have called ext4_ext_tree_init for
> them. This will cause error later when we are verifying the extent header
> 
> Also we don't want to set extent flag for symlinks, char, block, fifo
> or socket

Minor typo in comments, "diretory," but otherwise:

Acked-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/ialloc.c |   22 +++++++++++++++-------
>  fs/ext4/namei.c  |    1 -
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 028e601..78d1094 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -794,7 +794,12 @@ got:
>  	ei->i_dir_start_lookup = 0;
>  	ei->i_disksize = 0;
>  
> -	ei->i_flags = EXT4_I(dir)->i_flags & ~EXT4_INDEX_FL;
> +	/*
> +	 * Don't inherit extent flag from directory. We set extent flag on
> +	 * newly created directory and file only if -o extent mount option is
> +	 * specified
> +	 */
> +	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
>  	if (S_ISLNK(mode))
>  		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
>  	/* dirsync only applies to directories */
> @@ -837,12 +842,15 @@ got:
>  		goto fail_free_drop;
>  	}
>  	if (test_opt(sb, EXTENTS)) {
> -		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
> -		ext4_ext_tree_init(handle, inode);
> -		err = ext4_update_incompat_feature(handle, sb,
> -						EXT4_FEATURE_INCOMPAT_EXTENTS);
> -		if (err)
> -			goto fail;
> +		/* set extent flag only for diretory and file */
> +		if (S_ISDIR(mode) || S_ISREG(mode)) {
> +			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
> +			ext4_ext_tree_init(handle, inode);
> +			err = ext4_update_incompat_feature(handle, sb,
> +					EXT4_FEATURE_INCOMPAT_EXTENTS);
> +			if (err)
> +				goto fail;
> +		}
>  	}
>  
>  	ext4_debug("allocating inode %lu\n", inode->i_ino);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 39d4af4..da942bc 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2225,7 +2225,6 @@ retry:
>  		inode->i_op = &ext4_fast_symlink_inode_operations;
>  		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
>  		inode->i_size = l-1;
> -		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>  	}
>  	EXT4_I(inode)->i_disksize = inode->i_size;
>  	err = ext4_add_nondir(handle, dentry, inode);
