From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Remove useless condition in if statement.
Date: Thu, 19 Mar 2015 17:24:29 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503191723590.1399@localhost.localdomain>
References: <1426555914-731-1-git-send-email-weiyuan.wei@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wei Yuan <weiyuan.wei@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbbCSQYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2015 12:24:39 -0400
In-Reply-To: <1426555914-731-1-git-send-email-weiyuan.wei@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Mar 2015, Wei Yuan wrote:

> Date: Tue, 17 Mar 2015 09:31:54 +0800
> From: Wei Yuan <weiyuan.wei@huawei.com>
> To: tytso@mit.edu, adilger.kernel@dilger.ca
> Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: [PATCH] ext4: Remove useless condition in if statement.
> 
> In this if statement, the previous condition is useless, the later one has covered it.

Looks good, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>
> ---
>  fs/ext4/xattr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1e09fc7..f2ccad7 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -639,8 +639,7 @@ ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
>  		free += EXT4_XATTR_LEN(name_len);
>  	}
>  	if (i->value) {
> -		if (free < EXT4_XATTR_SIZE(i->value_len) ||
> -		    free < EXT4_XATTR_LEN(name_len) +
> +		if (free < EXT4_XATTR_LEN(name_len) +
>  			   EXT4_XATTR_SIZE(i->value_len))
>  			return -ENOSPC;
>  	}
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
