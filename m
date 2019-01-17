Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfAQNLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Jan 2019 08:11:41 -0500
Date: Thu, 17 Jan 2019 14:11:38 +0100
From: Jan Kara <jack@suse.cz>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v2] jbd2: make sure dirty flag is cleared while revorking
 a buffer which belongs to older transaction
Message-ID: <20190117131138.GD9378@quack2.suse.cz>
References: <1547645903-57295-1-git-send-email-yi.zhang@huawei.com>
 <20190116143645.GG26069@quack2.suse.cz>
 <942a44fe-4350-2f59-9913-c47ee6ff9031@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <942a44fe-4350-2f59-9913-c47ee6ff9031@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 17-01-19 18:58:51, zhangyi (F) wrote:
> On 2019/1/16 22:36, Jan Kara Wrote:
> > On Wed 16-01-19 21:38:23, zhangyi (F) wrote:
> >> Now, we capture a data corruption problem on ext4 while we're truncating
> >> an extent index block. Imaging that if we are revoking a buffer which
> >> has been journaled by the committing transaction, the buffer's jbddirty
> >> flag will not be cleared in jbd2_journal_forget(), so the commit code
> >> will set the buffer dirty flag again after refile the buffer.
> >>
> >> fsx                               kjournald2
> >>                                   jbd2_journal_commit_transaction
> >> jbd2_journal_revoke                commit phase 1~5...
> >>  jbd2_journal_forget
> >>    belongs to older transaction    commit phase 6
> >>    jbddirty not clear               __jbd2_journal_refile_buffer
> >>                                      __jbd2_journal_unfile_buffer
> >>                                       test_clear_buffer_jbddirty
> >>                                        mark_buffer_dirty
> >>
> >> Finally, if the freed extent index block was allocated again as data
> >> block by some other files, it may corrupt the file data when writing
> >> cached pages later, such as during umount time.
> > 
> > Thanks for the patch! I'm sorry this didn't occur to me the first time when
> > I was reading your analysis but now there is one question I have: When the
> > freed extent index block gets reallocated as data block, we should call
> > clean_bdev_aliases() or clean_bdev_bh_alias() for it (it usually happens
> > shortly after block allocation either in ext4_block_write_begin() or
> > mpage_map_one_extent()). Which will clear the buffer dirty bit and thus
> > should avoid this kind of corruption. So how come this didn't work? Is it
> > that we for some reason didn't call clean_bdev_aliases() or that function
> > didn't work for some reason? Can you debug that with your reproducer?
> > Thanks a lot!
> > 
> 
> Indeed，I figure out that the root cause is
> ext4_ext_convert_to_initialized() return incorrect when it does try to
> zeroout the head of the first extent (see case 2 or 5)[1].  If we zeroout
> the tail of the second extent firstly, and then it will set "map->m_len"
> to "allocated" directly in case 2 or 5(cut the zeroed out range).
> Finally, ext4_ext_handle_unwritten_extents() will skip invoking
> clean_bdev_aliases() for the expanded region.
> 
> At the same time, IIUC, it also have another two problems,
> 1) It doesn't call clean_bdev_aliases() for the head of the extent if zeroout extra
> blocks (unmap the tail of the extent only)[2].
> 2) If "allocated = ee_len - (map->m_lblk - ee_block)" but doesn't zeroout any extra
> blocks at all, the return value maybe large than requested and cover the uninitialized
> region (seems doesn't serious recently)[3].

OK, I see. Thanks for debugging this!

> For the problem [1][2], I think we could move clean_bdev_aliases() into
> ext4_ext_zeroout().  For the problem [3], it seems that
> ext4_ext_convert_to_initialized() return extra blocks number is
> unnecessary, return the request value on success is also fine after we do
> the previous job. Suggestions?

I have always considered clean_bdev_aliases() logic somewhat fragile since
it's not very clear when we should clear the aliases and bugs like the
above are the result of that. So I think that the best would be to make
sure that jbd2_journal_forget() cannot result in leaving dirty buffer head
behind. And your current patch goes a long way towards that. I think the
only remaining piece is to call __bforget() instead of __brelse() in
not_jbd branch of jbd2_journal_forget(). And then we can have a cleanup
patch removing all clean_bdev_aliases() and clean_bdev_bh_alias() calls
from ext4...

								Honza

> >> This patch mark buffer as freed and set j_next_transaction to the new
> >> transaction when it already belongs to the committing transaction in
> >> jbd2_journal_forget(), so that commit code knows it should clear dirty
> >> bits when it is done with the buffer.
> >>
> >> This problem can be reproduced by xfstests generic/455 easily with
> >> seeds (3246 3247 3248 3249).
> >>
> >> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  fs/jbd2/transaction.c | 15 ++++++++++-----
> >>  1 file changed, 10 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> >> index f07f006..f7f9647 100644
> >> --- a/fs/jbd2/transaction.c
> >> +++ b/fs/jbd2/transaction.c
> >> @@ -1609,14 +1609,19 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
> >>  		/* However, if the buffer is still owned by a prior
> >>  		 * (committing) transaction, we can't drop it yet... */
> >>  		JBUFFER_TRACE(jh, "belongs to older transaction");
> >> -		/* ... but we CAN drop it from the new transaction if we
> >> -		 * have also modified it since the original commit. */
> >> +		/* ... but we CAN drop it from the new transaction, mark
> >> +		 * buffer as freed and set j_next_transaction to the new
> >> +		 * transaction so that commit code knows it should clear
> >> +		 * dirty bits when it is done with the buffer. */
> >>  
> >> -		if (jh->b_next_transaction) {
> >> -			J_ASSERT(jh->b_next_transaction == transaction);
> >> +		set_buffer_freed(bh);
> >> +
> >> +		if (!jh->b_next_transaction) {
> >>  			spin_lock(&journal->j_list_lock);
> >> -			jh->b_next_transaction = NULL;
> >> +			jh->b_next_transaction = transaction;
> >>  			spin_unlock(&journal->j_list_lock);
> >> +		} else {
> >> +			J_ASSERT(jh->b_next_transaction == transaction);
> >>  
> >>  			/*
> >>  			 * only drop a reference if this transaction modified
> >> -- 
> >> 2.7.4
> >>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
