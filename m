From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V1] fs/buffer.c: Remove unnecessary init operation
 after, allocating buffer_head.
Date: Tue, 23 Apr 2013 10:54:52 +0200
Message-ID: <20130423085452.GC4596@quack.suse.cz>
References: <51748E45.8060806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
	tytso@mit.edu, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: majianpeng <majianpeng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51748E45.8060806@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 22-04-13 09:11:33, majianpeng wrote:
> Because alloc 'struct buffer_head' using kmem_cache_zalloc,so it doesn't
> need to call 'init_buffer(bh, NULL, NULL)' and other set-zero-operation.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
  Looks good. If noone objects, I'll merge the patch through my tree.

								Honza
> ---
>  fs/buffer.c       | 2 --
>  fs/jbd/journal.c  | 2 --
>  fs/jbd2/journal.c | 2 --
>  3 files changed, 6 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b4dcb34..52b7739 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -865,8 +865,6 @@ try_again:
>  
>          /* Link the buffer to its page */
>          set_bh_page(bh, page, offset);
> -
> -        init_buffer(bh, NULL, NULL);
>      }
>      return head;
>  /*
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 81cc7ea..865c430 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -310,8 +310,6 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>  
>      new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
>      /* keep subsequent assertions sane */
> -    new_bh->b_state = 0;
> -    init_buffer(new_bh, NULL, NULL);
>      atomic_set(&new_bh->b_count, 1);
>      new_jh = journal_add_journal_head(new_bh);    /* This sleeps */
>  
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index ed10991..8b220f1 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -367,8 +367,6 @@ retry_alloc:
>      }
>  
>      /* keep subsequent assertions sane */
> -    new_bh->b_state = 0;
> -    init_buffer(new_bh, NULL, NULL);
>      atomic_set(&new_bh->b_count, 1);
>      new_jh = jbd2_journal_add_journal_head(new_bh);    /* This sleeps */
>  
> -- 
> 1.8.2.rc2.4.g7799588
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
