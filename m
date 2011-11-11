From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v2 2/8] ext4: Add new data structures and related
 functions to count io types
Date: Fri, 11 Nov 2011 10:58:11 +0000
Message-ID: <1321009091.2710.41.camel@menhir>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
	 <1320921294-30321-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab1KKK4g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Nov 2011 05:56:36 -0500
In-Reply-To: <1320921294-30321-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> A per-cpu counter is defined to store io types in ext4. We define 10 io types
> in ext4, which includes 9 metadata types and 1 data type. Read and write
> operations are counted separately. When checks 'Issue' flag, filesystem needs
> to lock buffer.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> ---
>  fs/ext4/ext4.h  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c |   19 +++++++++++++++++++
>  2 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5b0e26a..39a1495 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1108,6 +1108,23 @@ struct ext4_super_block {
>  #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
>  
>  /*
> + * ext4 io types
> + */
> +enum {
> +	EXT4_IOS_SUPER_BLOCK = 0,
> +	EXT4_IOS_GROUP_DESC,
> +	EXT4_IOS_INODE_BITMAP,
> +	EXT4_IOS_BLOCK_BITMAP,
> +	EXT4_IOS_INODE_TABLE,
> +	EXT4_IOS_EXTENT_BLOCK,
> +	EXT4_IOS_INDIRECT_BLOCK,
> +	EXT4_IOS_DIR_ENTRY,
> +	EXT4_IOS_EXTENDED_ATTR,
> +	EXT4_IOS_REGULAR_DATA,
> +	EXT4_IOS_TYPE_END,
> +};
> +
> +/*
>   * fourth extended-fs super-block data in memory
>   */
>  struct ext4_sb_info {
> @@ -1284,6 +1301,11 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
>  	}
>  }
>  
> +static inline unsigned ext4_blocks_per_page(struct inode *inode)
> +{
> +	return PAGE_CACHE_SIZE >> inode->i_blkbits;
> +}
> +
>  /*
>   * Inode dynamic state flags
>   */
> @@ -1926,6 +1948,37 @@ extern int ext4_group_extend(struct super_block *sb,
>  				ext4_fsblk_t n_blocks_count);
>  
>  /* super.c */
> +extern void __ext4_io_stat(int, int, unsigned long);
> +#define ext4_ios_read(bh, type, count)					\
> +	do {								\
> +		if (!bh)						\
> +			break;						\
> +		lock_buffer(bh);					\
> +		if (buffer_issue(bh)) {					\
> +			clear_buffer_issue(bh);				\
> +			__ext4_io_stat(READ, type, count);		\
> +		}							\
> +		unlock_buffer(bh);					\
> +	} while (0)
Why not just test_and_clear_bit(BH_Issue) ? I don't follow why the
buffer needs to be locked and unlocked,

Steve.


