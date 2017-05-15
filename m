From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 19/36] fs: jbd2: make jbd2_journal_start() kernel-doc
 parseable
Date: Mon, 15 May 2017 15:06:08 +0200
Message-ID: <20170515130608.GI16182@quack2.suse.cz>
References: <cover.1494596071.git.mchehab@s-opensource.com>
 <eae9e9e158f441020ae347f4bf07de19dec3305d.1494596071.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <eae9e9e158f441020ae347f4bf07de19dec3305d.1494596071.git.mchehab@s-opensource.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 12-05-17 11:00:02, Mauro Carvalho Chehab wrote:
> kernel-doc script expects that a function documentation to
> be just before the function, otherwise it will be ignored.
> 
> So, move the kernel-doc markup to the right place.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 9ee4832b6f8b..fe7f4a373436 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -409,25 +409,6 @@ static handle_t *new_handle(int nblocks)
>  	return handle;
>  }
>  
> -/**
> - * handle_t *jbd2_journal_start() - Obtain a new handle.
> - * @journal: Journal to start transaction on.
> - * @nblocks: number of block buffer we might modify
> - *
> - * We make sure that the transaction can guarantee at least nblocks of
> - * modified buffers in the log.  We block until the log can guarantee
> - * that much space. Additionally, if rsv_blocks > 0, we also create another
> - * handle with rsv_blocks reserved blocks in the journal. This handle is
> - * is stored in h_rsv_handle. It is not attached to any particular transaction
> - * and thus doesn't block transaction commit. If the caller uses this reserved
> - * handle, it has to set h_rsv_handle to NULL as otherwise jbd2_journal_stop()
> - * on the parent handle will dispose the reserved one. Reserved handle has to
> - * be converted to a normal handle using jbd2_journal_start_reserved() before
> - * it can be used.
> - *
> - * Return a pointer to a newly allocated handle, or an ERR_PTR() value
> - * on failure.
> - */
>  handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int rsv_blocks,
>  			      gfp_t gfp_mask, unsigned int type,
>  			      unsigned int line_no)
> @@ -478,6 +459,25 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int rsv_blocks,
>  EXPORT_SYMBOL(jbd2__journal_start);
>  
>  
> +/**
> + * handle_t *jbd2_journal_start() - Obtain a new handle.
> + * @journal: Journal to start transaction on.
> + * @nblocks: number of block buffer we might modify
> + *
> + * We make sure that the transaction can guarantee at least nblocks of
> + * modified buffers in the log.  We block until the log can guarantee
> + * that much space. Additionally, if rsv_blocks > 0, we also create another
> + * handle with rsv_blocks reserved blocks in the journal. This handle is
> + * is stored in h_rsv_handle. It is not attached to any particular transaction
> + * and thus doesn't block transaction commit. If the caller uses this reserved
> + * handle, it has to set h_rsv_handle to NULL as otherwise jbd2_journal_stop()
> + * on the parent handle will dispose the reserved one. Reserved handle has to
> + * be converted to a normal handle using jbd2_journal_start_reserved() before
> + * it can be used.
> + *
> + * Return a pointer to a newly allocated handle, or an ERR_PTR() value
> + * on failure.
> + */
>  handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
>  {
>  	return jbd2__journal_start(journal, nblocks, 0, GFP_NOFS, 0, 0);
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
