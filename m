From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
 in 	failure
Date: Sat, 12 Sep 2009 00:57:19 +0800
Message-ID: <4AAA816F.6060809@gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com> <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com> <4AA0E419.7010707@rs.jp.nec.com> <4AA143B2.6060401@gmail.com> <4AA5D984.6030607@rs.jp.nec.com> <4AA60F36.9040605@gmail.com> <4AA9DAF0.2020402@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:41446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZIKQ5a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Sep 2009 12:57:30 -0400
Received: by fg-out-1718.google.com with SMTP id 22so415859fge.1
        for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 09:57:32 -0700 (PDT)
In-Reply-To: <4AA9DAF0.2020402@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,
Akira Fujita wrote:
> Hi Peng,
> Peng Tao wrote:
>>>> After applying the two patches, I run my test case with first.img as the orig file (and middle.img or
>>>> last.img as donor file). My kernel panics and I find following message in /var/log/messages after reboot:
>>> I could not reproduce this panic.
>>> Would you tell me about your test environment (1-5)?
>>>
>>> 1. What is your kernel version? (2.6.31-rc2 + ext4 patch queue + my patch?)
>> Only 2.6.31-rc2 from linus tree + your two patches. I didn't apply ext4 patch queue.
>>> 2. What FS mount options are enabled?
>> rw,noatime,relatime,commit=360
>>> 3. What options are enabled to create ext4?
>>  [bergwolf@~]$sudo tune2fs -l /dev/sda9
>> tune2fs 1.41.9 (22-Aug-2009)
>> Filesystem volume name:   <none>
>> Last mounted on:          /other
>> Filesystem UUID:          90548cb8-5748-4b18-bbe9-e7254439cb82
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
>> Filesystem flags:         signed_directory_hash 
>> Default mount options:    (none)
>> Filesystem state:         clean
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              125184
>> Block count:              500015
>> Reserved block count:     25000
>> Free blocks:              299959
>> Free inodes:              125162
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Reserved GDT blocks:      122
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         7824
>> Inode blocks per group:   489
>> Flex block group size:    16
>> Filesystem created:       Sun Sep  7 15:13:09 2008
>> Last mount time:          Tue Sep  8 15:19:44 2009
>> Last write time:          Tue Sep  8 15:19:44 2009
>> Mount count:              13
>> Maximum mount count:      36
>> Last checked:             Fri Sep  4 20:56:50 2009
>> Check interval:           15552000 (6 months)
>> Next check after:         Wed Mar  3 20:56:50 2010
>> Lifetime writes:          1128 MB
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:	          256
>> Required extra isize:     28
>> Desired extra isize:      28
>> Journal inode:            8
>> Default directory hash:   tea
>> Directory Hash Seed:      3c5f2a77-c446-4124-94f7-958ba6155f37
>> Journal backup:           inode blocks
>>> 4. Are image files  (first.img, middle.img and last.img)
>>>    same as your previous mail?
>>>    http://marc.info/?l=linux-ext4&m=124992522305319&w=2
>> Yes.
>>> 5. What arguments are set to EXT4_IOC_MOVE_EXT in your test case?
>>         move_data.donor_fd = donor_fd;
>>         move_data.orig_start = 0;
>>         move_data.donor_start = 0;
>>         move_data.len = SECTOR_TO_BLOCK(statbuf.st_blocks, fs.f_bsize); 
>>
>>         err = ioctl(orig_fd, EXT4_IOC_MOVE_EXT, &move_data);
> 
> I tried to reproduce your problem with the following steps,
> but I couldn't. Please check my procedure.
> 
> 1. Test environment
> linux2.6.31-rc2 + two patches as follows:
> http://marc.info/?l=linux-ext4&m=125186152727422&w=3
> http://marc.info/?l=linux-ext4&m=125205817410548&w=3
> 
> 2. Create ext4 filesystem and mount it
> mke2fs -t ext4 -b 4096 /dev/XXX
> mount -t ext4 -O rw,noatime,relatime,commit=360 /dev/XXX /mnt/XXX
> 
> 3. Create orig and donor files
> dd if=/dev/urandom of=/mnt/XXX/first.img bs=10M count=1
> dd if=/dev/zero of=/mnt/XXX/first.img bs=10M count=0 seek=50
> dd if=/dev/urandom of=/mnt/XXX/last.img bs=10M count=1 seek=49
> 
> 4. Call EXT4_MOVE_MOVE_EXT ioctl to files with the following arguments
> (orig_file = /mnt/XXX/first.img, donor_file = /mnt/XXX/last.img)
> move_data.orig_start = 0;
> move_data.donor_start = 0;
> move_data.len = 12152;
> ioctl(orig_fd, EXT4_IOC_MOVE_EXT, &move_data)
> 
> However, EXT4_IOC_MOVE_EXT returned ENODATA (this is a fine result by my patch)
> and it didn't occur the kernel panic which you got.
> If I chose a wrong step, please correct me.
Sorry, I didn't notice that I was at commit 7638d5322bd89d49e013a03fe2afaeb6d214fabd
of linus tree that includes a few patches after 2.6.31-rc2.
> 
> I appreciate if you could test following environment.
> - 2.6.31-rc8 + ext4 patch queue
>  (commit:bdacccd94d08a3f89e7fca676b28aa262c6d75fa) + attached patch
I can't reproduce the panic in the above environment. I believe the problem
is fixed. Thanks for your work!
> 
> Regards,
> Akira Fujita
> 
> ---
>  fs/ext4/move_extent.c |   72 +++++++++++++++++++++++++++++++++---------------
>  1 files changed, 49 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 7bfbd58..7266247 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -25,6 +25,8 @@
>  		if (IS_ERR(path)) {					\
>  			ret = PTR_ERR(path);				\
>  			path = NULL;					\
> +		} else if (path[ext_depth(inode)].p_ext == NULL) {	\
> +			ret = -ENODATA;					\
>  		}							\
>  	} while (0)
> 
> @@ -284,7 +286,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
> 
>  	if (new_flag) {
>  		get_ext_path(orig_path, orig_inode, eblock, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
> 
>  		if (ext4_ext_insert_extent(handle, orig_inode,
> @@ -295,7 +297,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
>  	if (end_flag) {
>  		get_ext_path(orig_path, orig_inode,
>  				      le32_to_cpu(end_ext->ee_block) - 1, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
> 
>  		if (ext4_ext_insert_extent(handle, orig_inode,
> @@ -554,8 +556,10 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
>   * @orig_off:		block offset of original inode
>   * @donor_off:		block offset of donor inode
>   * @max_count:		the maximun length of extents
> + *
> + * Return 0 on success, or a negative error value on failure.
>   */
> -static void
> +static int
>  mext_calc_swap_extents(struct ext4_extent *tmp_dext,
>  			      struct ext4_extent *tmp_oext,
>  			      ext4_lblk_t orig_off, ext4_lblk_t donor_off,
> @@ -564,6 +568,19 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
>  	ext4_lblk_t diff, orig_diff;
>  	struct ext4_extent dext_old, oext_old;
> 
> +	BUG_ON(orig_off != donor_off);
> +
> +	/* original and donor extents have to cover the same block offset */
> +	if (orig_off < le32_to_cpu(tmp_oext->ee_block) ||
> +	    le32_to_cpu(tmp_oext->ee_block) +
> +			ext4_ext_get_actual_len(tmp_oext) - 1 < orig_off)
> +		return -ENODATA;
> +
> +	if (orig_off < le32_to_cpu(tmp_dext->ee_block) ||
> +	    le32_to_cpu(tmp_dext->ee_block) +
> +			ext4_ext_get_actual_len(tmp_dext) - 1 < orig_off)
> +		return -ENODATA;
> +
>  	dext_old = *tmp_dext;
>  	oext_old = *tmp_oext;
> 
> @@ -591,6 +608,8 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
> 
>  	copy_extent_status(&oext_old, tmp_dext);
>  	copy_extent_status(&dext_old, tmp_oext);
> +
> +	return 0;
>  }
> 
>  /**
> @@ -632,12 +651,12 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
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
> @@ -647,8 +666,10 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  	dext = donor_path[depth].p_ext;
>  	tmp_dext = *dext;
> 
> -	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
> +	err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
>  				      donor_off, count);
> +	if (err)
> +		goto out;
> 
>  	/* Loop for the donor extents */
>  	while (1) {
> @@ -679,7 +700,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  		if (orig_path)
>  			ext4_ext_drop_refs(orig_path);
>  		get_ext_path(orig_path, orig_inode, orig_off, err);
> -		if (orig_path == NULL)
> +		if (err)
>  			goto out;
>  		depth = ext_depth(orig_inode);
>  		oext = orig_path[depth].p_ext;
> @@ -694,7 +715,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  			ext4_ext_drop_refs(donor_path);
>  		get_ext_path(donor_path, donor_inode,
>  				      donor_off, err);
> -		if (donor_path == NULL)
> +		if (err)
>  			goto out;
>  		depth = ext_depth(donor_inode);
>  		dext = donor_path[depth].p_ext;
> @@ -705,9 +726,10 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  		}
>  		tmp_dext = *dext;
> 
> -		mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
> -					      donor_off,
> -					      count - replaced_count);
> +		err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
> +					   donor_off, count - replaced_count);
> +		if (err)
> +			goto out;
>  	}
> 
>  out:
> @@ -1156,27 +1178,27 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  		len -= block_end - file_end;
> 
>  	get_ext_path(orig_path, orig_inode, block_start, ret);
> -	if (orig_path == NULL)
> +	if (ret)
>  		goto out2;
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
> -	 * Get proper extent whose ee_block is beyond block_start
> -	 * if block_start was within the hole.
> +	 * Get proper starting location of block replacement if block_start was
> +	 * within the hole.
>  	 */
>  	if (le32_to_cpu(ext_cur->ee_block) +
>  		ext4_ext_get_actual_len(ext_cur) - 1 < block_start) {
> +		/*
> +		 * The hole exists between extents or the tail of
> +		 * original file.
> +		 */
>  		last_extent = mext_next_extent(orig_inode,
>  					holecheck_path, &ext_cur);
>  		if (last_extent < 0) {
> @@ -1189,8 +1211,12 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  			ret = last_extent;
>  			goto out;
>  		}
> -	}
> -	seq_start = block_start;
> +		seq_start = le32_to_cpu(ext_cur->ee_block);
> +	} else if (le32_to_cpu(ext_cur->ee_block) > block_start)
> +		/* The hole exists at the beginning of original file. */
> +		seq_start = le32_to_cpu(ext_cur->ee_block);
> +	else
> +		seq_start = block_start;
> 
>  	/* No blocks within the specified range. */
>  	if (le32_to_cpu(ext_cur->ee_block) > block_end) {
> @@ -1292,7 +1318,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  			ext4_ext_drop_refs(holecheck_path);
>  		get_ext_path(holecheck_path, orig_inode,
>  				      seq_start, ret);
> -		if (holecheck_path == NULL)
> +		if (ret)
>  			break;
>  		depth = holecheck_path->p_depth;
> 
> @@ -1300,7 +1326,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  		if (orig_path)
>  			ext4_ext_drop_refs(orig_path);
>  		get_ext_path(orig_path, orig_inode, seq_start, ret);
> -		if (orig_path == NULL)
> +		if (ret)
>  			break;
> 
>  		ext_cur = holecheck_path[depth].p_ext;
> 


-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.



