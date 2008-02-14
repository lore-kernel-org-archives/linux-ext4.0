From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC/PATCH] ext4: Fix the memory leak and buffer head leak
	with respect to ext4_ext_path
Date: Thu, 14 Feb 2008 15:21:01 -0800
Message-ID: <1203031261.3637.46.camel@localhost.localdomain>
References: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43545 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbYBNXV2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 18:21:28 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1ENL3n3032352
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:21:03 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1ENL3Ti281910
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:21:03 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1ENL3MT026911
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:21:03 -0500
In-Reply-To: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added in ext4 patch queue,
Thanks

On Thu, 2008-02-14 at 16:00 +0530, Aneesh Kumar K.V wrote:
> The path variable returned via ext4_ext_find_extent is a kmalloc variable
> and need to be freeded. It also contain refrences to buffer_head which need
> to be dropped.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c               |    6 +++---
>  fs/ext4/migrate.c               |    5 +++++
>  include/linux/ext4_fs_extents.h |    1 +
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e856f66..995ac16 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -349,7 +349,7 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
>  #define ext4_ext_show_leaf(inode,path)
>  #endif
> 
> -static void ext4_ext_drop_refs(struct ext4_ext_path *path)
> +void ext4_ext_drop_refs(struct ext4_ext_path *path)
>  {
>  	int depth = path->p_depth;
>  	int i;
> @@ -2200,10 +2200,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		newdepth = ext_depth(inode);
>  		if (newdepth != depth) {
>  			depth = newdepth;
> -			path = ext4_ext_find_extent(inode, iblock, NULL);
> +			ext4_ext_drop_refs(path);
> +			path = ext4_ext_find_extent(inode, iblock, path);
>  			if (IS_ERR(path)) {
>  				err = PTR_ERR(path);
> -				path = NULL;
>  				goto out;
>  			}
>  			eh = path[depth].p_hdr;
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 8c6c685..5c1e27d 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -43,6 +43,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
> 
>  	if (IS_ERR(path)) {
>  		retval = PTR_ERR(path);
> +		path = NULL;
>  		goto err_out;
>  	}
> 
> @@ -74,6 +75,10 @@ static int finish_range(handle_t *handle, struct inode *inode,
>  	}
>  	retval = ext4_ext_insert_extent(handle, inode, path, &newext);
>  err_out:
> +	if (path) {
> +		ext4_ext_drop_refs(path);
> +		kfree(path);
> +	}
>  	lb->first_pblock = 0;
>  	return retval;
>  }
> diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
> index 697da4b..1285c58 100644
> --- a/include/linux/ext4_fs_extents.h
> +++ b/include/linux/ext4_fs_extents.h
> @@ -227,5 +227,6 @@ extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
>  						ext4_lblk_t *, ext4_fsblk_t *);
>  extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
>  						ext4_lblk_t *, ext4_fsblk_t *);
> +extern void ext4_ext_drop_refs(struct ext4_ext_path *);
>  #endif /* _LINUX_EXT4_EXTENTS */
> 
