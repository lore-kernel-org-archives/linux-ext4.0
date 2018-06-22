From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: handle layout changes to pinned DAX mappings
Date: Fri, 22 Jun 2018 10:19:15 +0200
Message-ID: <20180622081915.dvqd5sxx7vzoijw3@quack2.suse.cz>
References: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
 <20180620221503.25237-3-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180620221503.25237-3-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Wed 20-06-18 16:15:03, Ross Zwisler wrote:
> Follow the lead of xfs_break_dax_layouts() and add synchronization between
> operations in ext4 which remove blocks from an inode (hole punch, truncate
> down, etc.) and pages which are pinned due to DAX DMA operations.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  fs/ext4/ext4.h     |  1 +
>  fs/ext4/extents.c  | 12 ++++++++++++
>  fs/ext4/inode.c    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/truncate.h |  1 +
>  4 files changed, 62 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0b127853c584..34bccd64d83d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2460,6 +2460,7 @@ extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
>  extern int ext4_inode_attach_jinode(struct inode *inode);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern int ext4_truncate(struct inode *);
> +extern int ext4_break_layouts(struct inode *);
>  extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
>  extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
>  extern void ext4_set_inode_flags(struct inode *);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0057fe3f248d..a6aef06f455b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4820,6 +4820,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		 * released from page cache.
>  		 */
>  		down_write(&EXT4_I(inode)->i_mmap_sem);
> +
> +		ret = ext4_break_layouts(inode);
> +		if (ret) {
> +			up_write(&EXT4_I(inode)->i_mmap_sem);
> +			goto out_mutex;
> +		}
> +
>  		ret = ext4_update_disksize_before_punch(inode, offset, len);
>  		if (ret) {
>  			up_write(&EXT4_I(inode)->i_mmap_sem);
> @@ -5493,6 +5500,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	 * page cache.
>  	 */
>  	down_write(&EXT4_I(inode)->i_mmap_sem);
> +
> +	ret = ext4_break_layouts(inode);
> +	if (ret)
> +		goto out_mmap;
> +
>  	/*
>  	 * Need to round down offset to be aligned with page size boundary
>  	 * for page size > block size.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2ea07efbe016..c795e5118745 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4193,6 +4193,41 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
> +{
> +	*did_unlock = true;
> +	up_write(&ei->i_mmap_sem);
> +	schedule();
> +	down_write(&ei->i_mmap_sem);
> +}
> +
> +int ext4_break_layouts(struct inode *inode)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	struct page *page;
> +	bool retry;
> +	int error;
> +
> +	if (unlikely(!rwsem_is_locked(&ei->i_mmap_sem))) {
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}

This could be shortened as:

if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem))) {
}

couldn't it?

Besides that the patch looks to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

And I'm really wondering which protection are we still missing that you are
still able to hit the warning with these patches applied.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
