From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/3] jbd2: only create debugfs and stats entries if	cache
 initialisation is successful
Date: Fri, 07 Mar 2008 14:24:26 -0700
Message-ID: <20080307212426.GF1881@webber.adilger.int>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
 <dcb02b202f5a84c79c9e8b1b0102e6ad52ed3b53.1204844851.git.duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58309 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbYCGVYk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 16:24:40 -0500
In-reply-to: <dcb02b202f5a84c79c9e8b1b0102e6ad52ed3b53.1204844851.git.duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 07, 2008  01:31 +0000, Duane Griffin wrote:
> jbd2 debugfs and stats entries should only be created if cache initialisation
> is successful. At the moment they are being created unconditionally which will
> leave them dangling if cache (and hence module) initialisation fails.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>

Acked-by: Andreas Dilger <adilger@sun.com>

> ---
>  fs/jbd2/journal.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 0d8a595..9d48419 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2315,10 +2315,12 @@ static int __init journal_init(void)
>  	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
>  
>  	ret = journal_init_caches();
> -	if (ret != 0)
> +	if (ret == 0) {
> +		jbd2_create_debugfs_entry();
> +		jbd2_create_jbd_stats_proc_entry();
> +	} else {
>  		jbd2_journal_destroy_caches();
> -	jbd2_create_debugfs_entry();
> -	jbd2_create_jbd_stats_proc_entry();
> +	}
>  	return ret;
>  }
>  
> -- 
> 1.5.3.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

