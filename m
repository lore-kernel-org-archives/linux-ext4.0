From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext3: truncate block allocated on a failed ext3_write_begin
Date: Fri, 29 Aug 2008 12:33:24 +0400
Message-ID: <m33akoi5kb.fsf@dmon-lap.sw.ru>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:12274 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYH2Inp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2008 04:43:45 -0400
In-Reply-To: <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message of "Thu\, 28 Aug 2008 22\:57\:52 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> For blocksize < pagesize we need to remove blocks that
> got allocte in block_wirte_begin if we fail with ENOSPC
> for later blocks. block_write_begin internally does
> this if it allocated page locally. This make sure
> we don't have blocks outisde inode.i_size during
> ENOSPC
BTW why this check was moved from generic_XXX_write to fs speciffic code?
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext3/inode.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ebfec4d..f8424ad 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1186,6 +1186,13 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
>  		ext3_journal_stop(handle);
>  		unlock_page(page);
>  		page_cache_release(page);
> +		/*
> +		 * block_write_begin may have instantiated a few blocks
> +		 * outside i_size.  Trim these off again. Don't need
> +		 * i_size_read because we hold i_mutex.
> +		 */
> +		if (pos + len > inode->i_size)
> +			vmtruncate(inode, inode->i_size);
>  	}
>  	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
> -- 
> 1.6.0.1.90.g27a6e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
