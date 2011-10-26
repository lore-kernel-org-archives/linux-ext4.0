From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH v2] ext4: Create helper function for EXT4_IO_END_UNWRITTEN
 and i_aiodio_unwritten.
Date: Wed, 26 Oct 2011 15:47:43 +0800
Message-ID: <4EA7BB1F.5060008@tao.ma>
References: <1317375716-6125-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34581 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754602Ab1JZHrr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 03:47:47 -0400
In-Reply-To: <1317375716-6125-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/30/2011 05:41 PM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten
> should be done simultaneously since ext4_end_io_nolock always clear the
> flag and decrease the counter in the same time.
> 
> We have found some bugs that the flag is set while leaving
> i_aiodio_unwritten unchanged(commit 32c80b32c053d). So this patch just tries
> to create a helper function to wrap them to avoid any future bug.
> The idea is inspired by Eric.
> 
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
ping?
> ---
> This patch is based on another bug fix which hasn't been merged yet.
> http://marc.info/?l=linux-ext4&m=131598536608613&w=2
> 
>  fs/ext4/ext4.h    |    9 +++++++++
>  fs/ext4/extents.c |   18 ++++++------------
>  fs/ext4/inode.c   |    5 +----
>  fs/ext4/page-io.c |    6 ++----
>  4 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4cb030c..a9325f5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1241,6 +1241,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>  }
>  
> +static inline void ext4_set_io_unwritten_flag(struct inode *inode,
> +					      struct ext4_io_end *io_end)
> +{
> +	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +	}
> +}
> +
>  /*
>   * Inode dynamic state flags
>   */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8f23589..31750af 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3190,12 +3190,9 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>  		 * that this IO needs to conversion to written when IO is
>  		 * completed
>  		 */
> -		if (io) {
> -			if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
> -				io->flag = EXT4_IO_END_UNWRITTEN;
> -				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> -			}
> -		} else
> +		if (io)
> +			ext4_set_io_unwritten_flag(inode, io);
> +		else
>  			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
>  		if (ext4_should_dioread_nolock(inode))
>  			map->m_flags |= EXT4_MAP_UNINIT;
> @@ -3574,12 +3571,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		 * that we need to perform conversion when IO is done.
>  		 */
>  		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> -			if (io) {
> -				if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
> -					io->flag = EXT4_IO_END_UNWRITTEN;
> -					atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> -				}
> -			} else
> +			if (io)
> +				ext4_set_io_unwritten_flag(inode, io);
> +			else
>  				ext4_set_inode_state(inode,
>  						     EXT4_STATE_DIO_UNWRITTEN);
>  		}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4b37501..5d6fc9b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2685,10 +2685,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
>  	 * but being more careful is always safe for the future change.
>  	 */
>  	inode = io_end->inode;
> -	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> -		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> -		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> -	}
> +	ext4_set_io_unwritten_flag(inode, io_end);
>  
>  	/* Add the io_end to per-inode completed io list*/
>  	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 92f38ee..f5eec5e 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -350,10 +350,8 @@ submit_and_retry:
>  	if ((io_end->num_io_pages >= MAX_IO_PAGES) &&
>  	    (io_end->pages[io_end->num_io_pages-1] != io_page))
>  		goto submit_and_retry;
> -	if (buffer_uninit(bh) && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> -		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> -		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> -	}
> +	if (buffer_uninit(bh))
> +		ext4_set_io_unwritten_flag(inode, io_end);
>  	io->io_end->size += bh->b_size;
>  	io->io_next_block++;
>  	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));

