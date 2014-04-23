From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Use EXT_MAX_BLOCKS in ext4_es_can_be_merged()
Date: Wed, 23 Apr 2014 15:27:36 +0800
Message-ID: <20140423072735.GA3602@gmail.com>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
 <1397585302-27175-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51597 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaDWHVI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 03:21:08 -0400
Received: by mail-pb0-f49.google.com with SMTP id rr13so495708pbb.22
        for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2014 00:21:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1397585302-27175-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 08:08:22PM +0200, Lukas Czerner wrote:
> In ext4_es_can_be_merged() when checking whether we can merge two
> extents we should use EXT_MAX_BLOCKS instead of defining it manually.
> Also if it is really the case we should notify userspace because clearly
> there is a bug in extent status tree implementation since this should
> never happen.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks for fixing this.  It looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/extents_status.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 3c47b4e..b38d71a 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -344,8 +344,14 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
>  	if (ext4_es_status(es1) != ext4_es_status(es2))
>  		return 0;
>  
> -	if (((__u64) es1->es_len) + es2->es_len > 0xFFFFFFFFULL)
> +	if (((__u64) es1->es_len) + es2->es_len > EXT_MAX_BLOCKS) {
> +		pr_warn("ES assertion failed when merging extents. "
> +			"The sum of lengths of es1 (%d) and es2 (%d) "
> +			"is bigger than allowed file size (%d)\n",
> +			es1->es_len, es2->es_len, EXT_MAX_BLOCKS);
> +		WARN_ON(1);
>  		return 0;
> +	}
>  
>  	if (((__u64) es1->es_lblk) + es1->es_len != es2->es_lblk)
>  		return 0;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
