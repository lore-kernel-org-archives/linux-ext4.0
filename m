From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] don't set extents flag for _any_ symlinks
Date: Mon, 18 Feb 2008 21:22:56 -0800
Message-ID: <1203398576.3612.5.camel@localhost.localdomain>
References: <47BA0668.5020006@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42194 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYBSFXE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 00:23:04 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J5Mwaj017667
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:22:58 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J5MwCP156804
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 22:22:58 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J5MvQG024802
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 22:22:58 -0700
In-Reply-To: <47BA0668.5020006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, Added to patch queue
On Mon, 2008-02-18 at 16:27 -0600, Eric Sandeen wrote:
> As symlinks are limited to a single block anyway, and e2fsck
> doesn't expect to find it set, don't set the extents flag on 
> any type of symlinks at all: fast/in-inode, or the 
> external-block flavor.
> 
> There are a lot of filesystems out there by now w/ exent-style 
> symlink blocks though, so e2fsck should probably be able to 
> repair that at some point...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> 
> Index: linux-2.6.24/fs/ext4/namei.c
> ===================================================================
> --- linux-2.6.24.orig/fs/ext4/namei.c
> +++ linux-2.6.24/fs/ext4/namei.c
> @@ -2223,7 +2226,6 @@ retry:
>  		inode->i_op = &ext4_fast_symlink_inode_operations;
>  		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
>  		inode->i_size = l-1;
> -		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>  	}
>  	EXT4_I(inode)->i_disksize = inode->i_size;
>  	err = ext4_add_nondir(handle, dentry, inode);
> 
> Index: linux-2.6.24/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.24.orig/fs/ext4/ialloc.c
> +++ linux-2.6.24/fs/ext4/ialloc.c
> @@ -744,7 +744,7 @@ got:
>  		ext4_std_error(sb, err);
>  		goto fail_free_drop;
>  	}
> -	if (test_opt(sb, EXTENTS)) {
> +	if (test_opt(sb, EXTENTS) && !S_ISLNK(mode)) {
>  		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
>  		ext4_ext_tree_init(handle, inode);
>  		err = ext4_update_incompat_feature(handle, sb,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
