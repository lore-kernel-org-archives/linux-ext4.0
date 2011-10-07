From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [Ext4 Secure Delete 2/7v4] ext4: Secure Delete: Add
	ext4_ind_hole_lookup function
Date: Fri, 7 Oct 2011 10:47:32 -0700
Message-ID: <20111007174732.GG12447@tux1.beaverton.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-3-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1317971465-8517-3-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 07, 2011 at 12:11:00AM -0700, Allison Henderson wrote:
> This patch adds a new ext4_ind_hole_lookup function that
> will be used to identify and skip over holes during a
> secure delete operation
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> :100644 100644 db54ce4... 5c9f88c... M	fs/ext4/ext4.h
> :100644 100644 0962642... 2fe9dfd... M	fs/ext4/indirect.c
> :100644 100644 c4da98a... 9dc8c14... M	fs/ext4/inode.c
>  fs/ext4/ext4.h     |    5 +++
>  fs/ext4/indirect.c |    2 +-
>  fs/ext4/inode.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index db54ce4..5c9f88c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2241,6 +2241,11 @@ extern int ext4_bio_write_page(struct ext4_io_submit *io,
>  /* mmp.c */
>  extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
> 
> +/* indirects.c */
> +extern int ext4_block_to_path(struct inode *inode,
> +			ext4_lblk_t i_block,
> +			ext4_lblk_t offsets[4], int *boundary);
> +
>  /* BH_Uninit flag: blocks are allocated but uninitialized on disk */
>  enum ext4_state_bits {
>  	BH_Uninit	/* blocks are allocated but uninitialized on disk */
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 0962642..2fe9dfd 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -69,7 +69,7 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
>   * get there at all.
>   */
> 
> -static int ext4_block_to_path(struct inode *inode,
> +int ext4_block_to_path(struct inode *inode,
>  			      ext4_lblk_t i_block,
>  			      ext4_lblk_t offsets[4], int *boundary)
>  {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c4da98a..9dc8c14 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -640,6 +640,79 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
>  	return bh;
>  }
> 
> +/*
> + * ext4_in_hole_lookup
> + *
> + * Returns the size of the hole located at the given block up to
> + * the first boundry, or 0 if there is no hole. Returns negative on err.

boundary

> + */
> +static int ext4_ind_hole_lookup(struct inode *inode, ext4_lblk_t block)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct buffer_head *bh;
> +	ext4_lblk_t offsets[4];
> +	ext4_lblk_t offset;
> +	__le32 *children;
> +	__le32 blk;
> +	int blocks_to_boundary = 0;
> +	int depth = 0;
> +	int hole_size = 0;
> +	unsigned int i, j;
> +
> +	depth = ext4_block_to_path(inode, block, offsets, &blocks_to_boundary);
> +
> +	if (depth == 0)
> +		return 0;
> +
> +	offset = offsets[0];
> +	blk = EXT4_I(inode)->i_data[offset];
> +	if (blk == 0) {
> +		for (i = *offsets; i < EXT4_NDIR_BLOCKS; i++) {
> +			if (EXT4_I(inode)->i_data[i] == 0)
> +				hole_size++;
> +			else
> +				break;
> +		}
> +		return hole_size;
> +	}
> +
> +
> +	for (j = 1; j < depth; j++) {
> +		offset = offsets[j];
> +		bh = sb_getblk(sb, le32_to_cpu(blk));
> +		if (unlikely(!bh))
> +			return -EIO;
> +
> +		if (!bh_uptodate_or_lock(bh)) {
> +			if (bh_submit_read(bh) < 0) {
> +				put_bh(bh);
> +				return -EIO;
> +			}
> +			/* validate block references */
> +			if (ext4_check_indirect_blockref(inode, bh)) {
> +				put_bh(bh);
> +				return -EIO;
> +			}
> +		}
> +
> +		blk = ((__le32 *)bh->b_data)[offset];
> +		/* Reader: end */
> +		if (blk == 0) {
> +			children = (__le32 *)(bh->b_data);
> +			for (i = offset; i < offset +
> +					blocks_to_boundary; i++) {
> +				if (children[i] == 0)
> +					hole_size++;
> +				else
> +					break;
> +			}

Do you need a put_bh here somewhere?

--D
