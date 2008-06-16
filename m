From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 17:05:33 +0200
Message-ID: <20080616150533.GB3279@atrey.karlin.mff.cuni.cz>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, adilger@sun.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46641 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYFPPFe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 11:05:34 -0400
Content-Disposition: inline
In-Reply-To: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Aneesh,

  First, I'd like to see some short comment on what semantics
delalloc,data=ordered is going to have. At least I can imagine at least
two sensible approaches:
  1) All we guarantee is that user is not going to see uninitialized data.
We send writes to disk (and allocate blocks) whenever it fits our needs
(usually when pdflush finds them).
  2) We guarantee that when transaction commits, your data is on disk -
i.e., we allocate actual blocks on transaction commit.

  Both these possibilities have their pros and cons. Most importantly,
1) gives better disk layout while 2) gives higher consistency
guarantees. Note that with 1), it can under some circumstances happen,
that after a crash you see block 1 and 3 of your 3-block-write on disk,
while block 2 is still a hole. 1) is easy to implement (you mostly did
it below), 2) is harder. I think there should be broader consensus on
what the semantics should be (changed subject to catch more attention
;).

  A few comments to your patch are also below.

								Honza

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c  |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/jbd2/commit.c |   41 ++++++++++++--
>  2 files changed, 198 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 63355ab..7d87641 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1606,13 +1606,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
>  	return !buffer_mapped(bh) || buffer_delay(bh);
>  }
>  
> -/* FIXME!! only support data=writeback mode */
>  /*
>   * get called vi ext4_da_writepages after taking page lock
>   * We may end up doing block allocation here in case
>   * mpage_da_map_blocks failed to allocate blocks.
>   */
> -static int ext4_da_writepage(struct page *page,
> +static int ext4_da_writeback_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
>  	int ret = 0;
> @@ -1660,6 +1659,61 @@ static int ext4_da_writepage(struct page *page,
>  	return ret;
>  }
>  
> +/*
> + * get called vi ext4_da_writepages after taking page lock
> + * We may end up doing block allocation here in case
> + * mpage_da_map_blocks failed to allocate blocks.
> + *
> + * We also get called via journal_submit_inode_data_buffers
> + */
> +static int ext4_da_ordered_writepage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	int ret = 0;
> +	loff_t size;
> +	unsigned long len;
> +	handle_t *handle = NULL;
> +	struct buffer_head *page_bufs;
> +	struct inode *inode = page->mapping->host;
> +
> +	handle = ext4_journal_current_handle();
> +	if (!handle) {
> +		/*
> +		 * This can happen when we aren't called via
> +		 * ext4_da_writepages() but directly (shrink_page_list).
> +		 * We cannot easily start a transaction here so we just skip
> +		 * writing the page in case we would have to do so.
> +		 */
> +		size = i_size_read(inode);
> +
> +		page_bufs = page_buffers(page);
> +		if (page->index == size >> PAGE_CACHE_SHIFT)
> +			len = size & ~PAGE_CACHE_MASK;
> +		else
> +			len = PAGE_CACHE_SIZE;
> +
> +		if (walk_page_buffers(NULL, page_bufs, 0,
> +				len, NULL, ext4_bh_unmapped_or_delay)) {
> +			/*
> +			 * We can't do block allocation under
> +			 * page lock without a handle . So redirty
> +			 * the page and return.
> +			 * We may reach here when we do a journal commit
> +			 * via journal_submit_inode_data_buffers.
> +			 * If we don't have mapping block we just ignore
> +			 * them
> +			 *
> +			 */
> +			redirty_page_for_writepage(wbc, page);
> +			unlock_page(page);
> +			return 0;
> +		}
> +	}
> +
> +	ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> +
> +	return ret;
> +}
  If you're going to use this writepage() implementation from commit
code, you cannot simply do redirty_page_for_writepage() and bail out
when there's an unmapped buffer. You must write out at least mapped
buffers to satisfy ordering guarantees (think of filesystems with
blocksize < page size).

<snip>

Please separate changes to JBD2 into a separate patch - they should be
probably merged into ordered-mode rewrite patch later on...

> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 483183d..32ca3c3 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -22,6 +22,8 @@
>  #include <linux/pagemap.h>
>  #include <linux/jiffies.h>
>  #include <linux/crc32.h>
> +#include <linux/writeback.h>
> +#include <linux/backing-dev.h>
>  
>  /*
>   * Default IO end handler for temporary BJ_IO buffer_heads.
> @@ -185,6 +187,30 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
>  }
>  
>  /*
> + * write the filemap data using writepage() address_space_operations.
> + * We don't do block allocation here even for delalloc. We don't
> + * use writepages() because with dealyed allocation we may be doing
> + * block allocation in writepages().
> + */
> +static int journal_submit_inode_data_buffers(struct address_space *mapping)
> +{
> +	int ret;
> +	struct writeback_control wbc = {
> +		.sync_mode =  WB_SYNC_ALL,
> +		.nr_to_write = mapping->nrpages * 2,
> +		.range_start = 0,
> +		.range_end = i_size_read(mapping->host),
> +		.for_writepages = 1,
> +	};
> +
> +	if (!mapping_cap_writeback_dirty(mapping))
> +		return 0;
> +
> +	ret = generic_writepages(mapping, &wbc);
> +	return ret;
> +}
> +
> +/*
>   * Submit all the data buffers of inode associated with the transaction to
>   * disk.
>   *
> @@ -192,7 +218,7 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
>   * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
>   * operate on from being released while we write out pages.
>   */
> -static int journal_submit_inode_data_buffers(journal_t *journal,
> +static int journal_submit_data_buffers(journal_t *journal,
>  		transaction_t *commit_transaction)
  journal_submit_data_buffers() isn't a lucky name. This is how the
old function was called and so it would clash with it in the patch
series... I'd be for keeping this name and call the above
journal_submit_mapping_buffers() or just fold the above function into
journal_submit_inode_data_buffers().

>  {
>  	struct jbd2_inode *jinode;
> @@ -204,8 +230,13 @@ static int journal_submit_inode_data_buffers(journal_t *journal,
>  		mapping = jinode->i_vfs_inode->i_mapping;
>  		jinode->i_flags |= JI_COMMIT_RUNNING;
>  		spin_unlock(&journal->j_list_lock);
> -		err = filemap_fdatawrite_range(mapping, 0,
> -					i_size_read(jinode->i_vfs_inode));
> +		/*
> +		 * submit the inode data buffers. We use writepage
> +		 * instead of writepages. Because writepages can do
> +		 * block allocation  with delalloc. We need to write
> +		 * only allocated blocks here.
> +		 */
> +		err = journal_submit_inode_data_buffers(mapping);
>  		if (!ret)
>  			ret = err;
>  		spin_lock(&journal->j_list_lock);
> @@ -228,7 +259,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
>  	struct jbd2_inode *jinode, *next_i;
>  	int err, ret = 0;
>  
> -	/* For locking, see the comment in journal_submit_inode_data_buffers() */
> +	/* For locking, see the comment in journal_submit_data_buffers() */
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>  		jinode->i_flags |= JI_COMMIT_RUNNING;
> @@ -431,7 +462,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> -	err = journal_submit_inode_data_buffers(journal, commit_transaction);
> +	err = journal_submit_data_buffers(journal, commit_transaction);
>  	if (err)
>  		jbd2_journal_abort(journal, err);
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
