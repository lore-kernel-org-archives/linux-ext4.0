Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48131 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbeJDSnK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Oct 2018 14:43:10 -0400
Date: Thu, 4 Oct 2018 13:50:12 +0200
From: Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Message-ID: <20181004115012.s5isxzw4zt4g26y3@localhost.localdomain>
References: <20181004104640.28326-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004104640.28326-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2018 at 12:46:40PM +0200, Jan Kara wrote:
> The code cleaning transaction's lists of checkpoint buffers has a bug
> where it increases bh refcount only after releasing
> journal->j_list_lock. Thus the following race is possible:
> 
> CPU0					CPU1
> jbd2_log_do_checkpoint()
> 					jbd2_journal_try_to_free_buffers()
> 					  __journal_try_to_free_buffer(bh)
>   ...
>   while (transaction->t_checkpoint_io_list)
>   ...
>     if (buffer_locked(bh)) {
> 
> <-- IO completes now, buffer gets unlocked -->
> 
>       spin_unlock(&journal->j_list_lock);
> 					    spin_lock(&journal->j_list_lock);
> 					    __jbd2_journal_remove_checkpoint(jh);
> 					    spin_unlock(&journal->j_list_lock);
> 					  try_to_free_buffers(page);
>       get_bh(bh) <-- accesses freed bh
> 
> Fix the problem by grabbing bh reference before unlocking
> journal->j_list_lock.

Hi Jan,

nice catch. The patch looks good, you can add

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Btw, do you by any chance have a reproducer for this ?

-Lukas

> 
> Fixes: dc6e8d669cf5cb3ff84707c372c0a2a8a5e80845
> Fixes: be1158cc615fd723552f0d9912087423c7cadda5
> Reported-by: syzbot+7f4a27091759e2fe7453@syzkaller.appspotmail.com
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd2/checkpoint.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index c125d662777c..26f8d7e46462 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -251,8 +251,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  		bh = jh2bh(jh);
>  
>  		if (buffer_locked(bh)) {
> -			spin_unlock(&journal->j_list_lock);
>  			get_bh(bh);
> +			spin_unlock(&journal->j_list_lock);
>  			wait_on_buffer(bh);
>  			/* the journal_head may have gone by now */
>  			BUFFER_TRACE(bh, "brelse");
> @@ -333,8 +333,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  		jh = transaction->t_checkpoint_io_list;
>  		bh = jh2bh(jh);
>  		if (buffer_locked(bh)) {
> -			spin_unlock(&journal->j_list_lock);
>  			get_bh(bh);
> +			spin_unlock(&journal->j_list_lock);
>  			wait_on_buffer(bh);
>  			/* the journal_head may have gone by now */
>  			BUFFER_TRACE(bh, "brelse");
> -- 
> 2.16.4
> 
