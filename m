From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 24/36] fs: jbd2: escape a string with special chars on a
 kernel-doc
Date: Mon, 15 May 2017 15:05:47 +0200
Message-ID: <20170515130547.GH16182@quack2.suse.cz>
References: <cover.1494596071.git.mchehab@s-opensource.com>
 <97087d218a047d8d166c02f7f9b62dd8890963d5.1494596071.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97087d218a047d8d166c02f7f9b62dd8890963d5.1494596071.git.mchehab@s-opensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 12-05-17 11:00:07, Mauro Carvalho Chehab wrote:
> kernel-doc will try to interpret a foo() string, except if
> properly escaped.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index fe7f4a373436..38e1dcabbaca 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1066,10 +1066,10 @@ static bool jbd2_write_access_granted(handle_t *handle, struct buffer_head *bh,
>   * @handle: transaction to add buffer modifications to
>   * @bh:     bh to be used for metadata writes
>   *
> - * Returns an error code or 0 on success.
> + * Returns: error code or 0 on success.
>   *
>   * In full data journalling mode the buffer may be of type BJ_AsyncData,
> - * because we're write()ing a buffer which is also part of a shared mapping.
> + * because we're ``write()ing`` a buffer which is also part of a shared mapping.
>   */
>  
>  int jbd2_journal_get_write_access(handle_t *handle, struct buffer_head *bh)
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
