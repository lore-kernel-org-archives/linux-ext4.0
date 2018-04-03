From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v8 05/18] ext4, dax: introduce ext4_dax_aops
Date: Tue, 3 Apr 2018 13:50:03 +0200
Message-ID: <20180403115003.qfbedsjtxwirqkh6@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246895649.36038.5391043415273091960.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <152246895649.36038.5391043415273091960.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Fri 30-03-18 21:02:36, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/ext4/inode.c |   42 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c94780075b04..249a97b19181 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2725,12 +2725,6 @@ static int ext4_writepages(struct address_space *mapping,
>  	percpu_down_read(&sbi->s_journal_flag_rwsem);
>  	trace_ext4_writepages(inode, wbc);
>  
> -	if (dax_mapping(mapping)) {
> -		ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev,
> -						  wbc);
> -		goto out_writepages;
> -	}
> -
>  	/*
>  	 * No pages to write? This is mainly a kludge to avoid starting
>  	 * a transaction for special inodes like journal inode on last iput()
> @@ -2955,6 +2949,27 @@ static int ext4_writepages(struct address_space *mapping,
>  	return ret;
>  }
>  
> +static int ext4_dax_writepages(struct address_space *mapping,
> +			       struct writeback_control *wbc)
> +{
> +	int ret;
> +	long nr_to_write = wbc->nr_to_write;
> +	struct inode *inode = mapping->host;
> +	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
> +
> +	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
> +		return -EIO;
> +
> +	percpu_down_read(&sbi->s_journal_flag_rwsem);
> +	trace_ext4_writepages(inode, wbc);
> +
> +	ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev, wbc);
> +	trace_ext4_writepages_result(inode, wbc, ret,
> +				     nr_to_write - wbc->nr_to_write);
> +	percpu_up_read(&sbi->s_journal_flag_rwsem);
> +	return ret;
> +}
> +
>  static int ext4_nonda_switch(struct super_block *sb)
>  {
>  	s64 free_clusters, dirty_clusters;
> @@ -3857,10 +3872,6 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  	if (ext4_has_inline_data(inode))
>  		return 0;
>  
> -	/* DAX uses iomap path now */
> -	if (WARN_ON_ONCE(IS_DAX(inode)))
> -		return 0;
> -
>  	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
>  	if (iov_iter_rw(iter) == READ)
>  		ret = ext4_direct_IO_read(iocb, iter);
> @@ -3946,6 +3957,13 @@ static const struct address_space_operations ext4_da_aops = {
>  	.error_remove_page	= generic_error_remove_page,
>  };
>  
> +static const struct address_space_operations ext4_dax_aops = {
> +	.writepages		= ext4_dax_writepages,
> +	.direct_IO		= noop_direct_IO,
> +	.set_page_dirty		= noop_set_page_dirty,
> +	.invalidatepage		= noop_invalidatepage,
> +};
> +
>  void ext4_set_aops(struct inode *inode)
>  {
>  	switch (ext4_inode_journal_mode(inode)) {
> @@ -3958,7 +3976,9 @@ void ext4_set_aops(struct inode *inode)
>  	default:
>  		BUG();
>  	}
> -	if (test_opt(inode->i_sb, DELALLOC))
> +	if (IS_DAX(inode))
> +		inode->i_mapping->a_ops = &ext4_dax_aops;
> +	else if (test_opt(inode->i_sb, DELALLOC))
>  		inode->i_mapping->a_ops = &ext4_da_aops;
>  	else
>  		inode->i_mapping->a_ops = &ext4_aops;
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
