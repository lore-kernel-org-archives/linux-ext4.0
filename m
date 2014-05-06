From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: fix data integrity sync in ordered mode
Date: Tue, 6 May 2014 12:01:06 +0200
Message-ID: <20140506100106.GB9291@quack.suse.cz>
References: <000f01cf68f7$54205690$fc6103b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558AbaEFKBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 06:01:10 -0400
Content-Disposition: inline
In-Reply-To: <000f01cf68f7$54205690$fc6103b0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-05-14 15:49:29, Namjae Jeon wrote:
> When we perform a data integrity sync we tag all the dirty pages with
> PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.
> Later we check for this tag in write_cache_pages_da and creates a
> struct mpage_da_data containing contiguously indexed pages tagged with this
> tag and sync these pages with a call to mpage_da_map_and_submit.
> This process is done in while loop until all the PAGECACHE_TAG_TOWRITE pages
> are synced. We also do journal start and stop in each iteration.
> journal_stop could initiate journal commit which would call ext4_writepage
> which in turn will call ext4_bio_write_page even for delayed OR unwritten
> buffers. When ext4_bio_write_page is called for such buffers, even though it
> does not sync them but it clears the PAGECACHE_TAG_TOWRITE of the corresponding
> page and hence these pages are also not synced by the currently running data
> integrity sync. We will end up with dirty pages although sync is completed.
> 
> This could cause a potential data loss when the sync call is followed by a
> truncate_pagecache call, which is exactly the case in collapse_range.
> (It will cause generic/127 failure in xfstests)
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
  Just one comment below:

...
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 023cf08..f7358c5 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2438,6 +2438,43 @@ int test_set_page_writeback(struct page *page)
>  }
>  EXPORT_SYMBOL(test_set_page_writeback);
>  
> +int test_set_page_writeback_keepwrite(struct page *page)
> +{
> +	struct address_space *mapping = page_mapping(page);
> +	int ret;
> +	bool locked;
> +	unsigned long memcg_flags;
> +
> +	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
> +	if (mapping) {
> +		struct backing_dev_info *bdi = mapping->backing_dev_info;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&mapping->tree_lock, flags);
> +		ret = TestSetPageWriteback(page);
> +		if (!ret) {
> +			radix_tree_tag_set(&mapping->page_tree,
> +						page_index(page),
> +						PAGECACHE_TAG_WRITEBACK);
> +			if (bdi_cap_account_writeback(bdi))
> +				__inc_bdi_stat(bdi, BDI_WRITEBACK);
> +		}
> +		if (!PageDirty(page))
> +			radix_tree_tag_clear(&mapping->page_tree,
> +						page_index(page),
> +						PAGECACHE_TAG_DIRTY);
> +		spin_unlock_irqrestore(&mapping->tree_lock, flags);
> +	} else {
> +		ret = TestSetPageWriteback(page);
> +	}
> +	if (!ret)
> +		account_page_writeback(page);
> +	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
> +	return ret;
> +
> +}
> +EXPORT_SYMBOL(test_set_page_writeback_keepwrite);
> +
  Since the two variants of test_set_page_writeback() differ only a little
I'd rather have __test_set_page_writeback(page, keep_write) and then define
test_set_page_writeback() and test_set_page_writeback_keepwrite() as calls
to that function. Other than that the patch is OK. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
