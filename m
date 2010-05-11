From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 04/11] jbd2:  use NULL instead of 0 when pointer is
 needed
Date: Tue, 11 May 2010 10:05:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1005111004390.28092@pobox.suse.cz>
References: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu> <1272634478-4127-5-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab0EKIFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 04:05:01 -0400
In-Reply-To: <1272634478-4127-5-git-send-email-wfp5p@virginia.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Apr 2010, Bill Pemberton wrote:

> Fixes sparse warning:
> 
> fs/jbd2/journal.c:1892:9: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> CC: linux-ext4@vger.kernel.org
> ---
>  fs/jbd2/journal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index c03d4dc..bc2ff59 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1889,7 +1889,7 @@ static struct kmem_cache *get_slab(size_t size)
>  	BUG_ON(i >= JBD2_MAX_SLABS);
>  	if (unlikely(i < 0))
>  		i = 0;
> -	BUG_ON(jbd2_slab[i] == 0);
> +	BUG_ON(jbd2_slab[i] == NULL);
>  	return jbd2_slab[i];
>  }

This doesn't seem to be picked up as per today's linux-next. I have 
applied the patch to my queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
