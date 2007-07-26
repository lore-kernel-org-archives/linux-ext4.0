From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] basic delayed allocation in ext4
Date: Thu, 26 Jul 2007 17:05:28 +0530
Message-ID: <46A88700.2090807@linux.vnet.ibm.com>
References: <46A86294.6050608@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <46A86294.6050608@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Alex Tomas wrote:
> Good day,
> 
> please review ...
> 
> thanks, Alex
> 
> Basic delayed allocation in ext4
> 
> Two special ->get_block() methods are introduced:
> 
>  * ext4_da_get_block_prep()
>    to be used with ->prepare_write(), defers allocation till flush
>  * ext4_da_get_block_write()
>    to be used with mpage_da_writepages(), allocate blocks and correct 
> on-disk size
> 
> Current implementation works with data=writeback only, you should
> mount filesystem with delalloc,data=writeback options.
> 
> TODO:
>  * reservation
>  * data=ordered
>  * quota
>  * bmap
> 
> Signed-off-by: Alex Tomas <alex@clusterfs.com>
> 


[.. snip...]

>  /*
>   * Test whether an inode is a fast symlink.
>   */
> @@ -1291,6 +1293,142 @@ static int ext4_journalled_commit_write(
>  }
> 
>  /*
> + * this is a special callback for ->prepare_write() only
> + * it's intention is to return mapped block or reserve space
> + */
> +static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> +                struct buffer_head *bh_result, int create)
> +{
> +    int ret = 0;
> +
> +    BUG_ON(create == 0);
> +    BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
> +
> +    /* first, we need to know whether the block is allocated already
> +     * XXX: when the filesystem has a lot of free blocks, we could
> +     * reserve even allocated blocks to save this lookup */
> +    ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
> +    if (ret >= 0) {


I guess this should be (ret > 0)


> +        if (buffer_mapped(bh_result)) {
> +            bh_result->b_size = (ret << inode->i_blkbits);
> +        } else {
> +            /* OK, the block isn't allocated yet, let's reserve space */
> +            /* XXX: call reservation here */



[...snip..]

epare_write(struct file *file, struct page *page,
> +                          unsigned from, unsigned to)
> +{
> +    return block_prepare_write(page, from, to, ext4_da_get_block_prep);
> +}
> +
> +    return ret;
> +}
> +
> +static int ext4_da_writepages(struct address_space *mapping,
> +                struct writeback_control *wbc)
> +{
> +    return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> +}


I was not able to find mpage_da_writepages()..



-aneesh
