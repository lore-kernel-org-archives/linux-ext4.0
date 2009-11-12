From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/jbd: Export log_start_commit to fix ext3 build
Date: Thu, 12 Nov 2009 10:34:03 +0100
Message-ID: <20091112093403.GA14528@duck.suse.cz>
References: <20091112085843.GA2682@excalibur.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Stefan Schmidt <stefan@datenfreihafen.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZKLJeA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 04:34:00 -0500
Content-Disposition: inline
In-Reply-To: <20091112085843.GA2682@excalibur.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-11-09 09:58:43, Stefan Schmidt wrote:
> From 9bf22057947bfaeef14287dd03ac8f058e4dd43a Mon Sep 17 00:00:00 2001
> From: Stefan Schmidt <stefan@datenfreihafen.org>
> Date: Thu, 12 Nov 2009 09:53:50 +0100
> Subject: [PATCH] fs/jbd: Export log_start_commit to fix ext3 build.
> 
> This fixes:
> ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
> 
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
  Argh :(. Thanks! My test kernels have ext3 compiled in... Merged and will
send Linus pull request in a minute.

									Honza

> ---
>  fs/jbd/journal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 49d5cd6..4160afa 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -73,6 +73,7 @@ EXPORT_SYMBOL(journal_errno);
>  EXPORT_SYMBOL(journal_ack_err);
>  EXPORT_SYMBOL(journal_clear_err);
>  EXPORT_SYMBOL(log_wait_commit);
> +EXPORT_SYMBOL(log_start_commit);
>  EXPORT_SYMBOL(journal_start_commit);
>  EXPORT_SYMBOL(journal_force_commit_nested);
>  EXPORT_SYMBOL(journal_wipe);
> -- 
> 1.6.5.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
