From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: remove alignment padding from ext4_inode_info on
 64 bit builds
Date: Fri, 20 Aug 2010 15:11:31 -0500
Message-ID: <4C6EE173.3030204@redhat.com>
References: <1282144088.2068.16.camel@castor.rsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	lkml <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab0HTULl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 16:11:41 -0400
In-Reply-To: <1282144088.2068.16.camel@castor.rsk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Richard Kennedy wrote:
> Reorder structure ext4_inode_info to remove 16 bytes of alignment
> padding on 64 bit builds. This shrinks its size from 904 to 888 bytes
> with (CONFIG_EXT4_S_XATTR=y && CONFIG_QUOTA=n).
>     
> This will allow this structure to use one fewer cache lines.
> 
> Also change type of i_delalloc_reserved_flag to bool to better reflect
> its usage.
> 
> compiled & tested on x86_64


Looks good to me; there is still a bit of padding at the end:

        qsize_t                    i_reserved_quota;     /*   864     8 */
        struct list_head           i_completed_io_list;  /*   872    16 */
        spinlock_t                 i_completed_io_lock;  /*   888     4 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 14 boundary (896 bytes) --- */
        ext4_io_end_t *            cur_aio_dio;          /*   896     8 */
        tid_t                      i_sync_tid;           /*   904     4 */
        tid_t                      i_datasync_tid;       /*   908     4 */


but it wouldn't save a cacheline anyway...

-Eric

> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ---
> patch against 2.6.36-rc1
> 
> Early testing shows more consistent results ( i.e. smaller standard
> deviations) on my AMD X2 setup, but I shall re-run these tests to check
> if this is repeatable.
> 
> regards
> Richard
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 889ec9d..b63a8e3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -750,10 +750,11 @@ struct ext4_inode_info {
>  	 * near to their parent directory's inode.
>  	 */
>  	ext4_group_t	i_block_group;
> -	unsigned long	i_state_flags;		/* Dynamic state flags */
> -	unsigned long	i_flags;
>  
>  	ext4_lblk_t		i_dir_start_lookup;
> +
> +	unsigned long	i_state_flags;		/* Dynamic state flags */
> +	unsigned long	i_flags;
>  #ifdef CONFIG_EXT4_FS_XATTR
>  	/*
>  	 * Extended attributes can be read independently of the main file
> @@ -816,13 +817,14 @@ struct ext4_inode_info {
>  	unsigned int i_reserved_data_blocks;
>  	unsigned int i_reserved_meta_blocks;
>  	unsigned int i_allocated_meta_blocks;
> -	unsigned short i_delalloc_reserved_flag;
> -	sector_t i_da_metadata_calc_last_lblock;
> -	int i_da_metadata_calc_len;
> +	bool i_delalloc_reserved_flag;
>  
>  	/* on-disk additional length */
>  	__u16 i_extra_isize;
>  
> +	sector_t i_da_metadata_calc_last_lblock;
> +	int i_da_metadata_calc_len;
> +
>  	spinlock_t i_block_reservation_lock;
>  #ifdef CONFIG_QUOTA
>  	/* quota space reservation, managed internally by quota code */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

