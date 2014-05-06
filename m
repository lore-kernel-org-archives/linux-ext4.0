From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v2] ext4: fix data integrity sync in ordered mode
Date: Wed, 07 May 2014 08:10:14 +0900
Message-ID: <000801cf6980$56da9650$048fc2f0$@samsung.com>
References: <000f01cf68f7$54205690$fc6103b0$@samsung.com>
 <20140506100106.GB9291@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Jan Kara' <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaEFXKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2014 19:10:17 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N5600AL4DP32AA0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 07 May 2014 08:10:15 +0900 (KST)
In-reply-to: <20140506100106.GB9291@quack.suse.cz>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Tue 06-05-14 15:49:29, Namjae Jeon wrote:
> > When we perform a data integrity sync we tag all the dirty pages with
> > PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.
> > Later we check for this tag in write_cache_pages_da and creates a
> > struct mpage_da_data containing contiguously indexed pages tagged with this
> > tag and sync these pages with a call to mpage_da_map_and_submit.
> > This process is done in while loop until all the PAGECACHE_TAG_TOWRITE pages
> > are synced. We also do journal start and stop in each iteration.
> > journal_stop could initiate journal commit which would call ext4_writepage
> > which in turn will call ext4_bio_write_page even for delayed OR unwritten
> > buffers. When ext4_bio_write_page is called for such buffers, even though it
> > does not sync them but it clears the PAGECACHE_TAG_TOWRITE of the corresponding
> > page and hence these pages are also not synced by the currently running data
> > integrity sync. We will end up with dirty pages although sync is completed.
> >
> > This could cause a potential data loss when the sync call is followed by a
> > truncate_pagecache call, which is exactly the case in collapse_range.
> > (It will cause generic/127 failure in xfstests)
> >
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>   Just one comment below:
> 
> ...
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 023cf08..f7358c5 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2438,6 +2438,43 @@ int test_set_page_writeback(struct page *page)
> >  }
> >  EXPORT_SYMBOL(test_set_page_writeback);
> >
> > +int test_set_page_writeback_keepwrite(struct page *page)
> > +{
> > +	struct address_space *mapping = page_mapping(page);
> > +	int ret;
> > +	bool locked;
> > +	unsigned long memcg_flags;
> > +
> > +	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
> > +	if (mapping) {
> > +		struct backing_dev_info *bdi = mapping->backing_dev_info;
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&mapping->tree_lock, flags);
> > +		ret = TestSetPageWriteback(page);
> > +		if (!ret) {
> > +			radix_tree_tag_set(&mapping->page_tree,
> > +						page_index(page),
> > +						PAGECACHE_TAG_WRITEBACK);
> > +			if (bdi_cap_account_writeback(bdi))
> > +				__inc_bdi_stat(bdi, BDI_WRITEBACK);
> > +		}
> > +		if (!PageDirty(page))
> > +			radix_tree_tag_clear(&mapping->page_tree,
> > +						page_index(page),
> > +						PAGECACHE_TAG_DIRTY);
> > +		spin_unlock_irqrestore(&mapping->tree_lock, flags);
> > +	} else {
> > +		ret = TestSetPageWriteback(page);
> > +	}
> > +	if (!ret)
> > +		account_page_writeback(page);
> > +	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
> > +	return ret;
> > +
> > +}
> > +EXPORT_SYMBOL(test_set_page_writeback_keepwrite);
> > +
>   Since the two variants of test_set_page_writeback() differ only a little
> I'd rather have __test_set_page_writeback(page, keep_write) and then define
> test_set_page_writeback() and test_set_page_writeback_keepwrite() as calls
> to that function. Other than that the patch is OK. Thanks!
Hi Jan.
Okay, I will change it.
Thanks for review!
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

