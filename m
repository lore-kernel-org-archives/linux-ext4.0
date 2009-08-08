From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 2/2] ext4: fix null pointer bug in move_extent.c
Date: Sun, 09 Aug 2009 01:18:32 +0800
Message-ID: <4A7DB368.1000709@gmail.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>	 <1249213404-6277-2-git-send-email-bergwolf@gmail.com>	 <4A76A043.20105@rs.jp.nec.com> <6149e97b0908030620w3a4b4d9em7d8b1aa4940e837d@mail.gmail.com> <4A77F049.4050301@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:15529 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZHHRSi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2009 13:18:38 -0400
Received: by wa-out-1112.google.com with SMTP id j5so462914wah.21
        for <linux-ext4@vger.kernel.org>; Sat, 08 Aug 2009 10:18:38 -0700 (PDT)
In-Reply-To: <4A77F049.4050301@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira

Sorry to response late.
Akira Fujita wrote:
> Hi Peng,
> 
> Peng Tao wrote:
>> Will there be situations where empty extents exist in the middle of an
>> extent tree? Because your patch only checks NULL extents once at the
>> begining. If some NULL extents are later found in the loop, the bug
>> still can be triggered and we should check NULL extents in
>> mext_replace_branches().
> 
> In the case of eh->entries is 0 in ext4_ext_find_extent(),
> the extent which ext4_ext_path indicates is null.
> This is happened if file blocks are not allocated yet.
> But an extent tree does not have empty extents in the middle of it, I think.
I'm afraid it does when the targeted extent points to an empty leaf.
from fs/ext4/extents.c ext4_ext_find_extent()
 681 
 682         /* find extent */
 683         ext4_ext_binsearch(inode, path + ppos, block);
 684         /* if not an empty leaf */
 685         if (path[ppos].p_ext)
 686                 path[ppos].p_block = ext_pblock(path[ppos].p_ext);
 687 
Please correct me if I am wrong.

BTW, I don't think ENOENT (translated to "No such file or directory") is a good return value , because the file is obviously out there. It just has empty extents.
> 
> I have no idea we should handle empty extents case in EXT4_IOC_MOVE_EXTENTS,
> but if yes, we should do null check at other places
> not only mext_replace_branches().
> 
> So I add this null check to get_ext_path macro
> which is used to get ext4_ext_path.
> 
> Regards,
> Akira Fujita
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  move_extent.c |   32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> --- linux-2.6.31-rc4-a/fs/ext4/move_extent.c	2009-07-23 11:32:59.000000000 +0900
> +++ linux-2.6.31-rc4-b/fs/ext4/move_extent.c	2009-08-04 15:51:04.000000000 +0900
> @@ -25,6 +25,8 @@
>  		if (IS_ERR(path)) {					\
>  			ret = PTR_ERR(path);				\
>  			path = NULL;					\
> +		} else if (path[ext_depth(inode)].p_ext == NULL) {	\
> +			ret = -ENOENT;					\
>  		}							\
>  	} while (0)
> 
> @@ -284,7 +286,7 @@ mext_insert_across_blocks(handle_t *hand
> 
>  	if (new_flag) {
>  		get_ext_path(orig_path, orig_inode, eblock, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
> 
>  		if (ext4_ext_insert_extent(handle, orig_inode,
> @@ -295,7 +297,7 @@ mext_insert_across_blocks(handle_t *hand
>  	if (end_flag) {
>  		get_ext_path(orig_path, orig_inode,
>  				      le32_to_cpu(end_ext->ee_block) - 1, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
> 
>  		if (ext4_ext_insert_extent(handle, orig_inode,
> @@ -632,12 +634,12 @@ mext_replace_branches(handle_t *handle,
> 
>  	/* Get the original extent for the block "orig_off" */
>  	get_ext_path(orig_path, orig_inode, orig_off, err);
> -	if (orig_path == NULL)
> +	if (err)
>  		goto out;
> 
>  	/* Get the donor extent for the head */
>  	get_ext_path(donor_path, donor_inode, donor_off, err);
> -	if (donor_path == NULL)
> +	if (err)
>  		goto out;
>  	depth = ext_depth(orig_inode);
>  	oext = orig_path[depth].p_ext;
> @@ -679,7 +681,7 @@ mext_replace_branches(handle_t *handle,
>  		if (orig_path)
>  			ext4_ext_drop_refs(orig_path);
>  		get_ext_path(orig_path, orig_inode, orig_off, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
>  		depth = ext_depth(orig_inode);
>  		oext = orig_path[depth].p_ext;
> @@ -694,7 +696,7 @@ mext_replace_branches(handle_t *handle,
>  			ext4_ext_drop_refs(donor_path);
>  		get_ext_path(donor_path, donor_inode,
>  				      donor_off, err);
> -		if (donor_path == NULL)
> +		if (err)
>  			goto out;
>  		depth = ext_depth(donor_inode);
>  		dext = donor_path[depth].p_ext;
> @@ -1138,7 +1140,7 @@ ext4_move_extents(struct file *o_filp, s
>  					donor_start, &len, *moved_len);
>  	mext_double_up_read(orig_inode, donor_inode);
>  	if (ret)
> -		goto out2;
> +		goto out;
> 
>  	file_end = (i_size_read(orig_inode) - 1) >> orig_inode->i_blkbits;
>  	block_end = block_start + len - 1;
> @@ -1146,20 +1148,16 @@ ext4_move_extents(struct file *o_filp, s
>  		len -= block_end - file_end;
> 
>  	get_ext_path(orig_path, orig_inode, block_start, ret);
> -	if (orig_path == NULL)
> -		goto out2;
> +	if (ret)
> +		goto out;
> 
>  	/* Get path structure to check the hole */
>  	get_ext_path(holecheck_path, orig_inode, block_start, ret);
> -	if (holecheck_path == NULL)
> +	if (ret)
>  		goto out;
> 
>  	depth = ext_depth(orig_inode);
>  	ext_cur = holecheck_path[depth].p_ext;
> -	if (ext_cur == NULL) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> 
>  	/*
>  	 * Get proper extent whose ee_block is beyond block_start
> @@ -1282,7 +1280,7 @@ ext4_move_extents(struct file *o_filp, s
>  			ext4_ext_drop_refs(holecheck_path);
>  		get_ext_path(holecheck_path, orig_inode,
>  				      seq_start, ret);
> -		if (holecheck_path == NULL)
> +		if (ret)
>  			break;
>  		depth = holecheck_path->p_depth;
> 
> @@ -1290,7 +1288,7 @@ ext4_move_extents(struct file *o_filp, s
>  		if (orig_path)
>  			ext4_ext_drop_refs(orig_path);
>  		get_ext_path(orig_path, orig_inode, seq_start, ret);
> -		if (orig_path == NULL)
> +		if (ret)
>  			break;
> 
>  		ext_cur = holecheck_path[depth].p_ext;
> @@ -1307,7 +1305,7 @@ out:
>  		ext4_ext_drop_refs(holecheck_path);
>  		kfree(holecheck_path);
>  	}
> -out2:
> +
>  	mext_inode_double_unlock(orig_inode, donor_inode);
> 
>  	if (ret)
> 
> 


-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
