From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Fix comment to match the code in journal_start()
Date: Tue, 24 May 2011 00:28:55 +0200
Message-ID: <20110523222855.GK4716@quack.suse.cz>
References: <1306167454-28638-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab1EWW24 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 18:28:56 -0400
Content-Disposition: inline
In-Reply-To: <1306167454-28638-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-05-11 00:17:34, Eryu Guan wrote:
> journal_start returns an ERR_PTR() value rather than NULL on failure.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
  Tnanks. Merged.

								Honza
> ---
>  fs/jbd/transaction.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 60d2319..f7ee81a 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -266,7 +266,8 @@ static handle_t *new_handle(int nblocks)
>   * This function is visible to journal users (like ext3fs), so is not
>   * called with the journal already locked.
>   *
> - * Return a pointer to a newly allocated handle, or NULL on failure
> + * Return a pointer to a newly allocated handle, or an ERR_PTR() value
> + * on failure.
>   */
>  handle_t *journal_start(journal_t *journal, int nblocks)
>  {
> -- 
> 1.7.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
