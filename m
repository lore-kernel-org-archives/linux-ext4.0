From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Tue, 19 Feb 2008 11:15:04 -0600
Message-ID: <47BB0E98.7090905@redhat.com>
References: <47B9F1F1.30604@redhat.com> <47BB0658.90204@redhat.com> <20080219164944.GB7177@skywalker> <20080219170512.GC7177@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYBSRW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 12:22:26 -0500
In-Reply-To: <20080219170512.GC7177@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:

>> How about enabling it only for directory and regular files rather than
>> enabling it globally and then disabling the flag for  symlink and device
>> files ?
>>
> 
> how about something like below. There are two reason for not inheriting
> the i_flag from directory.

Looks about right to me... see below

> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index d2c2e55..f430939 100644
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
> +	 * specfied
 nitpick:  ^^^^ typo

> +	 */
> +	ei->i_flags = EXT4_I(dir)->i_flags & ~ (EXT4_INDEX_FL|EXT4_EXTENTS_FL);
>  	if (S_ISLNK(mode))
>  		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
>  	/* dirsync only applies to directories */
> @@ -836,8 +841,10 @@ got:
>  		ext4_std_error(sb, err);
>  		goto fail_free_drop;
>  	}
> -	if (test_opt(sb, EXTENTS) && !S_ISLNK(mode)) {
> -		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
> +	if (test_opt(sb, EXTENTS)) {
> +		/* set extent flag only for diretory and file */
> +		if (S_ISDIR(mode) || S_ISREG(mode))
> +			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
>  		ext4_ext_tree_init(handle, inode);
>  		err = ext4_update_incompat_feature(handle, sb,
>  						EXT4_FEATURE_INCOMPAT_EXTENTS);

Hm you only set the extents flag for dir & reg, but you call the next
two functions for all files?  I think the next 2 lines need to be part
of the conditional, no? (and then there can be just one big test,
indentation can come out a bit...?)

But, the spirit of the patch looks right.

-Eric



> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 23902ba..da942bc 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1771,7 +1771,6 @@ retry:
>  #ifdef CONFIG_EXT4DEV_FS_XATTR
>  		inode->i_op = &ext4_special_inode_operations;
>  #endif
> -		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>  		err = ext4_add_nondir(handle, dentry, inode);
>  	}
>  	ext4_journal_stop(handle);
