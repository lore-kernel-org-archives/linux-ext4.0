Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbeLJQRI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 11:17:08 -0500
Date: Mon, 10 Dec 2018 17:17:04 +0100
From: Jan Kara <jack@suse.cz>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 1/2] ext4: try to merge unwritten extents who are also
 not under io
Message-ID: <20181210161704.GP29289@quack2.suse.cz>
References: <20181125085031.7141-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181125085031.7141-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 25-11-18 16:50:31, Xiaoguang Wang wrote:
> Currently in ext4_can_extents_be_merged(), if one file has unwritten
> extents under io, we will not merge any other unwritten extents, even
> they are not in range of those unwritten extents under io. This limit
> is coarse, indeed we can merge these unwritten extents that are not
> under io.
> 
> Here add a new ES_IO_B flag to track unwritten extents under io in
> extents status tree. When we try to merge unwritten extents, search
> given extents in extents status tree, if not found, then we can merge
> these unwritten extents.
> 
> Note currently we only track unwritten extents under io.

Thanks for the patch.
 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 240b6dea5441..a93378cd1152 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1713,6 +1713,33 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
>  	return err;
>  }
>  
> +static int ext4_unwritten_extent_under_io(struct inode *inode,
> +			struct ext4_extent *ex1, struct ext4_extent *ex2)
> +{

What if this took just starting block and length? There's no big point in
passing two extents here...

> +	unsigned short len;
> +
> +	/*
> +	 * The check for IO to unwritten extent is somewhat racy as we
> +	 * increment i_unwritten / set EXT4_STATE_DIO_UNWRITTEN only after
> +	 * dropping i_data_sem. But reserved blocks should save us in that
> +	 * case.
> +	 */
> +	if (atomic_read(&EXT4_I(inode)->i_unwritten) == 0)
> +		return 0;
> +
> +	len = ext4_ext_get_actual_len(ex1);
> +	if (ext4_es_scan_range(inode, &ext4_es_is_under_io, ex1->ee_block,
> +	    ex1->ee_block + len - 1))
> +		return 1;
> +
> +	len = ext4_ext_get_actual_len(ex2);
> +	if (ext4_es_scan_range(inode, &ext4_es_is_under_io, ex2->ee_block,
> +	    ex2->ee_block + len - 1))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  int
>  ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  				struct ext4_extent *ex2)
> @@ -1744,7 +1771,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  	 */
>  	if (ext4_ext_is_unwritten(ex1) &&
>  	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
> -	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
> +	    ext4_unwritten_extent_under_io(inode, ex1, ex2) ||
>  	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))

I'd check ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN before
ext4_unwritten_extent_under_io() as that is a cheaper check. Also we know
that extents are adjacent so we can just call:

	ext4_unwritten_extent_under_io(inode, le32_to_cpu(ex1->ee_block),
					ext1_ee_len + ext2_ee_len)

and save one extent status tree lookup & iteration.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..516966197257 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -704,6 +704,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
>  				       map->m_lblk + map->m_len - 1))
>  			status |= EXTENT_STATUS_DELAYED;
> +		/*
> +		 * track unwritten extent under io. when io completes, we'll
                   ^ capital T                      ^ capital W

> +		 * convert unwritten extent to written, ext4_es_insert_extent()
> +		 * will be called again to insert this written extent, then
> +		 * EXTENT_STATUS_IO will be cleared automatically, see remove
> +		 * logic in ext4_es_insert_extent().
> +		 */
> +		if ((status & EXTENT_STATUS_UNWRITTEN) && (flags &
> +		    EXT4_GET_BLOCKS_IO_SUBMIT))
> +			status |= EXTENT_STATUS_IO;
>  		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
>  					    map->m_pblk, status);
>  		if (ret < 0) {

OK, but you fail to clear EXTENT_STATUS_IO if we fail to submit IO for some
reason or if the IO ends with IO error, don't you? I guess for these error
cases you can just iterate through all the range covered by ioend and clear
EXTENT_STATUS_IO bits. We don't care about performance in that case and it
is the simplest solution I see.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
