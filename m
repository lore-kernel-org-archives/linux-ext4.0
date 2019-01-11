Return-Path: <SRS0=9YHU=PT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfAKKab (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 11 Jan 2019 05:30:31 -0500
Date: Fri, 11 Jan 2019 11:30:29 +0100
From: Jan Kara <jack@suse.cz>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
Message-ID: <20190111103029.GA4098@quack2.suse.cz>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
 <20190110112023.GF15790@quack2.suse.cz>
 <5b2cb7b3-1eff-21d2-cf12-ee844f54eda0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b2cb7b3-1eff-21d2-cf12-ee844f54eda0@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 11-01-19 14:11:31, zhangyi (F) wrote:
> On 2019/1/10 19:20, Jan Kara Wrote:
> > On Thu 10-01-19 14:12:02, zhangyi (F) wrote:
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
> >>
> >> This patch mark buffer as freed when it already belongs to the
> >> committing transaction in jbd2_journal_forget(), so that commit code
> >> knows it should clear dirty bits when it is done with the buffer.
> >>
> >> This problem can be reproduced by xfstests generic/455 easily with
> >> seeds (3246 3247 3248 3249).
> >>
> >> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> >> Cc: stable@vger.kernel.org
> > 
> > Thanks a lot for the analysis and the patch! I fully agree with your
> > analysis however I think just setting buffer as freed isn't completely
> > correct. The problem is following: The metadata buffer X has been modified
> > by the commiting transaction - let's call it A. It has been freed in the
> > currently running transaction B. Now jbd2_journal_forget() clears
> > b_next_transaction and if you set buffer freed flag, X will not be added to
> > the checkpoint list. So when transaction A finishes commit, it can get
> > checkpointed (without writing out X) before transaction B commits. So if a
> > crash occurs before B commits, we'd loose modification of X from
> > transaction A and thus cause filesystem corruption.
> > 
> Thanks for your explanation! There are still two points I don't quite
> understand.
> 
> I check all three cases of doing checkpoint. IIUC, both jbd2_journal_destroy()
> and jbd2_journal_flush() wait the current running transaction B to complete
> before doing checkpoint besides __jbd2_log_wait_for_space(). So I guess this is
> the case that you mentioned of transaction A could be checkpointed before B
> commits, am I right?

Yes, __jbd2_log_wait_for_space() can checkpoint already committed
transactions (i.e., A in our case) without waiting for the running
transaction (B in our case).

> For another case, jbd2_update_log_tail() will be invoked after transaction B
> complete, so the problem above also can't happen here, right?

I'm not sure which "another case" you speak about here...

> > What rather needs to happen is the same thing that is done in
> > journal_unmap_buffer() in this case: We set buffer freed flag and we also
> > set b_next_transaction to the currently running transaction (B). This will
> > prevent A from being checkpointed before B commits and thus avoids the
> > problem above.
> > 
> Sorry, I don't get this point. I find that the difference between setting
> b_next_transaction or not is just re-added the buffer X to the BJ_Reserved
> list or not. How could we avoid the problem above.

Currently, X will be removed from transaction B by jbd2_journal_revoke().
So once A commits, it will not be in the running transaction and thus
checkpoint of A can complete before B is committed.

If we set X->b_next_transaction to B, X will be part of transaction B. The
handling of buffer_freed() buffer in commit code thus will not clear
jbddirty bit and X will get inserted in X as buffer for checkpointing. And
thus checkpoint of A will not be able to complete before B commits, fixing
the problem I have described.
 
> BTW, I am thinking of a similar case. If we modify buffer X instead of
> revork it in the transaction B, we also need to avoid transaction A from
> being checkpointed before B commits, because current buffer X contains the
> modified data (modified by B). So we should prevent writing it before
> B commits, otherwise it will corrupt metadata. How do we handle this
> situation now?

Buffers that are part of the running transaction never have buffer_dirty
bit set (look how jbd2_journal_file_buffer() clears this bit). Thus
background writeback will not write these buffers. Also checkpointing code
checks whether the buffer is part of running / committing transaction and
handles these buffers specially exactly because they cannot be written out
directly.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
