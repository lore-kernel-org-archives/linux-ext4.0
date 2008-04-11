From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/3] reinstate ext4_ext_walk_space()
Date: Fri, 11 Apr 2008 17:31:55 -0600
Message-ID: <20080411233155.GU5693@webber.adilger.int>
References: <47EA6DA9.4010103@redhat.com> <47EA6ED0.6050504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44500 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbYDKXb6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2008 19:31:58 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3BNVw37006711
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 16:31:58 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZ600H01P884R00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 11 Apr 2008 16:31:58 -0700 (PDT)
In-reply-to: <47EA6ED0.6050504@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 26, 2008  10:42 -0500, Eric Sandeen wrote:
> the ext4 fiemap call needs this helper function.
> 
> I need to dig for the original author to see what signed-off-by
> lines should be here.

This was originally written by Alex and was in the extents patches
but later removed.

> Index: linux-2.6.25-rc1/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.25-rc1.orig/fs/ext4/extents.c
> +++ linux-2.6.25-rc1/fs/ext4/extents.c
> @@ -1588,6 +1588,112 @@ cleanup:
>  	return err;
>  }
>  
> +int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> +			ext4_lblk_t num, ext_prepare_callback func,
> +			void *cbdata)
> +{
> +	struct ext4_ext_path *path = NULL;
> +	struct ext4_ext_cache cbex;
> +	struct ext4_extent *ex;
> +	ext4_lblk_t next, start = 0, end = 0;
> +	ext4_lblk_t last = block + num;
> +	int depth, exists, err = 0;
> +
> +	BUG_ON(func == NULL);
> +	BUG_ON(inode == NULL);
> +
> +	while (block < last && block != EXT_MAX_BLOCK) {
> +		num = last - block;
> +		/* find extent for this block */
> +		path = ext4_ext_find_extent(inode, block, path);
> +		if (IS_ERR(path)) {
> +			err = PTR_ERR(path);
> +			path = NULL;
> +			break;
> +		}
> +
> +		depth = ext_depth(inode);
> +		BUG_ON(path[depth].p_hdr == NULL);
> +		ex = path[depth].p_ext;
> +		next = ext4_ext_next_allocated_block(path);
> +
> +		exists = 0;
> +		if (!ex) {
> +			/* there is no extent yet, so try to allocate
> +			 * all requested space */
> +			start = block;
> +			end = block + num;
> +		} else if (le32_to_cpu(ex->ee_block) > block) {
> +			/* need to allocate space before found extent */
> +			start = block;
> +			end = le32_to_cpu(ex->ee_block);
> +			if (block + num < end)
> +				end = block + num;
> +		} else if (block >= le32_to_cpu(ex->ee_block)
> +					+ ext4_ext_get_actual_len(ex)) {
> +			/* need to allocate space after found extent */
> +			start = block;
> +			end = block + num;
> +			if (end >= next)
> +				end = next;
> +		} else if (block >= le32_to_cpu(ex->ee_block)) {
> +			/*
> +			 * some part of requested space is covered
> + 			 * by found extent
> + 			 */
> +			start = block;
> +			end = le32_to_cpu(ex->ee_block)
> +				+ ext4_ext_get_actual_len(ex);
> +			if (block + num < end)
> +				end = block + num;
> +			exists = 1;
> +		} else {
> +			BUG();
> +		}
> +		BUG_ON(end <= start);
> +
> +		if (!exists) {
> +			cbex.ec_block = start;
> +			cbex.ec_len = end - start;
> +			cbex.ec_start = 0;
> +			cbex.ec_type = EXT4_EXT_CACHE_GAP;
> +		} else {
> +			cbex.ec_block = le32_to_cpu(ex->ee_block);
> +			cbex.ec_len = ext4_ext_get_actual_len(ex);
> +			cbex.ec_start = ext_pblock(ex);
> +			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
> +		}
> +
> +		BUG_ON(cbex.ec_len == 0);
> +		err = func(inode, path, &cbex, cbdata);
> +		ext4_ext_drop_refs(path);
> +
> +		if (err < 0)
> +			break;
> +		if (err == EXT_REPEAT)
> +			continue;
> +		else if (err == EXT_BREAK) {
> +			err = 0;
> +			break;
> +		}
> +
> +		if (ext_depth(inode) != depth) {
> +			/* depth was changed. we have to realloc path */
> +			kfree(path);
> +			path = NULL;
> +		}
> +
> +		block = cbex.ec_block + cbex.ec_len;
> +	}
> +
> +	if (path) {
> +		ext4_ext_drop_refs(path);
> +		kfree(path);
> +	}
> +
> +	return err;
> +}
> +
>  static void
>  ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
>  			__u32 len, ext4_fsblk_t start, int type)
> Index: linux-2.6.25-rc1/include/linux/ext4_fs_extents.h
> ===================================================================
> --- linux-2.6.25-rc1.orig/include/linux/ext4_fs_extents.h
> +++ linux-2.6.25-rc1/include/linux/ext4_fs_extents.h
> @@ -124,6 +124,19 @@ struct ext4_ext_path {
>  #define EXT4_EXT_CACHE_GAP	1
>  #define EXT4_EXT_CACHE_EXTENT	2
>  
> +/*
> + * to be called by ext4_ext_walk_space()
> + * negative retcode - error
> + * positive retcode - signal for ext4_ext_walk_space(), see below
> + * callback must return valid extent (passed or newly created)
> + */
> +typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
> +					struct ext4_ext_cache *,
> +					void *);
> +
> +#define EXT_CONTINUE   0
> +#define EXT_BREAK      1
> +#define EXT_REPEAT     2
>  
>  #define EXT_MAX_BLOCK	0xffffffff
>  
> @@ -221,6 +234,7 @@ extern int ext4_ext_try_to_merge(struct 
>  				 struct ext4_extent *);
>  extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
>  extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
> +extern int ext4_ext_walk_space(struct inode *, ext4_lblk_t, ext4_lblk_t, ext_prepare_callback, void *);
>  extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
>  							struct ext4_ext_path *);
>  extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

