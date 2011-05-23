From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix comment to match the code in
 jbd2__journal_start()
Date: Tue, 24 May 2011 00:32:07 +0200
Message-ID: <20110523223207.GL4716@quack.suse.cz>
References: <1306167478-28682-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1EWWcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 18:32:10 -0400
Content-Disposition: inline
In-Reply-To: <1306167478-28682-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-05-11 00:17:58, Eryu Guan wrote:
> jbd2__journal_start() returns an ERR_PTR() value rather than NULL on
> failure.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
  Thanks, but please include Ted Ts'o <tytso@mit.edu> in JBD2 patches.
Thanks.

Ted, I've realized that MAINTAINERS has only entry like:
JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
M:      Andrew Morton <akpm@linux-foundation.org>
M:      Jan Kara <jack@suse.cz>
L:      linux-ext4@vger.kernel.org
S:      Maintained
F:      fs/jbd*/
F:      include/linux/ext*jbd*.h
F:      include/linux/jbd*.h

I guess you should add a separate entry for JBD2 so that people will find
you ;).

								Honza
> ---
>  fs/jbd2/transaction.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..7e6a5d6 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -316,7 +316,8 @@ static handle_t *new_handle(int nblocks)
>   * This function is visible to journal users (like ext3fs), so is not
>   * called with the journal already locked.
>   *
> - * Return a pointer to a newly allocated handle, or NULL on failure
> + * Return a pointer to a newly allocated handle, or an ERR_PTR() value
> + * on failure.
>   */
>  handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
>  {
> -- 
> 1.7.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
