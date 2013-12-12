From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/3] ext4: Retry allocation when inline->extent
 conversion failed
Date: Thu, 12 Dec 2013 14:44:22 +0800
Message-ID: <20131212064422.GA16199@gmail.com>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
 <1386670440-3158-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60134 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3LLGlO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 01:41:14 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so11564037pbb.9
        for <linux-ext4@vger.kernel.org>; Wed, 11 Dec 2013 22:41:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1386670440-3158-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Tue, Dec 10, 2013 at 11:13:58AM +0100, Jan Kara wrote:
> Similarly as other ->write_begin functions in ext4, also
> ext4_da_write_inline_data_begin() should retry allocation if the
> conversion failed because of ENOSPC. This avoids returning ENOSPC
> prematurely because of uncommitted block deletions.

I don't see why we need to try again here.  If there is no enough space
in inline data, ext4_da_convert_inline_data_to_extent() just read the
inline data into a page and clear EXT4_STATE_MAY_INLINE_DATA flag.  If
we try again, we will encounter an ENOSPC error again.  So why do we
need to retry allocation?

Thanks,
                                                - Zheng

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inline.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index bae987549dc3..ed6e71fe5e9d 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -849,11 +849,13 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
>  	handle_t *handle;
>  	struct page *page;
>  	struct ext4_iloc iloc;
> +	int retries;
>  
>  	ret = ext4_get_inode_loc(inode, &iloc);
>  	if (ret)
>  		return ret;
>  
> +retry_journal:
>  	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
> @@ -875,6 +877,11 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
>  							    inode,
>  							    flags,
>  							    fsdata);
> +		ext4_journal_stop(handle);
> +		handle = NULL;
> +		if (ret == -ENOSPC &&
> +		    ext4_should_retry_alloc(inode->i_sb, &retries))
> +			goto retry_journal;
>  		goto out;
>  	}
>  
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
