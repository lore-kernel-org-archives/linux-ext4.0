From: Jan Kara <jack@suse.cz>
Subject: Re: [BUILD FAILURE][PATCH] Export symbol log_start_commit. ext3
	needs it.
Date: Thu, 12 Nov 2009 10:37:33 +0100
Message-ID: <20091112093733.GB14528@duck.suse.cz>
References: <200911121106.52555.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>
To: Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZKLJh3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 04:37:29 -0500
Content-Disposition: inline
In-Reply-To: <200911121106.52555.knikanth@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-11-09 11:06:52, Nikanth Karthikesan wrote:
> The linus git fails to build with the message
> ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
> Top commit id: aa021baa3295fa6e3f367d80f8955dd5176656eb
> 
> Export log_start_commit to modules. ext3 needs it to be built
> as a module.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
  Thanks! I've already merged a fix.

							Honza
> 
> ---
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 49d5cd6..2e13cf3 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -72,6 +72,7 @@ EXPORT_SYMBOL(journal_abort);
>  EXPORT_SYMBOL(journal_errno);
>  EXPORT_SYMBOL(journal_ack_err);
>  EXPORT_SYMBOL(journal_clear_err);
> +EXPORT_SYMBOL(log_start_commit);
>  EXPORT_SYMBOL(log_wait_commit);
>  EXPORT_SYMBOL(journal_start_commit);
>  EXPORT_SYMBOL(journal_force_commit_nested);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
