From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] jbd2: set to NULL after kmem_cache_destroy
Date: Mon, 5 Feb 2018 09:00:06 -0800
Message-ID: <20180205170006.GA4838@magnolia>
References: <1517837957-1636-1-git-send-email-wanglong19@meituan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Wang Long <wanglong19@meituan.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbeBERAY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 12:00:24 -0500
Content-Disposition: inline
In-Reply-To: <1517837957-1636-1-git-send-email-wanglong19@meituan.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 05, 2018 at 09:39:17PM +0800, Wang Long wrote:
> Signed-off-by: Wang Long <wanglong19@meituan.com>
> ---
>  fs/jbd2/journal.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 93016bb..38dc24c 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2649,11 +2649,14 @@ static int __init jbd2_journal_init_handle_cache(void)
>  
>  static void jbd2_journal_destroy_handle_cache(void)
>  {
> -	if (jbd2_handle_cache)
> +	if (jbd2_handle_cache) {
>  		kmem_cache_destroy(jbd2_handle_cache);

kmem_cache_destroy already handles null pointers, so you can remove the
conditional test entirely.

--D

> -	if (jbd2_inode_cache)
> +		jbd2_handle_cache = NULL;
> +	}
> +	if (jbd2_inode_cache) {
>  		kmem_cache_destroy(jbd2_inode_cache);
> -
> +		jbd2_inode_cache = NULL;
> +	}
>  }
>  
>  /*
> -- 
> 1.8.3.1
> 
