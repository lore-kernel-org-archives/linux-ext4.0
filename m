From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Remove unnecessary goto statement
Date: Mon, 4 Oct 2010 17:57:52 +0200
Message-ID: <20101004155752.GA11422@quack.suse.cz>
References: <1286205239-2662-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0JDP6q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Oct 2010 11:58:46 -0400
Content-Disposition: inline
In-Reply-To: <1286205239-2662-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-10-10 00:13:59, Namhyung Kim wrote:
> Remove goto statement which jumps to very next line. Also remove
> target label because it is no longer used anywhere.
  Thanks. Merged into my tree.

								Honza
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/jbd/transaction.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 5ae71e7..981449c 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -293,9 +293,7 @@ handle_t *journal_start(journal_t *journal, int nblocks)
>  		jbd_free_handle(handle);
>  		current->journal_info = NULL;
>  		handle = ERR_PTR(err);
> -		goto out;
>  	}
> -out:
>  	return handle;
>  }
>  
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
