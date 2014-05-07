From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v3] ext4: fix data integrity sync in ordered mode
Date: Thu, 08 May 2014 08:08:09 +0900
Message-ID: <000701cf6a49$36964b90$a3c2e2b0$@samsung.com>
References: <001c01cf69b3$59c09710$0d41c530$@samsung.com>
 <20140507135556.GA12433@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Jan Kara' <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19767 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEGXIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 May 2014 19:08:12 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N5800NW089M3470@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 08 May 2014 08:08:10 +0900 (KST)
In-reply-to: <20140507135556.GA12433@quack.suse.cz>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Wed 07-05-14 14:15:24, Namjae Jeon wrote:
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
> > To avoid this issue, we can use set_page_writeback_keepwrite instead of
> > set_page_writeback, which doesn't clear TOWRITE tag.
> >
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>   The patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW you should also cc linux-mm@kvack.org with this patch since it touches
> the mm code.
Okay. Thanks for your review!
> 
> 									Honza

