Return-Path: <SRS0=BVhb=PR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730775AbfAILmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 06:42:54 -0500
Date: Wed, 9 Jan 2019 12:42:51 +0100
From: Jan Kara <jack@suse.cz>
To: Jiang Ying <jiangying13@meituan.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: adjust location of journal->j_list_lock
Message-ID: <20190109114251.GF15397@quack2.suse.cz>
References: <1547004897-187803-1-git-send-email-jiangying13@meituan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547004897-187803-1-git-send-email-jiangying13@meituan.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 09-01-19 11:34:57, Jiang Ying wrote:
> From: jiangying13 <jiangying13@meituan.com>
> 
> kernel panics with kernel BUG at fs/jbd2/journal.c:2526! which is
> J_ASSERT_JH(jh, jh->b_transaction == NULL)
> 
> Locate the spinlock of journal->j_list_lock after
> J_ASSERT_JH(jh, jh->b_transaction == commit_transaction) that can ensure
> jh->b_transaction not NULL, advoiding jh->b_transaction is set NULL
> before executing __jbd2_journal_remove_checkpoint.
> 
> The bug is not easy to reproduce, the call trace is as following:
> 
>  Call Trace:
>   [<ffffffffc02b7e7b>] __jbd2_journal_remove_checkpoint+0x5b/0x160 [jbd2]
>   [<ffffffffc02b616e>] jbd2_journal_commit_transaction+0x10be/0x1950 [jbd2]
>   [<ffffffff81029557>] ? __switch_to+0xd7/0x510
>   [<ffffffffc02bba99>] kjournald2+0xc9/0x260 [jbd2]
>   [<ffffffff810b1930>] ? wake_up_atomic_t+0x30/0x30
>   [<ffffffffc02bb9d0>] ? commit_timeout+0x10/0x10 [jbd2]
>   [<ffffffff810b09af>] kthread+0xcf/0xe0
>   [<ffffffff810b08e0>] ? insert_kthread_work+0x40/0x40
>   [<ffffffff816ba358>] ret_from_fork+0x58/0x90
>   [<ffffffff810b08e0>] ? insert_kthread_work+0x40/0x40
> 
> Signed-off-by: jiangying13 <jiangying13@meituan.com>

Hum, why do you think the patch below changes anything for the assertion
failure you mention above? The code that gets additionally covered by
j_list_lock is just handling of journal head frozen & b_committed_data
buffers...

With which kernel version did you see the assertion failure?

								Honza

> ---
>  fs/jbd2/commit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 2eb55c3..19aa2b0 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -930,6 +930,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		 * We also know that the frozen data has already fired
>  		 * its triggers if they exist, so we can clear that too.
>  		 */
> +		spin_lock(&journal->j_list_lock);
>  		if (jh->b_committed_data) {
>  			jbd2_free(jh->b_committed_data, bh->b_size);
>  			jh->b_committed_data = NULL;
> @@ -944,7 +945,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  			jh->b_frozen_triggers = NULL;
>  		}
>  
> -		spin_lock(&journal->j_list_lock);
>  		cp_transaction = jh->b_cp_transaction;
>  		if (cp_transaction) {
>  			JBUFFER_TRACE(jh, "remove from old cp transaction");
> -- 
> 1.8.3.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
