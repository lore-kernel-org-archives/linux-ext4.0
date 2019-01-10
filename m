Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727806AbfAJLU0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 06:20:26 -0500
Date: Thu, 10 Jan 2019 12:20:23 +0100
From: Jan Kara <jack@suse.cz>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
Message-ID: <20190110112023.GF15790@quack2.suse.cz>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-01-19 14:12:02, zhangyi (F) wrote:
> Now, we capture a data corruption problem on ext4 while we're truncating
> an extent index block. Imaging that if we are revoking a buffer which
> has been journaled by the committing transaction, the buffer's jbddirty
> flag will not be cleared in jbd2_journal_forget(), so the commit code
> will set the buffer dirty flag again after refile the buffer.
> 
> fsx                               kjournald2
>                                   jbd2_journal_commit_transaction
> jbd2_journal_revoke                commit phase 1~5...
>  jbd2_journal_forget
>    belongs to older transaction    commit phase 6
>    jbddirty not clear               __jbd2_journal_refile_buffer
>                                      __jbd2_journal_unfile_buffer
>                                       test_clear_buffer_jbddirty
>                                        mark_buffer_dirty
> 
> Finally, if the freed extent index block was allocated again as data
> block by some other files, it may corrupt the file data when writing
> cached pages later, such as during umount time.
> 
> This patch mark buffer as freed when it already belongs to the
> committing transaction in jbd2_journal_forget(), so that commit code
> knows it should clear dirty bits when it is done with the buffer.
> 
> This problem can be reproduced by xfstests generic/455 easily with
> seeds (3246 3247 3248 3249).
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Cc: stable@vger.kernel.org

Thanks a lot for the analysis and the patch! I fully agree with your
analysis however I think just setting buffer as freed isn't completely
correct. The problem is following: The metadata buffer X has been modified
by the commiting transaction - let's call it A. It has been freed in the
currently running transaction B. Now jbd2_journal_forget() clears
b_next_transaction and if you set buffer freed flag, X will not be added to
the checkpoint list. So when transaction A finishes commit, it can get
checkpointed (without writing out X) before transaction B commits. So if a
crash occurs before B commits, we'd loose modification of X from
transaction A and thus cause filesystem corruption.

What rather needs to happen is the same thing that is done in
journal_unmap_buffer() in this case: We set buffer freed flag and we also
set b_next_transaction to the currently running transaction (B). This will
prevent A from being checkpointed before B commits and thus avoids the
problem above.

								Honza

> ---
>  fs/jbd2/transaction.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4b51177..fcb65f2 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1592,6 +1592,12 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>  			if (was_modified)
>  				drop_reserve = 1;
>  		}
> +
> +		/*
> +		 * Mark buffer as freed so that commit code know it should
> +		 * clear dirty bits when it is done with the buffer.
> +		 */
> +		set_buffer_freed(bh);
>  	}
>  
>  not_jbd:
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
