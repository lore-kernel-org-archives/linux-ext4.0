From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Use offset_in_page() instead of manual calculation
Date: Tue, 5 Oct 2010 10:34:06 +0200
Message-ID: <20101005083406.GB3514@quack.suse.cz>
References: <1286208220-5151-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab0JEIfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Oct 2010 04:35:01 -0400
Content-Disposition: inline
In-Reply-To: <1286208220-5151-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-10-10 01:03:40, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  Thanks. Merged.

								Honza
> ---
>  fs/jbd/transaction.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 981449c..c9bb7a7 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -711,7 +711,7 @@ done:
>  		J_EXPECT_JH(jh, buffer_uptodate(jh2bh(jh)),
>  			    "Possible IO failure.\n");
>  		page = jh2bh(jh)->b_page;
> -		offset = ((unsigned long) jh2bh(jh)->b_data) & ~PAGE_MASK;
> +		offset = offset_in_page(jh2bh(jh)->b_data);
>  		source = kmap_atomic(page, KM_USER0);
>  		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
>  		kunmap_atomic(source, KM_USER0);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
